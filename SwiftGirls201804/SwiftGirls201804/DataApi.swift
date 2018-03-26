//
//  DataApi.swift
//  SwiftGirls201804
//
//  Created by Candy on 2018/3/19.
//  Copyright © 2018年 SwiftGirls. All rights reserved.
//

import UIKit

private var serverUrl: String = "http://opendata.cwb.gov.tw/govdownload?dataid=E-A0015-001R&authorizationkey=rdec-key-123-45678-011121314"
private var cookie = "TS01dbf791=0107dddfef75ce76139a469c1d2d19b9ae4760afeee06056375e5fa7c162241c034c7fb0f0"
private var taiwanCountyArray = ["基隆市", "臺北市", "新北市", "桃園市", "新竹市", "新竹縣", "苗栗縣", "臺中市", "南投縣", "彰化縣", "雲林縣", "嘉義市", "嘉義縣", "臺南市", "高雄市", "屏東縣", "宜蘭縣", "花蓮縣", "臺東縣", "澎湖縣", "金門縣", "連江縣"]

class DataApi: NSObject, XMLParserDelegate {
    static var shared: DataApi = DataApi()
    private static var earthquake: Earthquake? = nil

    private var elementName: String = ""
    private var shakingArea: ShakingArea? = nil
    private var stationsArray: [EqStation] = []
    private var eqStation: EqStation? = nil
    
    class func getData(completion: @escaping (_ data: Earthquake?, _ error: Error?) -> Void ) {
        let url = URL(string: serverUrl)
        guard url != nil else {
            return
        }
        
        var urlRequest = URLRequest(url: url!)
        urlRequest.addValue(cookie, forHTTPHeaderField: "Cookie")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil && data != nil else {
                return
            }
            let xmlParser = XMLParser(data: data!)
            xmlParser.delegate = self.shared
            
            let success = xmlParser.parse()
            if success {
                completion(earthquake, nil)
            } else {
                completion(
                    nil,
                    NSError(domain:"Error", code:999, userInfo:["message":"資料錯誤"])
                )
            }
        }
        task.resume()
    }
    
    // MARK: XMLParserDelegate
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        // parse 到element開始的tag
        self.elementName = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        // parse 到element的內容
        if elementName == "earthquake" {
            DataApi.earthquake = Earthquake()
        } else if elementName == "earthquakeInfo" {
            DataApi.earthquake?.earthquakeInfo = EarthquakeInfo()
        } else if elementName == "epicenter" {
            DataApi.earthquake?.earthquakeInfo?.epicenter = Epicenter()
        } else if elementName == "magnitude" {
            DataApi.earthquake?.earthquakeInfo?.magnitude = Magnitude()
        } else if elementName == "intensity" {
            DataApi.earthquake?.intensityArray = []
        } else if elementName == "shakingArea" {
            shakingArea = ShakingArea()
            stationsArray = []
        } else if elementName == "eqStation" {
            eqStation = EqStation()
        }
        guard (string.trimmingCharacters(in: [" ", "\n"])).count > 0 else {
            return
        }
        
        //earthquake
        if elementName == "earthquakeNo" {
            DataApi.earthquake?.earthquakeNo += string
        } else if elementName == "reportContent" {
            DataApi.earthquake?.reportContent += string
        } else if elementName == "web" {
            DataApi.earthquake?.web += string
        } else if elementName == "reportImageURI" {
            DataApi.earthquake?.reportImageURI += string
        } else if elementName == "shakemapImageURI" {
            DataApi.earthquake?.shakemapImageURI += string
        }
        //earthquakeInfo
        else if elementName == "originTime" {
            DataApi.earthquake?.earthquakeInfo?.originTime += string
        }
        //epicenter
        else if elementName == "epicenterLon" {
            DataApi.earthquake?.earthquakeInfo?.epicenter?.epicenterLon = Float(string) ?? 0.0
        } else if elementName == "epicenterLat" {
            DataApi.earthquake?.earthquakeInfo?.epicenter?.epicenterLat = Float(string) ?? 0.0
        } else if elementName == "location" {
            DataApi.earthquake?.earthquakeInfo?.epicenter?.location += string
        }
        //earthquakeInfo
        else if elementName == "depth" {
            DataApi.earthquake?.earthquakeInfo?.depth = Float(string) ?? 0.0
        }
        //magnitude
        else if elementName == "magnitudeType" {
            DataApi.earthquake?.earthquakeInfo?.magnitude?.magnitudeType += string
        } else if elementName == "magnitudeValue" {
            DataApi.earthquake?.earthquakeInfo?.magnitude?.magnitudeValue = Float(string) ?? 0.0
        }
        //shakingArea
        else if elementName == "areaDesc" {
            shakingArea?.areaDesc += string
        } else if elementName == "areaName" {
            shakingArea?.areaName += string
        } else if elementName == "areaIntensity" {
            shakingArea?.areaIntensity = Int(string) ?? 0
        }
        //eqStation
        else if elementName == "stationName" {
            eqStation?.stationName += string
        } else if elementName == "stationLon" {
            eqStation?.stationLon = Float(string) ?? 0.0
        } else if elementName == "stationLat" {
            eqStation?.stationLat = Float(string) ?? 0.0
        } else if elementName == "distance" {
            eqStation?.distance = Float(string) ?? 0.0
        } else if elementName == "stationIntensity" {
            eqStation?.stationIntensity = Int(string) ?? 0
        }
        
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        // parse 到element結束的tag
        if elementName == "shakingArea" && shakingArea != nil {
            shakingArea!.stationsArray = stationsArray
            DataApi.earthquake?.intensityArray?.append(shakingArea!)
        } else if elementName == "eqStation" && eqStation != nil {
            stationsArray.append(eqStation!)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        // 整份文件parse 完畢時進來
        let shakingAreaArray = DataApi.earthquake?.intensityArray?.filter({ (shakingArea) -> Bool in
            taiwanCountyArray.contains(String(shakingArea.areaDesc.prefix(3)))
        })
        
        DataApi.earthquake?.intensityArray = shakingAreaArray
    }
}

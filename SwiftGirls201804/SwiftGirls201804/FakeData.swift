//
//  FakeData.swift
//  SwiftGirls201804
//
//  Created by HsiaoShan on 2018/3/17.
//  Copyright © 2018年 SwiftGirls. All rights reserved.
//

import UIKit

class FakeData: NSObject {
    static let fakeEarthquake: [String : Any] = [
        "reportContent": "03/06-17:42宜蘭縣",
//        "reportContent": "03/06-17:42宜蘭縣近海發生規模4.8有感地震，最大震度宜蘭縣南澳3級。",
        "reportColor": "綠色",
        "reportRemark": "本報告係中央氣象局地震觀測網即時地震資料地震速報之結果。",
        "intensity": [
            "shakingArea": [
                ["areaName": "1宜蘭縣",
                 "areaIntensity": ["-unit": "級","#text": "3"]],
                ["areaName": "2新北市",
                 "areaIntensity": ["-unit": "級","#text": "2"]],
                ["areaName": "3臺北市",
                 "areaIntensity": ["-unit": "級","#text": "2"]],
                ["areaName": "4桃園市",
                 "areaIntensity": ["-unit": "級","#text": "1"]],
                ["areaName": "5新竹縣",
                 "areaIntensity": ["-unit": "級","#text": "3"]],
                ["areaName": "6新竹縣",
                 "areaIntensity": ["-unit": "級","#text": "5"]],
                ["areaName": "7新竹縣",
                 "areaIntensity": ["-unit": "級","#text": "3"]],
                ["areaName": "8新竹縣",
                 "areaIntensity": ["-unit": "級","#text": "5"]],
                ["areaName": "9新竹縣",
                 "areaIntensity": ["-unit": "級","#text": "5"]],
                ["areaName": "10新竹縣",
                 "areaIntensity": ["-unit": "級","#text": "3"]],
                ["areaName": "11新竹縣",
                 "areaIntensity": ["-unit": "級","#text": "5"]]
            ]
        ]
    ]
}

//
//  MapView.swift
//  SwiftGirls201804
//
//  Created by 鄭雅方 on 2018/4/13.
//  Copyright © 2018年 SwiftGirls. All rights reserved.
//

import UIKit
import MapKit

class MapView: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    // 拿到此地區的所以觀測站
    var eqStationGet: [EqStation] = []
    
    // 範例：台北火車站
    let location1 = CLLocation(latitude: 25.0477435, longitude: 121.5148509)
    // 範例：台北101/世貿站
    let location2 = CLLocation(latitude: 25.033053, longitude: 121.563192)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        centerMap(coordinate: location1.coordinate)
        
        // 標記預設大頭針
        let annotation = MKPointAnnotation()
        annotation.coordinate = location1.coordinate
        annotation.title = "台北火車站"
        annotation.subtitle = "集合地點"
        mapView.addAnnotation(annotation)
        
        // 標記自訂大頭針
        let myAnnotation = AnnotationBlue(title: "台北101/世貿站", subtitle: "捷運", coordinate: location2.coordinate)
        mapView.addAnnotation(myAnnotation)
        
        // 拿此地區觀測站所有資料
        //        for i in 0...eqStationGet.count-1{
        //        self.displayContent(with: eqStationGet[i])
        //        }
        
        // 迴圈的另一種寫法
        for eqStation in eqStationGet {
            self.displayContent(with: eqStation)
        }
        
        self.displayContentCenter(with: eqStationGet[0])
    }
    
    // 各測站詳細資料
    func displayContent(with station : EqStation) {
        let stationAnnotation = AnnotationRed(title: "\(station.stationName)", subtitle: "\(station.stationIntensity)級", coordinate: CLLocationCoordinate2D(latitude: Double(station.stationLat), longitude: Double(station.stationLon)))
        mapView.addAnnotation(stationAnnotation)
        print("個測站名稱是\(station.stationName)")
    }
    
    func displayContentCenter(with station : EqStation) {
        centerMap(coordinate: CLLocationCoordinate2D(latitude: Double(station.stationLat), longitude: Double(station.stationLon)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        guard let myAnnotation = annotation as? CustomAnnotation else {
        
            // 標記大頭針
            let id = "PinAnnotationView"
            let pin = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKPinAnnotationView ?? MKPinAnnotationView(annotation: annotation, reuseIdentifier: id)
            pin.annotation = annotation
            pin.canShowCallout = true
            pin.pinTintColor = MKPinAnnotationView.greenPinColor()
            return pin
        }
        
        // 標記自訂大頭針
        let myView = mapView.dequeueReusableAnnotationView(withIdentifier: myAnnotation.viewId) ?? MKAnnotationView(annotation: myAnnotation, reuseIdentifier: myAnnotation.viewId)

        myView.image = myAnnotation.img
        myView.canShowCallout = true
        myView.annotation = myAnnotation

        // 自定CalloutAccessoryView
        let detail = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        detail.text = myAnnotation.subtitle ?? ""
        detail.numberOfLines = 0
        detail.addConstraint(NSLayoutConstraint(item: detail, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150))
        detail.addConstraint(NSLayoutConstraint(item: detail, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200))
        detail.font = detail.font.withSize(10)
        myView.detailCalloutAccessoryView = detail
        myView.leftCalloutAccessoryView = UIImageView(image: myAnnotation.img)
        myView.rightCalloutAccessoryView = UIImageView(image: myAnnotation.img)

        return myView
    }

    
    // 以給定的經緯度為中心顯示該範圍內地圖
    func centerMap(coordinate: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)// 越小越精確, 也可用0.005
        let region = MKCoordinateRegion(center:coordinate, span:span)
        mapView.setRegion(region, animated: true)
    }

}

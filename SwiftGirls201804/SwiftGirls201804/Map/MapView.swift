//
//  MapView.swift
//  SwiftGirls201804
//
//  Created by 鄭雅方 on 2018/3/20.
//  Copyright © 2018年 SwiftGirls. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapView: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    // 拿到此地區的所以觀測站
    var eqStationGet: [EqStation] = []
    
    // 範例：台北火車站
    let location1 = CLLocation(latitude: 25.0477435, longitude: 121.5148509)
    // 範例：台北101/世貿站
    let location2 = CLLocation(latitude: 25.033053, longitude: 121.563192)
    // 範例：台北101大樓的四點
    let point1 = CLLocationCoordinate2D(latitude: 25.032914, longitude: 121.563411)
    let point2 = CLLocationCoordinate2D(latitude: 25.034965, longitude: 121.563550)
    let point3 = CLLocationCoordinate2D(latitude: 25.034955, longitude: 121.565395)
    let point4 = CLLocationCoordinate2D(latitude: 25.032943, longitude: 121.565352)
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
//        centerMap(coordinate: location1.coordinate)
        
        mapView.showsUserLocation = true
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // 標記預設大頭針
        let annotation = MKPointAnnotation()
        annotation.coordinate = location1.coordinate
        annotation.title = "台北火車站"
        annotation.subtitle = "集合地點"
        mapView.addAnnotation(annotation)
        
        // 標記自訂大頭針
        let myAnnotation = AnnotationBlue(title: "台北101/世貿站", subtitle: "捷運", coordinate: location2.coordinate)
        mapView.addAnnotation(myAnnotation)
        
        // 標記區塊
        let points = [point1, point2, point3, point4]
        let polygon = MKPolygon(coordinates: points, count: points.count)
        mapView.add(polygon)
        
        // 取得使用定位權限
        switch CLLocationManager.authorizationStatus() {
        case .denied, .restricted:
            print("App不允許使用定位服務")
        case .notDetermined:
            //永遠
            //            locationManager.requestAlwaysAuthorization()
            //使用App期間
            locationManager.requestWhenInUseAuthorization()
        default: break
        }

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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func exitButtonClick(sender: UIBarButtonItem){
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    // 定位
    @IBAction func getUserLocation(_ sender: Any) {
        guard CLLocationManager.locationServicesEnabled() else {
            print("裝置無定位服務")
            return
        }
        
        switch CLLocationManager.authorizationStatus() {
        case .denied, .restricted:
            print("App不允許使用定位服務")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default: break
        }
        
        locationManager.startUpdatingLocation()
    }
    
    // 開啟內建地圖App
    @IBAction func openMapApp(_ sender: Any) {
        //使用Map Link
        //        let link = "http://maps.apple.com/ll=\(location1.coordinate.latitude),\(location1.coordinate.longitude)&daddr=\(location1.coordinate.latitude),\(location1.coordinate.longitude)&dirflg=d"
        //        if let url = URL(string: link) {
        //            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        //        }
        
        //使用MKMapItem的openInMaps
        let placemark = MKPlacemark(coordinate: location1.coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "這就是我要的車站"
        mapItem.phoneNumber = "0987654321"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
    // MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        guard let myAnnotation = annotation as? CustomAnnotation else {
            let id = "PinAnnotationView"
            let pin = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKPinAnnotationView ?? MKPinAnnotationView(annotation: annotation, reuseIdentifier: id)
            pin.annotation = annotation
            pin.canShowCallout = true
            pin.pinTintColor = MKPinAnnotationView.greenPinColor()
            return pin
        }
        
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
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
       if overlay is MKPolygon { // 另外也可標記線條：MKPolyline
            let renderer = MKPolygonRenderer(overlay: overlay)
            renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 3
            return renderer
        }
        
        return MKOverlayRenderer()
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("緯度:\(location.coordinate.latitude) 經度: \(location.coordinate.longitude)")
            centerMap(coordinate: location.coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print(error)
    }
    
    // 以給定的經緯度為中心顯示該範圍內地圖
    func centerMap(coordinate: CLLocationCoordinate2D) {
//        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005) // 越小越精確
         let span = MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
//        let region = MKCoordinateRegionMake(coordinate, span)
        let region = MKCoordinateRegion(center:coordinate, span:span)
        mapView.setRegion(region, animated: true)
    }
    
}



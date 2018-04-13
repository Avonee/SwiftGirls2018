//
//  CustomAnnotation.swift
//  SwiftGirls201804
//
//  Created by 鄭雅方 on 2018/4/13.
//  Copyright © 2018年 SwiftGirls. All rights reserved.
//

import UIKit
import MapKit

@objc protocol CustomAnnotation: MKAnnotation {
    var viewId: String { get }
    var img: UIImage { get }
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D)
}

class AnnotationBlue: NSObject, CustomAnnotation {
    var viewId = "annotation_blue"
    var img = #imageLiteral(resourceName: "annotation_blue")
    var coordinate:CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    required init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        super.init()
    }
}

class AnnotationRed: NSObject, CustomAnnotation {
    var viewId = "annotation_red"
    var img = #imageLiteral(resourceName: "annotaion_red")
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    required init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
}

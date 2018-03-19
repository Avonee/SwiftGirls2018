//
//  Earthquake.swift
//  SwiftGirls201804
//
//  Created by Candy on 2018/3/19.
//  Copyright © 2018年 SwiftGirls. All rights reserved.
//

import UIKit

class Earthquake: NSObject {
    var earthquakeNo: String = ""
    var reportContent: String = ""
    var web: String = ""
    var reportImageURI: String = ""
    var shakemapImageURI: String = ""
    var earthquakeInfo: EarthquakeInfo? = nil
    var intensityArray: [ShakingArea]? = nil
    
}

class EarthquakeInfo: NSObject {
    var originTime: String = ""
    var epicenter: Epicenter? = nil
    var depth: Float = 0.0
    var magnitude: Magnitude? = nil
    var source: String = ""
}

class Epicenter: NSObject {
    var epicenterLon: Float = 0.0
    var epicenterLat: Float = 0.0
    var location: String = ""
}

class Magnitude: NSObject {
    var magnitudeType: String = ""
    var magnitudeValue: Float = 0.0
}

class ShakingArea: NSObject {
    var areaDesc: String = ""
    var areaName: String = ""
    var areaIntensity: Int = 0
    var stationsArray: [EqStation] = []
}

class EqStation: NSObject {
    var stationName: String = ""
    var stationLon: Float = 0.0
    var stationLat: Float = 0.0
    var distance: Float = 0.0
    var stationIntensity: Int = 0
}

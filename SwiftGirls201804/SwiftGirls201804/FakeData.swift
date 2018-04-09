//
//  FakeData.swift
//  SwiftGirls201804
//
//  Created by HsiaoShan on 2018/3/17.
//  Copyright © 2018年 SwiftGirls. All rights reserved.
//

import UIKit

class FakeData: NSObject {
    
    static func initFakeData(_ earthquake: Earthquake) -> Earthquake {
        earthquake.reportContent = "<Fake>03/06-17:42宜蘭縣近海發生規模4.8有感地震，最大震度宜蘭縣南澳3級。"
        earthquake.intensityArray = []
        for i in 1..<10 {
            let shakingArea = ShakingArea()
            shakingArea.areaName = "台北市\(i)"
            shakingArea.areaIntensity = i
            earthquake.intensityArray?.append(shakingArea)
        }
        return earthquake
    }
}

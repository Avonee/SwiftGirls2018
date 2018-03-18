//
//  EarthquakeHeaderView.swift
//  SwiftGirls201804
//
//  Created by HsiaoShan on 2018/3/17.
//  Copyright © 2018年 SwiftGirls. All rights reserved.
//

import UIKit

class EarthquakeHeaderView: UICollectionReusableView {
    @IBOutlet weak var reportContent: UILabel!
    
    func displayContent(with earthquake : [String: Any]) {
        if let reportContent = earthquake["reportContent"] as? String {
            self.reportContent.text = reportContent
        }
        if let reportColor = earthquake["reportColor"] as? String {
            switch reportColor {
            case "紅色":
                self.backgroundColor = UIColor.red
            case "橙色":
                self.backgroundColor = UIColor.orange
            case "黃色":
                self.backgroundColor = UIColor.yellow
            case "綠色":
                self.backgroundColor = UIColor.green
            default:
                self.backgroundColor = UIColor.white
            }
        }
    }
}

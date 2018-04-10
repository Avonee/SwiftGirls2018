//
//  ShakingAreaCell.swift
//  SwiftGirls201804
//
//  Created by HsiaoShan on 2018/3/17.
//  Copyright © 2018年 SwiftGirls. All rights reserved.
//

import UIKit

class ShakingAreaCell: UICollectionViewCell {
    //分區名稱
    @IBOutlet weak var areaName: UILabel!
    //分區震度
    @IBOutlet weak var text: UILabel!
    //分區震度單位
    @IBOutlet weak var unit: UILabel!

    override var isSelected: Bool {
        didSet {
            print("set isSelected")
            self.backgroundColor = self.isSelected ?  UIColor.yellow : UIColor.white
        }
    }
    
    func displayContent(with area : ShakingArea) {
        self.areaName.text = area.areaName
        self.text.text = "\(area.areaIntensity)"
        self.unit.text = "級"
    }
}

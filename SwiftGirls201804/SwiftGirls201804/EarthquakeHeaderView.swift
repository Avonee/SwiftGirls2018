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
    
    func displayContent(with earthquake : Earthquake) {
        self.reportContent.text = earthquake.reportContent
    }
}

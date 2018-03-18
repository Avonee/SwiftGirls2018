//
//  ViewController.swift
//  SwiftGirls201804
//
//  Created by HsiaoShan on 2018/3/8.
//  Copyright © 2018年 SwiftGirls. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //地震資料
    var earthquake: [String: Any] = [:]
    //分區震度
    var shakingArea: [[String: Any]] = [[:]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Use FakeData.
        earthquake = FakeData.fakeEarthquake
        if let intensity = earthquake["intensity"] as? [String: Any], let shakingAreas = intensity["shakingArea"] as? [[String: Any]] {
            shakingArea = shakingAreas
        }
        
        //Set CollectionView Datasource and Delegate
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /** UICollectionViewDataSource */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shakingArea.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shakingAreaCell", for: indexPath) as! ShakingAreaCell
        let area = shakingArea[indexPath.row]
        cell.displayContent(with: area)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "earthquakeHeaderView", for: indexPath) as! EarthquakeHeaderView
        headerView.displayContent(with: earthquake)
        return headerView
    }
    
    /** UICollectionViewDelegate */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected \(indexPath.row)")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("Deselected \(indexPath.row)")
    }
}


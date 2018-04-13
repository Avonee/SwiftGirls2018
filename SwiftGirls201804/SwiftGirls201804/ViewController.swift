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
    var earthquake: Earthquake = Earthquake()
    //分區震度
    var shakingArea: [ShakingArea] = []
    //分區震度內各測站
    var eqStation: [EqStation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Real Data
        DataApi.getData { (earthquake, error) in
            guard error == nil, let earthquake = earthquake else {
                return
            }
            // 取得資料了
            self.earthquake = earthquake
            if let shakingAreas = earthquake.intensityArray {
                self.shakingArea = shakingAreas
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
//        //Use FakeData.
//        earthquake = FakeData.initFakeData(earthquake)
//        if let shakingAreas = earthquake.intensityArray {
//            self.shakingArea = shakingAreas
//        }
        print("earthqauke:\(earthquake.reportContent)...")
        
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
        let area = shakingArea[indexPath.row]
        self.eqStation = area.stationsArray
        performSegue(withIdentifier: "toMapView", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("Deselected \(indexPath.row)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapView"{
            let vc = segue.destination as! MapView
            vc.eqStationGet = self.eqStation
            print("push to MapView")
        }
    }
}


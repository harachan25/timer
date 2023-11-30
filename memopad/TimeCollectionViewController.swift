//
//  TimeCollectionViewController.swift
//  memopad
//
//  Created by A .H on 2023/11/22.
//

import UIKit

class TimeCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var characterImageView: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    
    
    var totalTime: Int = 0
    var studySubjects: [String] = []
    var studyTimes: [String] = []
    var studyDates: [String] = []
    
    
    var timeSaveData: UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: collecting study data
        let temp1: [String] = []
        let temp2: [String] = []
        timeSaveData.register(defaults: ["subjects": temp1, "times": temp2])
//        timeSaveData.register(defaults: ["subjects": [], "times": [], "dates": []])
        
//        studyDates = timeSaveData.object(forKey: "dates") as! [String]
        
        //MARK: collectionView
        //datasource
        collectionView.dataSource = self
        collectionView.delegate = self
        //layout
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        studySubjects = timeSaveData.object(forKey: "subjects") as? [String] ?? []
        studyTimes = timeSaveData.object(forKey: "times") as? [String] ?? []
        print(studySubjects)
        collectionView.reloadData()
        
        //MARK: calculate totalTime
        sumStudyTime()
        totalLabel.text = "Total is " + String(totalTime)
        
        grow()
    }
    
    func sumStudyTime(){
        for i in 0..<studyTimes.count {
            totalTime += Int(studyTimes[i]) ?? 0
        }
        print("total studyTime is " + String(totalTime) + " seconds")
    }
    
    func grow(){
        if totalTime == 0{
            characterImageView.image = UIImage(named: "image1")
        }else if totalTime <= 5 {
            characterImageView.image = UIImage(named: "image2")
        }else if totalTime <=  10 {
            characterImageView.image = UIImage(named: "image3")
        }else{
            characterImageView.image = UIImage(named: "image4")
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return studyTimes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        var contentConfiguration = UIListContentConfiguration.cell()
        
        contentConfiguration.text = studySubjects[indexPath.item]
        contentConfiguration.secondaryText = studyTimes[indexPath.item]
        
        cell.contentConfiguration = contentConfiguration
        
        return cell
        
    }

}

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

//        //MARK: userdefaults' initial data
//        let temp1: [String] = []
//        let temp2: [String] = []
//        timeSaveData.register(defaults: ["subjects": temp1, "times": temp2])
        
        //MARK: collectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //MARK: userdefaults to arrey
        studySubjects = timeSaveData.object(forKey: "subjects") as? [String] ?? []
        studyTimes = timeSaveData.object(forKey: "times") as? [String] ?? []

        collectionView.reloadData()
        
        sumStudyTime()
        grow()
    }

    
    func sumStudyTime(){
        totalTime = 0
        for i in 0..<studyTimes.count {
            totalTime += Int(studyTimes[i])!
        }
        totalLabel.text = "Total is " + String(totalTime)
        print("sumStudyTime実行 " + "totalTime = " + String(totalTime))
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
        
        // セルにスワイプジェスチャーを追加する
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGesture.direction = .left
        cell.addGestureRecognizer(swipeGesture)
        
        return cell
    }
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        if let swipeCell = gesture.view as? UICollectionViewCell {
            if let indexPath = collectionView.indexPath(for: swipeCell) {
                
                // スワイプが完了したときの処理
                if gesture.state == .ended {
                    // セルを削除する処理
                    studySubjects.remove(at: indexPath.item)
                    studyTimes.remove(at: indexPath.item)
                    
                    timeSaveData.set(studySubjects, forKey: "subjects")
                    timeSaveData.set(studyTimes, forKey: "times")
                    studyTimes = timeSaveData.object(forKey: "times") as? [String] ?? []
                    
                    collectionView.deleteItems(at: [indexPath])
                    
                    sumStudyTime()
                    grow()
                    print("スワイプ実行")
                }
            }
        }
    }
}

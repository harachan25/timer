//
//  ViewController.swift
//  memopad
//
//  Created by A .H on 2023/11/01.
//

import UIKit
import Foundation

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    //MARK: date
    var date = Date()
    let dateFormatter = DateFormatter()
    let now: String = ""
    
    //MARK: Timer
    var timer: Timer!
    var countdown: Int = 0
    var startTime: Int = 0
    var pauseTime: Int!
    
    var studyTime: Int = 0
    var studySubject: String = "-"
    var studyDate: String = ""
    
    //MARK: userdefaults
    var timeSaveData: UserDefaults = UserDefaults.standard
    var studySubjects: [String] = []
    var studyTimes: [String] = []
    var studyDates:[String] = []
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    
    @IBOutlet var pickerView: UIPickerView!
    let dataList = [
        "-", "Japanese", "English", "Math"
    ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.text = "Select time"
        
        //MARK: button
        stopButton.layer.cornerRadius = 10
        stopButton.imageView?.layer.cornerRadius = 10
//        stopButton.setImage(UIImage(named: "pockemon"), for: .normal)
//        stopButton.imageView?.contentMode = .scaleAspectFill

        //MARK: pickerView
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        createDateFormat()
        
        dateLabel.text = String(dateFormatter.string(from: date))
//        studyDate = String(date)
        print(date)
        
        //MARK: timer
        delete()
        
        //MARK: pickerView
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    @objc func onTimerCalled(){
        updateLabel()
        countdown -= 1

        if countdown < 0 {
            showStopAlert()
            timer.invalidate()
        }
    }
    
    func updateLabel(){
        let remainingMinutes: Int = countdown / 60
        let remainingSeconds: Int = countdown % 60
        
        timeLabel.text = String(format: "%02d:%02d", remainingMinutes, remainingSeconds)
    }
    
    func showStopAlert() {
        let stopAlert = UIAlertController(title: "タイマーが終了しました", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        stopAlert.addAction(okAction)
        present(stopAlert, animated: true)
    }
    
    func createDateFormat(){
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
    }
    
    
    func startTimer(time: Int){
        countdown = time//残り時間をtime秒に
        
        if timer != nil{
            timer.invalidate()
        }
        
        timer=Timer.scheduledTimer(timeInterval:1.0, target : self,selector : #selector(onTimerCalled),userInfo : nil,repeats : true)
        timer.fire()//start timer
    }
    
    
    @IBAction func select30seconds(){
        startTimer(time: 30)
        timeLabel.text = "00:30"
        startTime = 30
        print("timer setted 30 sec")
    }
    @IBAction func select1mseconds(){
        startTimer(time: 60)
        timeLabel.text = "01:00"
        startTime = 60
        print("timer setted 60 sec")
    }
    @IBAction func select5mseconds(){
        startTimer(time: 300)
        timeLabel.text = "05:00"
        startTime = 300
        print("timer setted 300 sec")
    }
    @IBAction func select10mseconds(){
        startTimer(time: 600)
        timeLabel.text = "10:00"
        startTime = 600
        print("timer setted 600 sec")
    }
    
    @IBAction func start(time: Int){
        startTimer (time: countdown)
        print("timer started from " + String(pauseTime))
    }
    
    @IBAction func stop(){
        pauseTime = countdown
        timer.invalidate()//stop timer
        print("timer stopped at " + String(pauseTime))
    }
    
    @IBAction func delete(){
        startTime = 0
        pauseTime = 0
        countdown = 0
        timeLabel.text = ""
        if timer != nil{
            timer.invalidate()
            print("the timer was deleted")
        }
        timeLabel.text = "Select time"
    }
    
    @IBAction func selectSave(_ sender:Any){
        pauseTime = countdown
        studyTime = startTime - pauseTime
        
        if studyTime == 0{
            //MARK: alert
            let alert: UIAlertController = UIAlertController(title: "let's study", message: "", preferredStyle: .alert)
            let defaultAction: UIAlertAction = UIAlertAction(title:"OK",
                                                             style: .default,
                                                             handler: {
                                                                action in print("the ok button was tapped")
                
            })
            let animalAction: UIAlertAction = UIAlertAction(title:"animals",
                                                             style: .default,
                                                             handler: {
                                                                action in print("the animal button was tapped")
                                                                self.performSegue(withIdentifier: "toCollection", sender: nil)
            })
            //UIAlertControllerにActionを追加
            alert.addAction(defaultAction)
            alert.addAction(animalAction)
            present(alert, animated: true, completion: nil)
            
        }else{
            
            //MARK: calculate studyTime
            timer.invalidate()
            print("saved the study time")
            
            //MARK: save
            //1.put input memo into var
            //2.add input memo to old memos
            studySubjects.append(studySubject)
            studyTimes.append(String(studyTime))
            studyDates.append(now)
            
            print(studySubjects)
            print(studyTimes)
            print(now)
            
            //3.reload userdefaults
            timeSaveData.set(studySubjects, forKey: "subjects")
            timeSaveData.set(studyTimes, forKey: "times")
            timeSaveData.set(now, forKey: "dates")
            
            print("you studied "+"in "+String(studyTime)+" seconds")
            
            //        //MARK: Alert
            //        let alert: UIAlertController = UIAlertController(title: "save", message: "The save is done", preferredStyle: .alert)
            //        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in print("the ok button was tapped")
            //            self.performSegue(withIdentifier: "toCollection", sender: nil)
            //
            //        }))
            //        present(alert, animated: true, completion: nil)
            self.performSegue(withIdentifier: "toCollection", sender: nil)
        }
    }
    
    
    //MARK: UIPickerView
    //number of rows
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //the number of list
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }
    
    //first display
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent: Int) -> String? {
        return dataList[row]
    }
    
    //acts when select Row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        studySubject = dataList[row]
        print(studySubject + " selected")
    }
}

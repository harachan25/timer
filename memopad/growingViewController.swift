//
//  growingViewController.swift
//  memopad
//
//  Created by A .H on 2023/11/29.
//

import UIKit

class growingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var growNumber: Int = 0
    
    @IBOutlet var dinasourImageView: UIImageView!
    @IBOutlet var numberPickerView: UIPickerView!
    let dataList = ["0", "10", "50", "100"]

    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: pickerView
        numberPickerView.delegate = self
        numberPickerView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        growDinasour()
        
        //MARK: pickerView
        numberPickerView.delegate = self
        numberPickerView.dataSource = self
    }
    
    func growDinasour(){
        if growNumber == 0{
            dinasourImageView.image = UIImage(named: "image1")
        }else if growNumber <= 10 {
            dinasourImageView.image = UIImage(named: "image2")
        }else if growNumber <= 50 {
            dinasourImageView.image = UIImage(named: "image3")
        }else{
            dinasourImageView.image = UIImage(named: "image4")
        }
        print(growNumber)
    }
    
    //MARK: UIPickerView
    //number of rows
    func numberOfComponents(in numberPickerView: UIPickerView) -> Int {
        return 1
    }
    
    //行数，number of list
    func pickerView(_ numberPickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }
    
    //first display
    func pickerView(_ numberPickerView: UIPickerView, titleForRow row: Int, forComponent: Int) -> String? {
        return dataList[row]
    }
    
    //acts when select Row
    func pickerView(_ numberPickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        growNumber = Int(dataList[row]) ?? 0
        growDinasour()
//        print(String(growNumber) + "selected")
    }
}

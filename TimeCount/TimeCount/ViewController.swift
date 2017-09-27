//
//  ViewController.swift
//  TimeCount
//
//  Created by Ram Yadav on 7/23/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var second: UILabel!
    @IBOutlet weak var milliSecond: UILabel!
    @IBOutlet weak var minute: UILabel!
    var clickOnce:Bool = true
    //timer
    var timer = Timer()
    //time variable
    //initiall all times are ZERO
    var timeMillisecond = 0
    var timeSecond = 0
    var timeMinute = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func start(_ sender: UIButton) {
        if clickOnce == true {
             timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(ViewController.action), userInfo: nil, repeats: true)
            clickOnce = false
        }
       
    }
    
    @IBAction func puase(_ sender: UIButton) {
        timer.invalidate()
        clickOnce = true
    }

    @IBAction func reset(_ sender: Any) {
        //reseting all tiem value
        timeMillisecond = 0
        timeSecond = 0
        timeMinute = 0
        //resetting all screen oupput
        second.text = "0"
        milliSecond.text = "0"
        minute.text = "0"
        timer.invalidate()
        clickOnce = true
        
    }
    
    func action() {
        //each time timer calls in 0.02, timiMillisecond increase
        timeMillisecond += 1
        //output millisecond, second, and minute
        milliSecond.text = String(timeMillisecond)
        second.text = String(timeSecond)
        minute.text = String(timeMinute)
        if milliSecond.text == "60" { //when millisecond is 60, repeat again
           timeMillisecond = 0
           timeSecond += 1 //each 60 millisecnd is 1 second
            if timeSecond == 60 {timeSecond = 0; timeMinute += 1} //when second is 60, start from Zero, and 60 sec = 1 minute
            if timeMinute == 60 {timeMinute = 0} //when minute is 60, start from 0
        }
        
        
    }
}


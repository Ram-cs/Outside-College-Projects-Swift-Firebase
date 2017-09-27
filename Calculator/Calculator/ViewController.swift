//
//  ViewController.swift
//  Calculator
//
//  Created by Ram Yadav on 7/22/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var array = [Int]()
    var index:Int = 0;
    var result:Int = 0
    var currentValue: Int = 0
    @IBOutlet weak var label: UILabel! //label variable
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        label.text = "0" //initialize with Zero at the first
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        print("Button")
        if label.text! == "0" || array.count > 0{
            label.text = String(sender.tag - 1)
        } else {
            label.text = label.text! + String(sender.tag - 1)
        }
        
        //CLEAR THE SCREEN
        if sender.tag == 11 {
            label.text = "0"
            array.removeAll() //erasing the array
            index = 0
        }
        
        
    }
    
    
    @IBAction func operatorPressed(_ sender: UIButton) {
        //ADDITION
        if sender.tag == 15 {
            print("Operator")
            array.insert(Int(label.text!)!, at: index)
            
            if array.count >= 2 {
                result = array[index] + array[index - 1]
                label.text = String(result)
                array.insert(Int(label.text!)!, at: 0)
                index -= 1
            }
        
            index += 1
        }
    }
    
    
}


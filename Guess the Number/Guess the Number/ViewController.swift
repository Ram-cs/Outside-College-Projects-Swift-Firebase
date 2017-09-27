//
//  ViewController.swift
//  Guess the Number
//
//  Created by Ram Yadav on 7/21/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var numberTyped: UITextField!
    @IBOutlet weak var outputScreen: UILabel!
   
    private var setRandomNumber = 0
    private var guessCount = 0
    private var numberGuessed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setRandomNumber = Int(arc4random_uniform(100)) //setting the random number
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //declaring the funcitons
    func buttonPressed(number:Int!) {
        if numberGuessed == true {
            guessCount = 0
            setRandomNumber = Int(arc4random_uniform(100))
        }
        
        if number! < setRandomNumber {
            self.outputScreen.text = "Your number is less than actual number"
            guessCount += 1
        } else if number! > setRandomNumber {
            self.outputScreen.text = "Your number is greater than actual number"
            guessCount += 1
        } else {
            self.outputScreen.text = "HURRY! you matched the numner!\nIn round: \(guessCount)"
            numberGuessed = true
        }
        
        self.numberTyped.text = ""
    }
    
    @IBAction func guessButton(_ sender: Any) {
        if let input:Int = Int(self.numberTyped.text!) {
            buttonPressed(number: input)
        } else {
            self.outputScreen.text = "Please type a NUMBER"
            self.numberTyped.text = ""
        }
    }
}


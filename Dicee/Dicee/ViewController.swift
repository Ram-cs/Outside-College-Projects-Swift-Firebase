//
//  ViewController.swift
//  Dicee
//
//  Created by Ram Yadav on 7/20/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var randomNumber1: Int = 0;
    var randomNumber2: Int = 0;

    @IBOutlet weak var diceImage1: UIImageView!
    @IBOutlet weak var diceImage2: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    func changeDice() { //creating funcitons for diceImage functionalilty
        var diceList:[String] = ["dice1", "dice2", "dice3", "dice4", "dice5", "dice6"]
        randomNumber1 = Int(arc4random_uniform(6))
        randomNumber2 = Int(arc4random_uniform(6))
        
        print("random number one: \(randomNumber1)")
        print("random number two: \(randomNumber2)\n")
        
        diceImage1.image = UIImage(named: diceList[randomNumber1])
        diceImage2.image = UIImage(named: diceList[randomNumber2])

    }
    
    
    @IBAction func diceButton(_ sender: Any) {
        changeDice()
    }

}


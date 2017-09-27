//
//  ViewController.swift
//  Testing Projects
//
//  Created by Ram Yadav on 7/24/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Submit(_ sender: Any) {
        let data = Data()
        data.firstName = firstName.text!;
        data.lastName = lastName.text!;
        
        label.text = data.getWholeName()
    }

}


//
//  ViewController.swift
//  ForTesting
//
//  Created by Ram Yadav on 7/27/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var zipCodeText: UITextField!
    @IBOutlet weak var amountText: UITextField!
    @IBOutlet weak var textField: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        zipCodeText.delegate = self
        amountText.delegate = self
    }
    
    @IBAction func switchButton(_ sender: UISwitch) {
        if sender.isOn {
            textField.isUserInteractionEnabled = true
        } else {
            textField.isUserInteractionEnabled = false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = zipCodeText.text else {
            return true
        }
        //write only  and 5 characters
        let newLength = text.characters.count + string.characters.count - range.length
        //give only digits
        let allowcharacterSet = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowcharacterSet.isSuperset(of: characterSet) && newLength <= 5
        }
}




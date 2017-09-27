//
//  SignInVC.swift
//  Rider For Uber App
//
//  Created by Ram Yadav on 7/27/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit
import Firebase

class SignInVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    let RIDER_SEGUE = "riderSegue"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logIn(_ sender: Any) {
        if email.text != "" && password.text != "" {
            //login
            AuthProvider.Instances.signIn(email: email.text!, password: password.text!, errorHandler: { (message) in
                if message != nil {
                    self.errorAlert(titile: "Login Error!", message: message!)
                } else {
                    UberHandler.Instances.rider = self.email.text! //store the rider email
                    //clear after logout
                    self.email.text = ""
                    self.password.text = ""
                    //go to the next segue
                    self.performSegue(withIdentifier: self.RIDER_SEGUE, sender: self)
                }
            })
        } else {
          errorAlert(titile: "Login Error!", message: "Please provide Email and Password")
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        if email.text != "" && password.text != "" {
            //SIGN UP
            AuthProvider.Instances.registerUser(email: email.text!, password: password.text!, errorHandler: { (message) in
                if message != nil {
                    self.errorAlert(titile: "Sign UP Error!", message: message!)
                } else {
                    UberHandler.Instances.rider = self.email.text!
                    self.email.text = ""
                    self.password.text = ""//store the rider email
                    self.performSegue(withIdentifier: self.RIDER_SEGUE, sender: self)
                }

            })
        } else {
          errorAlert(titile: "Sign UP Error!", message: "Please provide Email and Password")
        }
    }
    
    func errorAlert(titile: String, message: String) {
        let alert = UIAlertController(title: titile, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}

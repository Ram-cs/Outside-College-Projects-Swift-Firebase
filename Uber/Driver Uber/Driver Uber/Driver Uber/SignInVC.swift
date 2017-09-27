//
//  SignInVC.swift
//  Uber App For Rider
//
//  Created by Ram Yadav on 7/24/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInVC: UIViewController {
    
    private let DRIVER_SEGUE = "DriverVC"
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func login(_ sender: Any) {
        if email.text != "" && password.text != "" {
            AuthProvider.Instance.login(emailWith: email.text!, password: password.text!, loginErrorHandler: { (message) in
                if message != nil {
                    self.loginAlert(title: "Login Error!", message: message!)
                } else {
                    self.performSegue(withIdentifier: self.DRIVER_SEGUE, sender: nil)
                }
            })
        } else {
                self.loginAlert(title: "Login Error!", message: "Please enter Email and Password!")
            
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        if email.text != "" && password.text != "" {
            AuthProvider.Instance.signUp(emailWith: email.text!, password: password.text!, loginErrorHandler: { (message) in
                if message != nil {
                    self.loginAlert(title: "Sign Up Error!", message: message!)
                } else {
                    self.performSegue(withIdentifier: self.DRIVER_SEGUE, sender: nil)
                }
            })
        } else {
            self.loginAlert(title: "Sign Up Error!", message: "Please enter Email and Password!")
        }
    }
    
    private func loginAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil)
    }
}

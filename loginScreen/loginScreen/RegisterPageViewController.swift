//
//  RegisterPageViewController.swift
//  loginScreen
//
//  Created by Ram Yadav on 6/21/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit

class RegisterPageViewController: UIViewController {

    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userReTypePasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        let userEmail:String? = userEmailTextField.text
        let userPassword:String? = userPasswordTextField.text
        let userRepeatPassword:String? = userReTypePasswordTextField.text
        
        //check for empty field
        if (userEmail)!.isEmpty || (userPassword)!.isEmpty || (userRepeatPassword)!.isEmpty {
            
            //display the error message
            displayMessageAlert(userMessage: "Please fillout all the required filed!")
            return;
            
        }
        
        //check for match password
        
        if userPassword! != userRepeatPassword! {
            //display the error if password doesn't match
            displayMessageAlert(userMessage: "Password didn't match!")
            return;
        }
        
        //store the data 
        //temporarly storing data, but should store on server side
        

    }
    
    func displayMessageAlert(userMessage:String) {
        let myAlert = UIAlertController(title: "Alert!", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style:UIAlertActionStyle.default, handler:nil)
        
        myAlert.addAction(okAction)
        
        self.present(myAlert, animated:true, completion:nil)
        
    }
        

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ViewController.swift
//  ToDoList
//
//  Created by Ram Yadav on 8/16/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func cancel(_ sender: Any) {
        let tableViewCell = self.storyboard?.instantiateViewController(withIdentifier: "navigationController") as! UINavigationController
        self.present(tableViewCell, animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: true) //popping off from the navigation controller
    }

    @IBAction func add(_ sender: Any) {
        if textField.text! != "" {
            TableViewCell.list.append(textField.text!)
            let tableViewCell = self.storyboard?.instantiateViewController(withIdentifier: "navigationController") as! UINavigationController
            self.present(tableViewCell, animated: true, completion: nil)
//           self.navigationController?.popViewController(animated: true) //popping and go back to the tableViewCell
            return
        }
        
    }
}


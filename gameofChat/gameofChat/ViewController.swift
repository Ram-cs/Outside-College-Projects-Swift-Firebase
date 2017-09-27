//
//  ViewController.swift
//  gameofChat
//
//  Created by Ram Yadav on 7/27/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit

class ViewController: UITableViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
    }

    func logout() {
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
        
    }
    
}


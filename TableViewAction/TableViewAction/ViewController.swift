//
//  ViewController.swift
//  TableViewAction
//
//  Created by Ram Yadav on 8/16/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detailLevel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tableView = TableViewController()
        self.titleLabel.text = tableView.array[getIndex]
        self.detailLevel.text = tableView.detailArray[getIndex]
        self.imageView.image = UIImage(named: tableView.image[getIndex])
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}


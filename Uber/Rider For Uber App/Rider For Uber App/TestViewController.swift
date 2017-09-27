//
//  TestViewController.swift
//  Rider For Uber App
//
//  Created by Ram Yadav on 8/9/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        locationBarBotton()
    }
    func locationBarBotton() {
        let button: UIButton = UIButton(type: UIButtonType.custom)
        button.setImage(UIImage(named: "currentLocation"), for: UIControlState.normal)
        button.addTarget(self, action: #selector(currentLocation), for: UIControlEvents.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        let barbutton = UIBarButtonItem.init(customView: button)
        self.navigationItem.leftBarButtonItem = barbutton
    }
    
    func currentLocation() {
        
    }

}

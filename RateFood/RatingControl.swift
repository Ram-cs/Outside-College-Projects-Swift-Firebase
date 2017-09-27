//
//  RatingControl.swift
//  RateFood
//
//  Created by Ram Yadav on 8/3/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit

class RatingControl: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpBottons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setUpBottons()
    }
    
    private func setUpBottons() {
        // Create the button
        let button = UIButton()
        button.backgroundColor = UIColor.red
        
        // Add constraints
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        button.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        
        // Add the button to the stack
        addArrangedSubview(button)
    }

}

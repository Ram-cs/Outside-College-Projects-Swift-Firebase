//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Ram Yadav on 8/3/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    private var ratingButton = [UIButton]()
    var rating = 0 {
        didSet {
           updateButtonSelectionStates()
        }
    }
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    
    private func setupButtons() {
        //clear any existing buttons
        for buttons in ratingButton {
            removeArrangedSubview(buttons)
            buttons.removeFromSuperview()
        }
        
        //load images
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        ratingButton.removeAll()
        
        // Create the button
        for index in 0..<starCount {
            let button = UIButton()
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            button.accessibilityLabel = "Set \(index + 1) rating"
            
            button.addTarget(self, action: #selector(ratingButtonTapped(button:)), for: .touchUpInside)
            // Add the button to the stack
            addArrangedSubview(button)
            ratingButton.append(button)
        }
       updateButtonSelectionStates() 
    }
    
    func ratingButtonTapped(button: UIButton) {
        guard let index = ratingButton.index(of: button) else {
            fatalError("the button\(button) is not in the array \(ratingButton)")
        }
        
        let selectedRating = index + 1
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
    }
    
   private func updateButtonSelectionStates() {
        for (index, button) in ratingButton.enumerated() {
            button.isSelected = index < rating
            
            let hintString: String?
            if rating == index + 1  {
                hintString = "Tap to reset the rating to Zero"
            } else {
                hintString = nil
            }
            
            let valueString: String?
            switch rating {
            case 0:
                valueString = "No starts set"
            case 1:
                valueString = "0 starts set"
            default:
                valueString = "\(rating) starts sets"
            }
            
            button.accessibilityHint = hintString
            button.accessibilityValue  = valueString
            
        }
    
    }
}



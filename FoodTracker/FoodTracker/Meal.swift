//
//  Meal.swift
//  FoodTracker
//
//  Created by Ram Yadav on 8/4/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit

class Meal {
    var name: String
    var image: UIImage?
    var rating: Int
    
    init?(name: String, image: UIImage?, rating: Int) {
        guard !name.isEmpty else {
            return nil
        }
        
        guard rating >= 0 && rating <= 5 else {
            return nil
        }
        self.name = name
        self.image = image
        self.rating = rating
    }
}

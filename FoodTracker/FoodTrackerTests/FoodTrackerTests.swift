//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by Ram Yadav on 8/3/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import XCTest
@testable import FoodTracker

class FoodTrackerTests: XCTestCase {
   //MARK: Meal Class test
    
    
    func testMealInitializationSucceeds() {
        //zero Rating meal
        let zeroRatingMeal = Meal.init(name: "Zero", image: nil, rating: 0)
        XCTAssertNotNil(zeroRatingMeal)
        
        //positive Rating Meal
        let positiveRatingMeal = Meal.init(name: "Positive", image: nil, rating: 5)
        XCTAssertNotNil(positiveRatingMeal)
        
    }
    
    func testMealInitializationFail() {
        let negativeRatingMeal = Meal.init(name: "name", image: nil, rating: -1)
        XCTAssertNil(negativeRatingMeal)
        
        let largeRatingMeal = Meal.init(name: "Large", image: nil, rating: 6)
        XCTAssertNil(largeRatingMeal)
        
        let emptyStringMeal = Meal.init(name: "", image: nil, rating: 0)
        XCTAssertNil(emptyStringMeal)
    }
    
    
}

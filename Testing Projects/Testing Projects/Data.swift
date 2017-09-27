//
//  Data.swift
//  Testing Projects
//
//  Created by Ram Yadav on 7/24/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit

class Data {
    private var _firstName = ""
    private var _lastName = ""
    
    var firstName: String {
        get {
            return self._firstName;
        }
        set {
            self._firstName = newValue;
        }
    }
    
    var lastName: String {
        get {
            return self._lastName;
        }
        set {
            self._lastName = newValue;
        }
    }
    
    
    func getWholeName() -> String {
        return "\(firstName) \(lastName)"
    }
}

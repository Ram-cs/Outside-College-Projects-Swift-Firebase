//
//  AuthProvider.swift
//  Rider For Uber App
//
//  Created by Ram Yadav on 8/8/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit
import FirebaseAuth

class AuthProvider: UIViewController {
    static var _instances = AuthProvider()
    static var Instances: AuthProvider {
        return _instances;
    }
    typealias ErrorHandler = (_ msg: String?) -> Void
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func signIn(email: String, password: String, errorHandler: ErrorHandler?) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                self.error(errors: error! as NSError , errorHandler: errorHandler)
            } else {
                errorHandler?(nil)
            }
        }
    }
    
    func registerUser(email: String, password: String, errorHandler: ErrorHandler?) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                //something is wrong with email and password
                self.error(errors: error! as NSError, errorHandler: errorHandler)
            } else {
                //create user
                errorHandler?(nil)
                DBprovider.instances.storeData(userID: (user?.uid)!, email: email, password: password)
            }
        }
    }
    
    func signOut() -> Bool {
        let firebaseAuth = Auth.auth()
        if firebaseAuth.currentUser != nil {
            do {
                try firebaseAuth.signOut()
                
                return true
            } catch let signOutError as NSError{
                print("Error Signing Out @:", signOutError)
                return false
            }
        }
        return true
    }
    
    func error(errors: NSError, errorHandler: ErrorHandler?) {
        if let errorCode = AuthErrorCode(rawValue: errors.code) {
            switch errorCode {
            case .networkError:
                errorHandler?(Constants.NETWORKING_ERROR)
                break;
            case .emailAlreadyInUse:
                errorHandler?(Constants.EMAIL_ALREADY_IN_USE)
                break;
            case .invalidEmail:
                errorHandler?(Constants.INVALID_EMAIL)
                break;
            case .weakPassword:
                errorHandler?(Constants.WEAK_PASSWORD)
                break;
            case .wrongPassword:
                errorHandler?(Constants.WRONG_PASSWORD)
                break;
            case .userNotFound:
                errorHandler?(Constants.USER_NOT_FOUND)
            default:
                errorHandler?("Something went wrong, Try agian later Please")
                break;
            }
        }
    }

}

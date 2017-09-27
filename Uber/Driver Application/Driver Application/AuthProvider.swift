//
//  AuthProvider.swift
//  Driver Application
//
//  Created by Ram Yadav on 8/9/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthProvider {
    
    typealias LoginErrorHandler = (_ msg: String?) -> Void
    
    struct LoginErrorCode {
        static let NETWORK_ERROR = "Network error occured"
        static let INVALID_EMAIL = "Invalid Email"
        static let WEAK_PASSWORD = "Weak Password, Password must be at leat 6 character long"
        static let WRONG_PASSWORD = "Wrong Password"
        static let EMAIL_ALREADY_USE = "Email has already been used"
        static let USET_NOT_FOUND = "User not found"
        static let CREDENTIAL_IN_USE = "User has already been signed up with this email"
    }
    
    private static let _instance = AuthProvider()
    static var Instance: AuthProvider {
        return _instance
    } //CREATING OBJECT OF THE CLASS
    
    func login(emailWith: String, password: String, loginErrorHandler: LoginErrorHandler? ) {
        Auth.auth().signIn(withEmail: emailWith, password: password) { (user, error) in
            if (error != nil) {
                self.errorHandler(err: error! as NSError, loginErrorHandler: loginErrorHandler)
            } else {
                loginErrorHandler?(nil)
            }
        }
    }//LOGIN FUNCTION
    
    func signUp(emailWith: String, password: String, loginErrorHandler: LoginErrorHandler?) {
        Auth.auth().createUser(withEmail: emailWith, password: password) { (user, error) in
            if error != nil {
                self.errorHandler(err: error! as NSError, loginErrorHandler: loginErrorHandler)
            } else {
                if user?.uid != nil { 
                    //Store the user in our database
                    DBprovider.Instance.saveData(email: emailWith, password: password, withID: user!.uid)
                    //Then login the user
                    self.login(emailWith: emailWith, password: password, loginErrorHandler: loginErrorHandler)
                }
            }
        }
    } //SIGNUP FUNCTION
    
    
    func logOut()-> Bool {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                return true
            } catch {
                return false
            }
            
        }
        return true;
    }
    
    private func errorHandler(err: NSError, loginErrorHandler: LoginErrorHandler?) {
        if let errorCode = AuthErrorCode(rawValue: err.code) {
            switch errorCode {
            case .networkError:
                loginErrorHandler?(LoginErrorCode.NETWORK_ERROR);
                break;
            case .invalidEmail:
                loginErrorHandler?(LoginErrorCode.INVALID_EMAIL);
                break;
            case .weakPassword:
                loginErrorHandler?(LoginErrorCode.WEAK_PASSWORD);
                break;
            case .wrongPassword:
                loginErrorHandler?(LoginErrorCode.WRONG_PASSWORD);
                break;
            case .emailAlreadyInUse:
                loginErrorHandler?(LoginErrorCode.EMAIL_ALREADY_USE);
                break;
            case .userNotFound:
                loginErrorHandler?(LoginErrorCode.USET_NOT_FOUND);
                break;
            case .credentialAlreadyInUse:
                loginErrorHandler?(LoginErrorCode.CREDENTIAL_IN_USE);
                break;
            default:
                break;
            }
        }
    }//ERROR HANDLER
} //class


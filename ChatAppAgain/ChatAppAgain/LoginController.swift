//
//  LoginController.swift
//  ChatAppAgain
//
//  Created by Ram Yadav on 8/24/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class LoginController: UIViewController {
    var messageController: MessageController? //declaring the class type
    
    var loginContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    var nameTextField: UITextField = {
        let name = UITextField()
        name.placeholder = "Name"
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    
    var seperator: UIView = {
        let seperate = UIView()
        seperate.backgroundColor = UIColor.lightGray
        seperate.translatesAutoresizingMaskIntoConstraints = false
        return seperate
    }()
    
    var emailTextField: UITextField = {
        let email = UITextField()
        email.placeholder = "Email"
        email.translatesAutoresizingMaskIntoConstraints = false
        return email
    }()
    
    
    var emailSeperator: UIView = {
        let seperate = UIView()
        seperate.backgroundColor = UIColor.lightGray
        seperate.translatesAutoresizingMaskIntoConstraints = false
        return seperate
    }()
    
    var passwordTextField: UITextField = {
        let password = UITextField()
        password.placeholder = "Password"
        password.isSecureTextEntry = true
        password.translatesAutoresizingMaskIntoConstraints = false
        return password
    }()
    
   lazy var setProfileImage: UIImageView = { //must put lazy var to enable userInteraction, otherwise doesn't work
        let profileImage = UIImageView()
        profileImage.image = UIImage(named: "profile_Image")
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.contentMode = .scaleAspectFill
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        profileImage.isUserInteractionEnabled = true
        return profileImage
    }()
    
   var setUploginRegisterButton: UIButton = {
        let loginRegisterButton = UIButton(type: .system)
        loginRegisterButton.setTitle("Register", for: .normal)
        loginRegisterButton.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        loginRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        loginRegisterButton.setTitleColor(UIColor.white, for: .normal)
        loginRegisterButton.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return loginRegisterButton
    }()
    
    func handleLoginRegister() {
        if setUpSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is invalid")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error!)
                return
            } else {
                self.messageController?.fetchUserAndSetInNavTitle()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    var setUpSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Login", "Register"])
        segmentedControl.tintColor = UIColor.white
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(handleLoginRegisterChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    func handleLoginRegisterChanged() {
        let title = setUpSegmentedControl.titleForSegment(at: setUpSegmentedControl.selectedSegmentIndex)
        setUploginRegisterButton.setTitle(title, for: .normal)
        
        //change the height of inputContainers **********************
        loginContainerViewHeight?.constant = setUpSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        nameTextFieldHeight?.isActive = false
        nameTextFieldHeight = nameTextField.heightAnchor.constraint(equalTo: loginContainerView.heightAnchor, multiplier: setUpSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeight?.isActive = true
        nameTextField.isHidden = setUpSegmentedControl.selectedSegmentIndex == 0
        
        //email
        emailTextFieldHeight?.isActive = false
        emailTextFieldHeight = emailTextField.heightAnchor.constraint(equalTo: loginContainerView.heightAnchor, multiplier:setUpSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeight?.isActive = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        //add view to the main view
        view.addSubview(loginContainerView)
        view.addSubview(setProfileImage)
        view.addSubview(setUploginRegisterButton)
        view.addSubview(setUpSegmentedControl)
        
        //set the x, y, width, and height of the loginContainerView
        setUpinputConstrainesView()
        setProfileImageConstrains()
        setUploginRegisterButtonConstrains()
        setUpSegmentedControlConstrains()
    }
    
    var loginContainerViewHeight: NSLayoutConstraint?
    var nameTextFieldHeight: NSLayoutConstraint?
    var emailTextFieldHeight: NSLayoutConstraint?
    
    func setUpinputConstrainesView() {
        loginContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loginContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16).isActive = true
        loginContainerViewHeight = loginContainerView.heightAnchor.constraint(equalToConstant: 150)
        loginContainerViewHeight?.isActive = true

        //add textField into login ContainerView
        loginContainerView.addSubview(nameTextField)
        loginContainerView.addSubview(seperator)
        loginContainerView.addSubview(emailTextField)
        loginContainerView.addSubview(emailSeperator)
        loginContainerView.addSubview(passwordTextField)
        
         setUpTextFiled()
  }
    
    func setUpTextFiled() {
        nameTextField.topAnchor.constraint(equalTo: loginContainerView.topAnchor).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: loginContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: loginContainerView.widthAnchor).isActive = true
        nameTextFieldHeight = nameTextField.heightAnchor.constraint(equalTo: loginContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeight?.isActive = true

        seperator.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        seperator.leftAnchor.constraint(equalTo: loginContainerView.leftAnchor).isActive = true
        seperator.widthAnchor.constraint(equalTo: loginContainerView.widthAnchor).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        emailTextField.topAnchor.constraint(equalTo: seperator.bottomAnchor).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: loginContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: loginContainerView.widthAnchor).isActive = true
        emailTextFieldHeight = emailTextField.heightAnchor.constraint(equalTo: loginContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeight?.isActive = true
        
        emailSeperator.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeperator.leftAnchor.constraint(equalTo: loginContainerView.leftAnchor).isActive = true
        emailSeperator.widthAnchor.constraint(equalTo: loginContainerView.widthAnchor).isActive = true
        emailSeperator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: emailSeperator.bottomAnchor).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: loginContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: loginContainerView.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: loginContainerView.heightAnchor, multiplier: 1/3).isActive = true
    }
    
    func setProfileImageConstrains() {
        setProfileImage.centerXAnchor.constraint(equalTo: loginContainerView.centerXAnchor).isActive = true
        setProfileImage.bottomAnchor.constraint(equalTo: setUpSegmentedControl.topAnchor, constant: -12).isActive = true
        setProfileImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        setProfileImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setUploginRegisterButtonConstrains() {
        setUploginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        setUploginRegisterButton.topAnchor.constraint(equalTo: loginContainerView.bottomAnchor, constant: 12).isActive = true
        setUploginRegisterButton.widthAnchor.constraint(equalTo: loginContainerView.widthAnchor).isActive = true
        setUploginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setUpSegmentedControlConstrains() {
        setUpSegmentedControl.leftAnchor.constraint(equalTo: loginContainerView.leftAnchor).isActive = true
        setUpSegmentedControl.bottomAnchor.constraint(equalTo: loginContainerView.topAnchor, constant: -12).isActive = true
        setUpSegmentedControl.widthAnchor.constraint(equalTo: loginContainerView.widthAnchor).isActive = true
        setUpSegmentedControl.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { //set the statusBarColor
        return .lightContent
    }
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }
    
    
}

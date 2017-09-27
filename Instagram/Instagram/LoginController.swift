//
//  LoginController.swift
//  Instagram
//
//  Created by Ram Yadav on 9/12/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    let logoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        logoImageView.contentMode = .scaleAspectFill
        view.addSubview(logoImageView)
        
        logoImageView.anchor(left: nil, leftPadding: 0, right: nil, rightPadding: 0, top: nil, topPadding: 0, bottom: nil, bottomPadding: 0, width: 200, height: 50)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return view
    }()
    
    let dontHaveAnAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign Up.", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    func handleShowSignUp() {
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { //change the status bar color to white
        return .lightContent
    }
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.placeholder = "Email"
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    func handleLogIn() {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let err = error {
                print("Problem with Signing In: ", err)
                return
            }
            print("Succefully Sign In")
            self.dismiss(animated: true, completion: nil)
            
            //get reference of MianTabBarController to access the function
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {return}
            mainTabBarController.setUpViewController()
        }
    }
    
    
    func handleTextInputChange() {
        let istextValid = emailTextField.text?.characters.count ?? 0 > 0 &&
        passwordTextField.text?.characters.count ?? 0 > 0
        
        if istextValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor.white
        view.addSubview(dontHaveAnAccountButton) 
        view.addSubview(logoContainerView)
        
        logoContainerView.anchor(left: view.leftAnchor, leftPadding: 0, right: view.rightAnchor, rightPadding: 0, top: view.topAnchor, topPadding: 0, bottom: nil, bottomPadding: 0, width: 0, height: 150)
        
        dontHaveAnAccountButton.anchor(left: view.leftAnchor, leftPadding: 12, right: view.rightAnchor, rightPadding: 12, top: nil, topPadding: 0, bottom: view.bottomAnchor, bottomPadding: -12, width: 0, height: 40)
        
        setUpInputField()
    }
    
    fileprivate func setUpInputField() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.axis = .vertical
        view.addSubview(stackView)
        
        stackView.anchor(left: view.leftAnchor, leftPadding: 40, right: view.rightAnchor, rightPadding: -40, top: logoContainerView.bottomAnchor, topPadding: 40, bottom: nil, bottomPadding: 0, width: 0, height: 140)
    }
}







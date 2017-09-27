
//
//  ChatLogController.swift
//  ChatAppAgain
//
//  Created by Ram Yadav on 9/1/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate {
    var user: User? {
        didSet {
            navigationItem.title = user?.Name //set the name of the title of the user after selection
        }
    }
    override func viewDidLoad() {
        super .viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        setUpInputComponent()
    }
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter Texts ..."
        textField.delegate = self
        return textField
    }()
    
    func setUpInputComponent() {
        let containerView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(white: 0.98, alpha: 1)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let sendButton: UIButton = {
            let send = UIButton(type: .system)
            send.setTitle("Send", for: .normal)
            send.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
            send.translatesAutoresizingMaskIntoConstraints = false
            return send;
        }()
        
        let divider: UIView = {
            let divider = UIView()
            divider.translatesAutoresizingMaskIntoConstraints = false
            divider.backgroundColor = UIColor.gray
            return divider
        }()
        
        view.addSubview(containerView)
        view.addSubview(sendButton)
        view.addSubview(inputTextField)
        view.addSubview(divider)
       
        //containerView Constrains
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //setup input TextField Constrains...
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        //textField Constrains
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        //divider setup
        divider.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        divider.bottomAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        divider.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    func handleSend() {
        let ref = Database.database().reference()
        let childRef = ref.child("Messages").childByAutoId()
        let fromId = Auth.auth().currentUser!.uid
        let timeStamp = Int(NSDate().timeIntervalSince1970)
        let toId = user!.Id!
        let values = ["Message": inputTextField.text!, "ToId": toId, "FromId": fromId, "TimeStamp": timeStamp] as [String : Any]
        childRef.updateChildValues(values) //store the messages in the Firebase database
        inputTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}









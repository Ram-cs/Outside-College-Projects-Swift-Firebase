
//
//  ChatLogController.swift
//  Chat App
//
//  Created by Ram Yadav on 8/13/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout{
    var user: User? {
        didSet {
            navigationItem.title = user?.Name //setting the name at the bar of chatlogController
            observeMessages()
        }
    }
    
    let cellId = "cellId"
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0) //distance from TOP of the view
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.keyboardDismissMode = .interactive //to make keyboard slide down with sliding
      // setUpInputComponents() ->this is for the regular key handler
        
       // setUpKeyBoardObserver() -> this is for the regular key handler
    }
    
    lazy var inputTextFiled: UITextField = {
        let inputText = UITextField()
        inputText.placeholder = "Enter the text ..."
        inputText.translatesAutoresizingMaskIntoConstraints = false
        inputText.delegate = self
        return inputText
    }()
    
   lazy var inputContainerView: UIView = { //make keyboard sliding
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor = UIColor.white
    
        //send button
        let sendButton = UIButton(type: .system)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setTitle("Send", for: .normal)
        containerView.addSubview(sendButton)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
    
    //seperator
        let seperatorLineView = UIView()
        seperatorLineView.translatesAutoresizingMaskIntoConstraints = false
        seperatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
    
        containerView.addSubview(seperatorLineView)
        containerView.addSubview(self.inputTextFiled)
        containerView.addSubview(sendButton)
    
        //ios 9 constrains
        self.inputTextFiled.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        self.inputTextFiled.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        self.inputTextFiled.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.inputTextFiled.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
    
        //X,Y,W,H
        seperatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        seperatorLineView.bottomAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        seperatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //ios 9 constrains
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        

        return containerView
    }()
    
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool { //call to appear inputAcessoryView on the viewController
        return true
    }
    
    
    func setUpKeyBoardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardAppearance), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func handleKeyBoardAppearance(notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardHeight = (keyboardFrame?.height)! //GET THE KEY BOARD HEIGHT
        containerViewConstrains?.constant = -keyboardHeight
        
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue //key and input text popup and popoff
                //time will be the same
        UIView.animate(withDuration: keyboardDuration!) {
           self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) { //avoid memory leak for the keyboard, MUST call it when used keyboard show on/off
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self) //remove the observer
    }
    
    func handleKeyBoardHide(notification: NSNotification) {
        containerViewConstrains?.constant = 0
        
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.row]
        cell.textView.text = message.text //filled cell with message
        
        setUpCell(cell: cell, message: message)
        if let getTexts = messages[indexPath.row].text {
          cell.bubbleWithAnchor?.constant = estimateFrameForText(text: getTexts).width + 32
        }
        
        return cell
    }
    
    private func setUpCell(cell: ChatMessageCell, message: Message) {
        if let profileImageUrl = self.user?.ProfileImage {
            cell.profileImageView.loadImageWithCachUrlString(urlString: profileImageUrl)
        }
        if message.fromId == Auth.auth().currentUser?.uid {
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            cell.profileImageView.isHidden = true //image hidden
        } else {
            cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            cell.profileImageView.isHidden = false //image not hidden
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout() //when rotate the screen its maintain the size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //FIND THE HEIGHT OF THE TEXT
        var height: CGFloat = 80
        if let getText = messages[indexPath.row].text {
            height = estimateFrameForText(text: getText).height //get the height of the text
        }
        //change
        return CGSize(width: view.frame.width, height: height + 20)//here, with symboize UICollectionView
    }
    
    private func estimateFrameForText(text: String)->CGRect {
        let size = CGSize(width: 200, height: 1000) //height is just the random number
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: option, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: (16))], context: nil)
    }
    
    func observeMessages() {
        guard let currentUser = Auth.auth().currentUser?.uid else {
            return
        }
        let userMessageRef = Database.database().reference().child("user-messages")
        userMessageRef.child(currentUser).observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messageRef = Database.database().reference().child("Messages")
            messageRef.child(messageId).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                let message = Message()
                message.setValuesForKeys(dictionary)
                if message.chatPartnerId() == self.user?.id { //check if the message belogns to receipient
                    self.messages.append(message)
                    self.collectionView?.reloadData() //must reloaddata, otherwise don't show anything
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
 
    var containerViewConstrains: NSLayoutConstraint?

    func setUpInputComponents() {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        //ios 9 constrains
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerViewConstrains = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewConstrains?.isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //send button
        let sendButton = UIButton(type: .system)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setTitle("Send", for: .normal)
        containerView.addSubview(sendButton)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        //ios 9 constrains
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        //Create textField
        containerView.addSubview(inputTextFiled)
        
        
        //ios 9 constrains
        inputTextFiled.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextFiled.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextFiled.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextFiled.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        //seperator
        let seperatorLineView = UIView()
        seperatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(seperatorLineView)
        seperatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        
        //X,Y,W,H
        seperatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        seperatorLineView.bottomAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        seperatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    func handleSend() {
        let ref = Database.database().reference().child("Messages")
        let childRef = ref.childByAutoId() //if want to get childRef back, used childRef.key
        let toId = user!.id!
        let fromId = Auth.auth().currentUser!.uid
        let timeStamp = Int(NSDate().timeIntervalSince1970)
        let values: [String: Any] = ["text": inputTextFiled.text!, "toId": toId, "fromId": fromId, "timeStamp": timeStamp]
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print("Error uploading send into the database:\(error!)")
                return
            }
            
            let userMessageRef = Database.database().reference().child("user-messages").child(fromId)
            let messageId = childRef.key
            userMessageRef.updateChildValues([messageId: 1])
            
            let receipientUserMessageRef = Database.database().reference().child("user-messages").child("toId")
            receipientUserMessageRef.updateChildValues([messageId: 1])
        }
        
        
        inputTextFiled.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
}























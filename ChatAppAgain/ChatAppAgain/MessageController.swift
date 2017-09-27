//
//  ViewController.swift
//  ChatAppAgain
//
//  Created by Ram Yadav on 8/24/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit
import Firebase
class MessageController: UITableViewController {
    let cellId = "cellId"
    var messages = [Message]()
    var messageDictionary = [String: Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logoutHandler))

        let image = UIImage(named: "new_message_icon")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        isUserLoggedIn()
        observeMessages()
    }
    
    func isUserLoggedIn() {
        if Auth.auth().currentUser?.uid == nil { //if we don't have user, direct to signIN page
            perform(#selector(logoutHandler), with: self, afterDelay: 0)
        } else {
            //else
            fetchUserAndSetInNavTitle()
        }
    }

    func fetchUserAndSetInNavTitle() {
        guard let getUID = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("users").child(getUID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let users = User()
                users.setValuesForKeys(dictionary)
                self.setUpNavBarWithUser(user: users)
            }
            
        })
    }
    
    func observeMessages() {
        let ref = Database.database().reference().child("Messages")
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let setMessages = Message()
                setMessages.setValuesForKeys(dictionary)
                if setMessages.ToId != nil {
                    self.messageDictionary[setMessages.ToId!] = setMessages
                    self.messages = Array(self.messageDictionary.values)
                    self.messages.sort(by: { (message1, message2) -> Bool in
                        return (message1.TimeStamp?.intValue)! < (message2.TimeStamp?.intValue)! //sorting message list based on time
                    })
                }
                self.tableView.reloadData()
            }
        }, withCancel: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! UserCell
        let message = messages[indexPath.row]
        cell.message = message
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func setUpNavBarWithUser(user: User) {
        self.navigationItem.title = user.Name
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        let profileImage: UIImageView = {
            let profileImage = UIImageView()
            profileImage.layer.cornerRadius = 20
            profileImage.contentMode = .scaleAspectFill
            profileImage.clipsToBounds = true
            profileImage.translatesAutoresizingMaskIntoConstraints = false
            if let profileUrl = user.ImageURL {
                profileImage.loadImageUsingCacsheWithUrlString(url: profileUrl)
            }
             return profileImage
        }()
        
        let titleLavel: UILabel = {
            let nameLabel = UILabel()
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            nameLabel.text = user.Name
            return nameLabel
        }()
        
        let containerView = UIView() //creating this so that large name would fit inside perfectly
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        
        containerView.addSubview(profileImage)
        containerView.addSubview(titleLavel)
        titleView.addSubview(containerView)
        self.navigationItem.titleView  = titleView
        
        //set the ios constrains
        profileImage.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive =  true
        profileImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //set the ios constrains for title view
        titleLavel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 8).isActive = true
        titleLavel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        titleLavel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        titleLavel.heightAnchor.constraint(equalTo: profileImage.heightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
    }
    
    func selectChatlogControllerWithUser(user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func handleNewMessage() {
        let newMessageController = NewMessageController()
        newMessageController.messageController = self
        let navigationController = UINavigationController(rootViewController: newMessageController)
        present(navigationController, animated: true, completion: nil)
    }
    
    func logoutHandler() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print(error)
        }
        let loginController = LoginController() //present Login view controller
        loginController.messageController = self //messageController is NIL here, so MUST initialize it calling on LoginController
        present(loginController, animated: true, completion: nil)
    }
}


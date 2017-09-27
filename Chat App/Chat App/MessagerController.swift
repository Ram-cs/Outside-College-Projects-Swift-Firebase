//
//  ViewController.swift
//  Chat App
//
//  Created by Ram Yadav on 7/30/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit
import Firebase
class MessageController: UITableViewController {
let cellId = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        let messageButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.compose, target: self, action: #selector(messageNavigation))
        navigationItem.rightBarButtonItem = messageButton
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
                
        //USER HASN"T LOGGED IN
        checkIfUserLoggedIn()
    }
    
    var message = [Message]()
    var messageDictionary = [String: Message]()
   
    var timer: Timer?
    
    func observeUserMessages() {
        
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error occured with getting current user")
            return
        }
        let messageReference = Database.database().reference().child("user-messages").child(userId)
        messageReference.observe(.childAdded, with: { (snapshot) in
            let messageKey = snapshot.key
            
            let ref = Database.database().reference().child("Messages")
            ref.child(messageKey).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let message = Message()
                    message.setValuesForKeys(dictionary)
                    //                self.message.append(message)
                    
                    if let chatPartnerId = message.chatPartnerId() {
                        self.messageDictionary[chatPartnerId] = message
                        self.message = Array(self.messageDictionary.values) 
                        self.message.sort(by: { (message1, message2) -> Bool in //sorting message by its time
                            return (message1.timeStamp?.intValue)! > (message2.timeStamp?.intValue)!
                        })
                    }
                    self.timer?.invalidate() //must put timer to avoid bug, timer helps to call one time handleReloadTable other wise calls many times
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    func handleReloadTable() {
        DispatchQueue.main.async { //just for safe not to crash the applicaiton when load the content
            print("Reload has been called")
            self.tableView.reloadData()
        }
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     //   let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "newcell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let message = self.message[indexPath.row]
        cell.message = message
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = message[indexPath.row]
        
        guard let chatPartnerId = selectedUser.chatPartnerId() else {
            print("problem with gettting user from the cell")
            return
        }
        let ref = Database.database().reference().child("users")
        ref.child(chatPartnerId).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let user = User()
            user.id = chatPartnerId
            user.setValuesForKeys(dictionary)
            self.showChatControllerForUser(user: user)
            
        }, withCancel: nil)
        
    }
    
    func fetchUserAndSetNavBarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else {
            //if uid is nill then return
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
              // self.navigationItem.title = dictionary["Name"] as? String
                
                let user = User()
                user.setValuesForKeys(dictionary)
                self.setNavBarWithUser(user: user)
               
            }
            
        }, withCancel: nil)
    }
    
    func setNavBarWithUser(user: User) {
        message.removeAll()
        messageDictionary.removeAll()
        tableView.reloadData()
        
         observeUserMessages()
        
         //self.navigationItem.title = user.Name
        let titleView = UIView()
       // titleView.backgroundColor = UIColor.red
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
       
        let viewContainer = UIView() //to make long name fit in the blcok, created view controller
        titleView.addSubview(viewContainer)
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        viewContainer.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive  = true
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
    
        if let getImageUrl = user.ProfileImage {
            imageView.loadImageWithCachUrlString(urlString: getImageUrl)
        }
        
        viewContainer.addSubview(imageView)
        //set ios9 image constrains
        
        imageView.leftAnchor.constraint(equalTo: viewContainer.leftAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        nameLabel.text = user.Name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        viewContainer.addSubview(nameLabel)
        
        //set nameLabel constrains
        nameLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: viewContainer.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        
         self.navigationItem.titleView = titleView
        
        //TapgestrueRecognizer
//        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
    }
    
    func showChatControllerForUser(user: User)  {
        let chatLogController = ChatLogController(collectionViewLayout:UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    
    func messageNavigation() {
        let newMessageController = NewMessageController()
        newMessageController.messageController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    func checkIfUserLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
           fetchUserAndSetNavBarTitle()
        }

   }

    func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print(error)
        }
        let loginController = LoginController();
        loginController.messangerController = self
        present(loginController, animated: true, completion: nil)
    }
}


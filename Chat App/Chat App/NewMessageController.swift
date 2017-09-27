//
//  NewMessageController.swift
//  Chat App
//
//  Created by Ram Yadav on 8/1/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    let cellID = "cellID"
   
     var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        
        
        fetchUser()
    }
    
    func fetchUser() {
       Database.database().reference().child("users").observe(.childAdded, with: { (snapShot) in
            if let dictionary = snapShot.value as? [String: AnyObject] {
                let user = User()
                user.id = snapShot.key
                user.setValuesForKeys(dictionary)
                self.users.append(user)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
        }
            
        }, withCancel: nil)
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.Name
        cell.detailTextLabel?.text = user.Email
        

        
        if let imageProfile = user.ProfileImage { //get the URL photo address
           cell.profileImageView.loadImageWithCachUrlString(urlString: imageProfile)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    var messageController: MessageController?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) //dismiss the row upon click on it
        let user = users[indexPath.row]
       messageController?.showChatControllerForUser(user: user)
    }
}



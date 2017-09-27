//
//  NewMessageController.swift
//  ChatAppAgain
//
//  Created by Ram Yadav on 8/25/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    let cellId = "cellId"
    var message = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelHandle))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        fetchUser()
    }
    
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.Id = snapshot.key
                user.setValuesForKeys(dictionary)
                self.message.append(user)
                self.tableView.reloadData()
            }
        })
    }
    
    func cancelHandle() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return message.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    var messageController: MessageController?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = message[indexPath.row]
        dismiss(animated: true, completion: nil) //dismiss the table view
        messageController?.selectChatlogControllerWithUser(user: user)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! UserCell
        
        let user = message[indexPath.row]
        cell.textLabel?.text = user.Name
        cell.detailTextLabel?.text = user.Email
        
        if let url = user.ImageURL {
            cell.profileImageView.loadImageUsingCacsheWithUrlString(url: url)
        }
        
        return cell
    }
}


//
//  FriendsControllerHelper.swift
//  FacebookMessanger
//
//  Created by Ram Yadav on 8/20/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit

extension FriendsController {
    func setupData() {
        let friend = Friend()
        friend.name = "My Firend name"
        friend.profileImageName = "Dog"
        
        let message = Message()
        message.friend = friend
        message.text = "Hi there here it is from you from.."
        
        let anotherfriend = Friend()
        anotherfriend.name = "Human"
        anotherfriend.profileImageName = "human"
        
        let anothermessage = Message()
        anothermessage.friend = anotherfriend
        anothermessage.text = "I am a human dominating the earth"
        
        messages = [message, anothermessage] //store the message inside the array
    }
    
}

class Friend: NSObject {
    var name: String?
    var profileImageName: String?
}

class Message: NSObject {
    var text: String?
    var date: NSDate?
    
    var friend: Friend?
}

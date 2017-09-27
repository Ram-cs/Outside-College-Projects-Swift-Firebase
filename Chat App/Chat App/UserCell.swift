//
//  UserCell.swift
//  Chat App
//
//  Created by Ram Yadav on 8/15/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

//video 16---------------------------------------------------
import UIKit
import Firebase

class UserCell: UITableViewCell {
    
    var message: Message? {
        didSet {
            setUpNameAndProfileImage()

            detailTextLabel?.text = message?.text
            //cell.textLabel?.text = self.message[indexPath.row].text
            
            if let seconds = message?.timeStamp?.doubleValue {
                let timeStampDate = NSDate(timeIntervalSince1970: seconds)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                
                timeLable.text = dateFormatter.string(from: timeStampDate as Date)
            }
        }
    }
    
    private func setUpNameAndProfileImage() {
        
        if let id = message?.chatPartnerId() {
            let ref = Database.database().reference().child("users")
            ref.child(id).observeSingleEvent(of: .value, with: { (snapShot) in
                if let dictionary = snapShot .value as? [String: AnyObject] {
                    self.textLabel?.text = dictionary["Name"] as? String
                    
                    if let profileUrl = dictionary["ProfileImage"] as? String {
                        self.profileImageView.loadImageWithCachUrlString(urlString: profileUrl)
                    }
                }
            }, withCancel: nil)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "1")
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let timeLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(timeLable)
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        
          //need x,y,width,height anchors
        //TimeLabel
        timeLable.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLable.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        timeLable.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLable.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

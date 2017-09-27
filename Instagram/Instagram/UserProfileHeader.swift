//
//  UserProfileHeader.swift
//  Instagram
//
//  Created by Ram Yadav on 9/11/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
    
    var user: User? {
        didSet {
            guard let urlString = user?.profileURL else {return}
            profileImageView.loadImage(urlString: urlString)
            userNameLabel.text = user?.userName
            setUpEditFollowButton()
        }
    }
    
    fileprivate func setUpEditFollowButton() {
        guard let currentLoggedInUser = Auth.auth().currentUser?.uid else {return}
        guard let uid = user?.uid else {return}
        
        if currentLoggedInUser == uid {
//            editProfileFollowButton.setTitle("Edit Profile", for: .normal)
        } else {
            
            let ref = Database.database().reference().child("following").child(currentLoggedInUser).child(uid)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                    self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                } else {
                    self.setUpFollowStyle()
                }
            }, withCancel: { (error) in
                print("failed to check if following: ", error)
                return
            })
        }
    }
    
    func handleEditProfileOrFollow() {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else {return}
        guard let userId = user?.uid else {return}
        
        if editProfileFollowButton.titleLabel?.text == "Unfollow" {
            let ref = Database.database().reference().child("following").child(currentLoggedInUserId).child(userId)
            ref.removeValue(completionBlock: { (error, reference) in
                if let err = error {
                    print("Failed to unfollow the user: ", err)
                    return
                }
            })
            print("Succefully Unfollow the user: ", user?.userName ?? "")
            setUpFollowStyle()
        } else {
            let ref = Database.database().reference().child("following").child(currentLoggedInUserId)
            let values = [userId: 1]
            ref.updateChildValues(values) { (error, reference) in
                if let err = error {
                    print("Failed to fetch the follow user: ",err)
                    return
                }
                print("Succefully follow the user:", self.user?.userName ?? "")
                
                self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                self.editProfileFollowButton.backgroundColor = UIColor.white
                self.editProfileFollowButton.setTitleColor(UIColor.black, for: .normal)
            }
        }
    }
    
    fileprivate func setUpFollowStyle() {
        editProfileFollowButton.setTitle("Follow", for: .normal)
        editProfileFollowButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        editProfileFollowButton.setTitleColor(UIColor.white, for: .normal)
        editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    }
    
    let profileImageView: CustomeImageView = {
        let imageView = CustomeImageView()
        return imageView
    }()
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()

    let bookMarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let postLevels: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let followersLevels: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "followers", attributes: [NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let followingLevels: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "following", attributes: [NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var editProfileFollowButton: UIButton = { //must be LAZY VAR to execute the addtarget #selector
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.tintColor = UIColor.black
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside) //must be touchUpInside
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImageView)
        profileImageView.anchor(left: self.leftAnchor, leftPadding: 12, right: nil, rightPadding: 0, top: self.topAnchor, topPadding: 12, bottom: nil, bottomPadding: 0, width: 80, height: 80)
        
        profileImageView.layer.cornerRadius = 40
        profileImageView.clipsToBounds = true
        
        setUpButtonToolbar()
        addSubview(userNameLabel)
        
        userNameLabel.anchor(left: self.leftAnchor, leftPadding: 12, right: self.rightAnchor, rightPadding: 12, top: profileImageView.bottomAnchor, topPadding: 4, bottom: gridButton.topAnchor, bottomPadding: 0, width: 0, height: 0)
        
        setUpUserStatsView()
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(left: postLevels.leftAnchor, leftPadding: 0, right: followingLevels.rightAnchor, rightPadding: -12, top: postLevels.bottomAnchor, topPadding: 2, bottom: nil, bottomPadding: 0, width: 0, height: 34)
    }
    
    fileprivate func setUpUserStatsView() {
        let stackView = UIStackView(arrangedSubviews: [postLevels, followersLevels, followingLevels])
        stackView.distribution  = .fillEqually
        addSubview(stackView)
        stackView.anchor(left: profileImageView.rightAnchor, leftPadding: 12, right: self.rightAnchor, rightPadding: 0, top: self.topAnchor, topPadding: 12, bottom: nil, bottomPadding: 0, width: 0, height: 50)
    }
    
    fileprivate func setUpButtonToolbar() {
        
        let topDividerView = UIView()
        topDividerView.backgroundColor = UIColor.lightGray
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = UIColor.lightGray
        
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookMarkButton])
        stackView.distribution = .fillEqually
        
        self.addSubview(stackView)
        self.addSubview(topDividerView)
        self.addSubview(bottomDividerView)
        
        stackView.anchor(left: self.leftAnchor, leftPadding: 0, right: self.rightAnchor, rightPadding: 0, top: nil, topPadding: 0, bottom: self.bottomAnchor, bottomPadding: 0, width: 0, height: 50)
       
        topDividerView.anchor(left: self.leftAnchor, leftPadding: 0, right: self.rightAnchor, rightPadding: 0, top: nil, topPadding: 0, bottom: stackView.topAnchor, bottomPadding: 0, width: 0, height: 0.5)
        
        bottomDividerView.anchor(left: self.leftAnchor, leftPadding: 0, right: self.rightAnchor, rightPadding: 0, top: stackView.bottomAnchor, topPadding: 0, bottom: nil, bottomPadding: 0, width: 0, height: 0.5)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}







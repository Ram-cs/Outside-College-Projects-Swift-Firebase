//
//  HomePostCell.swift
//  Instagram
//
//  Created by Ram Yadav on 9/15/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit
class HomePostCell: UICollectionViewCell {
    var post: Post? {
        didSet {
            guard let urlString = post?.imageURL else {return}
            photoImageView.loadImage(urlString: urlString)
            userNameLabel.text = post?.user.userName
            guard let profileUrl = post?.user.profileURL else {return}
            userProfileImageView.loadImage(urlString: profileUrl)
            
            
            setUPAttibuteCaption()
        }
    }
    
    fileprivate func setUPAttibuteCaption() {
        guard let post = self.post else {return}

        let attibutedText = NSMutableAttributedString(string: post.user.userName, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
        attibutedText.append(NSAttributedString(string: " \(post.caption)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]))
        attibutedText.append(NSAttributedString(string: "\n\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 4)])) //for the spacing
        
        let timeAgoDisplay = post.creationDate.timeAgoDisplay()
        attibutedText.append(NSAttributedString(string: timeAgoDisplay, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.lightGray]))
        captionLabel.attributedText = attibutedText
    }
    
    let userProfileImageView: CustomeImageView = {
        let iv = CustomeImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let photoImageView: CustomeImageView = {
        let iv = CustomeImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let sendMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let bookMarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0 //to rap up text into another line
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoImageView)
        addSubview(userProfileImageView)
        addSubview(userNameLabel)
        addSubview(optionsButton)
        
        userNameLabel.anchor(left: userProfileImageView.rightAnchor, leftPadding: 8, right: optionsButton.leftAnchor, rightPadding: -8, top: self.topAnchor, topPadding: 0, bottom: photoImageView.topAnchor, bottomPadding: 0, width: 0, height: 0)
        
        photoImageView.anchor(left: self.leftAnchor, leftPadding: 0, right: self.rightAnchor, rightPadding: 0, top: userProfileImageView.bottomAnchor, topPadding: 8, bottom: nil, bottomPadding: 0, width: 0, height: 0)
        photoImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        
        optionsButton.anchor(left: nil, leftPadding: 0, right: self.rightAnchor, rightPadding: 0, top: self.topAnchor, topPadding: 0, bottom: photoImageView.topAnchor, bottomPadding: 0, width: 44, height: 0)
       
        userProfileImageView.anchor(left: self.leftAnchor, leftPadding: 8, right: nil, rightPadding: 0, top: self.topAnchor, topPadding: 8, bottom: nil, bottomPadding: 0, width: 40, height: 40)
        userProfileImageView.layer.cornerRadius = 40 / 2
        
        addSubview(captionLabel)
        setUpActionButton()
        
        captionLabel.anchor(left: self.leftAnchor, leftPadding: 8, right: self.rightAnchor, rightPadding: -8, top: likeButton.bottomAnchor, topPadding: 0, bottom: self.bottomAnchor, bottomPadding: 0, width: 0, height: 0) //make sure put under setUpActionButton otherwise app will crash
    }
    
    fileprivate func setUpActionButton() {
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, sendMessageButton])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        stackView.anchor(left: self.leftAnchor, leftPadding: 8, right: nil, rightPadding: 0, top: photoImageView.bottomAnchor, topPadding: 0, bottom: nil, bottomPadding: 0, width: 120, height: 50)
        
        addSubview(bookMarkButton)
        bookMarkButton.anchor(left: nil, leftPadding: 0, right: self.rightAnchor, rightPadding: -8, top: photoImageView.bottomAnchor, topPadding: 0, bottom: nil, bottomPadding: 0, width: 40, height: 50)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

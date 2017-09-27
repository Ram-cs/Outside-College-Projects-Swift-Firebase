//
//  UserSearchCell.swift
//  Instagram
//
//  Created by Ram Yadav on 9/17/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit

class UserSearchCell: UICollectionViewCell {
    var user: User? {
        didSet {
            self.userNameTextLabel.text = user?.userName
            guard let imageUrl = user?.profileURL else {return}
            self.profileImageView.loadImage(urlString: imageUrl)
        }
    }
    let profileImageView: CustomeImageView = {
        let iv = CustomeImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let userNameTextLabel: UILabel = {
        let tl = UILabel()
        tl.text = "Username"
        tl.font = UIFont.systemFont(ofSize: 14)
        return tl
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(profileImageView)
        self.addSubview(userNameTextLabel)
        profileImageView.anchor(left:self.leftAnchor, leftPadding: 8, right: nil, rightPadding: 0, top: nil, topPadding: 0, bottom: nil, bottomPadding: 0, width: 50, height: 50)
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.layer.cornerRadius = 25
        
        userNameTextLabel.anchor(left: profileImageView.rightAnchor, leftPadding: 8, right: self.rightAnchor, rightPadding: 0, top: self.topAnchor, topPadding: 0, bottom: self.bottomAnchor, bottomPadding: 0, width: 0, height: 0)
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        addSubview(seperatorView)
        seperatorView.anchor(left: userNameTextLabel.leftAnchor, leftPadding: 0, right: self.rightAnchor, rightPadding: 0, top: nil, topPadding: 0, bottom: self.bottomAnchor, bottomPadding: 0, width: 0, height: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

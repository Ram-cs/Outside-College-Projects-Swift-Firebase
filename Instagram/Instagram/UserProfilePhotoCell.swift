//
//  UserProfilePhotoCell.swift
//  Instagram
//
//  Created by Ram Yadav on 9/14/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit

class UserProfilePhotoCell: UICollectionViewCell {
    var post: Post? {
        didSet {
            guard let imageUrl = post?.imageURL else {return}
            photoImageView.loadImage(urlString: imageUrl)
        }
    }
    let photoImageView: CustomeImageView = {
        let iv = CustomeImageView()
        
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(photoImageView)
        photoImageView.anchor(left: self.leftAnchor, leftPadding: 0, right: self.rightAnchor, rightPadding: 0, top: self.topAnchor, topPadding: 0, bottom: self.bottomAnchor, bottomPadding: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

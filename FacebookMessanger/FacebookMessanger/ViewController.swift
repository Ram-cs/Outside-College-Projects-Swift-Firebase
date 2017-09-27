//
//  ViewController.swift
//  FacebookMessanger
//
//  Created by Ram Yadav on 8/18/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit
class FriendsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var messages: [Message]?
    private var cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(MessageCell.self, forCellWithReuseIdentifier: "cellId")
        navigationItem.title = "Recents"
        setupData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let message = messages {
           return message.count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)  as! MessageCell
        cell.message = messages?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
}

class MessageCell: BaseCell {
    var message: Message? {
        didSet {
            nameLavel.text = message?.friend?.name
            messageLavel.text = message?.text
            
            if let profileImage = message?.friend?.profileImageName {
                profileImageView.image = UIImage(named: profileImage)
                hasReadImageView.image = UIImage(named: profileImage)
            }
            
            if let date = message?.date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                timeLabel.text = dateFormatter.string(from: date as Date)
                
            }
            
        }
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "human")
        imageView.layer.cornerRadius = 34
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let seperatorView: UIView = {
        let separator = UIView()
        separator.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return separator
    }()
    
    let nameLavel: UILabel = {
       let lavel = UILabel()
        lavel.font = UIFont.systemFont(ofSize: 16)
        lavel.text = "MY Friend"
        return lavel
    }()
    
    let messageLavel: UILabel = {
        let label = UILabel()
        label.text = "MY Message Label is pretty very long message ..."
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(white: 0.5, alpha: 1)
        label.text = "12:23 pm"
        return label
    }()
    
    let hasReadImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "human")
        image.layer.cornerRadius = 15
        image.clipsToBounds = true
        return image
    }()
    
    private func setUpcontainerView() {
        let containerView = UIView()
//        containerView.backgroundColor = UIColor.red
        addSubview(containerView)
    
        addConstrainsWithFormat(format: "H:|-90-[v0]-12-|", views: containerView)
        addConstrainsWithFormat(format: "V:[v0(60)]", views: containerView)
        addConstraints([NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)]) //image in the center
        
        //LABEL
        containerView.addSubview(nameLavel)
        containerView.addSubview(messageLavel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(hasReadImageView)
        
        addConstrainsWithFormat(format: "H:|[v0][v1(80)]|", views: nameLavel, timeLabel)
        addConstrainsWithFormat(format: "V:|[v0][v1(24)]|", views: nameLavel, messageLavel)
        //Message Label
        addConstrainsWithFormat(format: "H:|[v0]-8-[v1(30)]-12-|", views: messageLavel, hasReadImageView)
        addConstrainsWithFormat(format: "V:|[v0(30)]", views: timeLabel)

        addConstrainsWithFormat(format: "V:|-30-[v0(30)]", views: hasReadImageView)
    }
    
    override func setupView() {
        addSubview(profileImageView)
        addSubview(seperatorView)
        
        setUpcontainerView()
        
        addConstrainsWithFormat(format: "H:|-12-[v0(68)]", views: profileImageView)
        addConstrainsWithFormat(format: "V:[v0(68)]", views: profileImageView)
        addConstrainsWithFormat(format: "H:|-82-[v0]|", views: seperatorView)
        addConstrainsWithFormat(format: "V:[v0(1)]|", views: seperatorView)
        
       addConstraints([NSLayoutConstraint(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)]) //image in the center
        
    }
}

extension UIView {
    func addConstrainsWithFormat(format: String, views: UIView...) {
        var viewDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
           let key = "v\(index)"
            viewDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionary))
    }
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView () {
        backgroundColor = UIColor.blue
    }
}



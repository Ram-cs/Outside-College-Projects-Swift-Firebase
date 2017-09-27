//
//  HomeController.swift
//  Instagram
//
//  Created by Ram Yadav on 9/15/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.delegate = self
        
        //atomatically call the refresh when add post
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: NSNotification.Name(rawValue: SharePhotoControler.updateFeedNotificationName), object: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
        
        let refreshControll = UIRefreshControl()
        collectionView?.refreshControl = refreshControll
        refreshControll.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        setUpNavigationItem()
        fetchAllPost()
    }
    
    func handleCamera() {
        let comeraController = CameraController()
        present(comeraController, animated: true, completion: nil)
        
    }
    
    func handleUpdateFeed() {
        handleRefresh()
    }
    
    func handleRefresh() {
        posts.removeAll() //remove all when refresh to remove duplicate of the posts
        fetchAllPost()
    }
    
    func fetchAllPost() {
        print("Refreshing the page...")
        fetchPosts()
        fetchFollowingUserIds()
        self.collectionView?.refreshControl?.endRefreshing() //end the refresh page
    }
    
    fileprivate func fetchFollowingUserIds() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("following").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionaries = snapshot.value as? [String: Any] {
                dictionaries.forEach({ (key, value) in
                    Database.fetchUserWithUID(uid: key, completion: { (user) in
                        self.fetchPostWithUser(user: user)
                    })
                })
            }
        }) { (err) in
            print("Failed to fetch the followers userID: ", err)
        }
    }
    
    fileprivate func setUpNavigationItem() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
    }
    
    var posts = [Post]()
    
    func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchPostWithUser(user: user)
        }
       
    }
    
    fileprivate func fetchPostWithUser(user: User) {
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionaries = snapshot.value as? [String: Any] else {return}
            dictionaries.forEach({ (key, value) in //loop for the dictionary
                guard let dictionary = value as? [String: Any] else {return}
                
                let post = Post(user: user, dictionary: dictionary)
                self.posts.append(post)
            })
            self.posts.sort(by: { (p1, p2) -> Bool in
                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
            })
            self.collectionView?.reloadData()
        }) { (err) in
            print("Failed to fetch posts:", err)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        if posts.count > 0 {
           cell.post = posts[indexPath.item]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 40 + 8 + 8
        height += view.frame.width
        height += 50
        height += 80
        
        return CGSize(width: view.frame.width, height: height)
    }
}







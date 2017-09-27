//
//  UserProfileController.swift
//  Instagram
//
//  Created by Ram Yadav on 9/11/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit
import Firebase
class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let headerId = "headerId"
    let cellId = "cellId"
    var userId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        fetchUser()
        collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
        setUpLogOutButton()
    }
    
    var post = [Post]()
    
    fileprivate func fetchOrderedPosts() {
        guard let uid = user?.uid else {return}
        let ref = Database.database().reference().child("posts").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            
            guard let user = self.user else {return}
            let posts = Post(user: user, dictionary: dictionary)
            self.post.insert(posts, at: 0)
            self.collectionView?.reloadData()
        }) { (err) in
            print("Failed to fetch posts:", err)
        }
    }
    
    fileprivate func setUpLogOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
    }
    
    func handleLogOut() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .default, handler: { (_) in
            do {
               try Auth.auth().signOut()
            } catch let signOutError {
                print("Problem signing Out:", signOutError)
            }
            
            let loginController = LoginController()
            let navController = UINavigationController(rootViewController: loginController)
            self.present(navController, animated: true, completion: nil)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alertController, animated: true, completion: nil)
    }
    
    var user: User?
    
    fileprivate func fetchUser() {
        let uid = userId ?? Auth.auth().currentUser?.uid ?? ""
        
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.user = user
            let userName = self.user?.userName
            self.navigationItem.title = userName
            
            self.collectionView?.reloadData()
            self.fetchOrderedPosts()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView  {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! UserProfileHeader
        header.user = self.user
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfilePhotoCell
        cell.post = post[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
}






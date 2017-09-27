//
//  UserSearchController.swift
//  Instagram
//
//  Created by Ram Yadav on 9/17/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit
import Firebase

class UserSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
  
    let cellId = "cellId"
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter the user name"
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        sb.delegate = self
        //change the background color of the search bar
        return sb
    }()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredUser = users
        } else {//filteruser has only filtered users name and its number
            filteredUser = self.users.filter { (user) -> Bool in
                return user.userName.lowercased().contains(searchText.lowercased())
            }
        }
        self.collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        navigationController?.navigationBar.addSubview(self.searchBar)
        let bar = navigationController?.navigationBar
        searchBar.anchor(left: bar?.leftAnchor, leftPadding: 8, right: bar?.rightAnchor, rightPadding: -8, top: bar?.topAnchor, topPadding: 0, bottom: bar?.bottomAnchor, bottomPadding: 0, width: 0, height: 0)
        
        collectionView?.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.delegate = self
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .onDrag //when drag on the screen, keybaord dismiss
        
        fetchUser()
    }
    
    var filteredUser = [User]()
    var users = [User]()
    fileprivate func fetchUser() {
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else {return}
            dictionaries.forEach({ (key, value) in
                if key == Auth.auth().currentUser?.uid {
                    return
                }
                guard let userDictionary = value as? [String: Any] else {return}
                let user = User(uid: key, dictionary: userDictionary)
                self.users.append(user)
            })
            self.users.sort(by: { (u1, u2) -> Bool in
                return u1.userName.compare(u2.userName) == .orderedAscending
            })
            self.filteredUser = self.users
            
            self.collectionView?.reloadData()
        }) { (error) in
            print("Failed to fetch the user for search controller,", error)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUser.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserSearchCell
        cell.user = filteredUser[indexPath.item]
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) { //bring bar button back in searchControoler
        super.viewWillAppear(animated)
        searchBar.isHidden = false
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.isHidden = true
        searchBar.resignFirstResponder() //keyboard will disapper when transit to viewController
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        let user = filteredUser[indexPath.item]
        userProfileController.userId = user.uid
        navigationController?.pushViewController(userProfileController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }
}

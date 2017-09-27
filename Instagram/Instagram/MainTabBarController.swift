//
//  MainTabBarController.swift
//  Instagram
//
//  Created by Ram Yadav on 9/11/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    //when seleset tabbar, this function will call
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.index(of: viewController) //get the index of controller
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: photoSelectorController)
            present(navController, animated: true, completion: nil)
            
            return false
        }
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        DispatchQueue.main.async { //must put in dispatchque because of thead
            if Auth.auth().currentUser == nil {
                let logInController = LoginController()
                let navController = UINavigationController(rootViewController: logInController)
                self.present(navController, animated: true, completion: nil)
            }
        }
        setUpViewController()
    }
    
    func setUpViewController() {
        //HOME
        let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootvViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        //SEARCH
        let searchViewController = UserSearchController(collectionViewLayout: UICollectionViewFlowLayout())
        
        let searchNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootvViewController: searchViewController)
        
        //Plus
        let plusNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"))
        //Like
        let likeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"))
        //profile nav controller
        let userProfileViewController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        let userNavController = UINavigationController(rootViewController: userProfileViewController)
        
        userNavController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        userNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        tabBar.tintColor = UIColor.black //make black color to the bar
        
        viewControllers = [homeNavController,
                           searchNavController,
                           plusNavController,
                           likeNavController,
                           userNavController]
        
        //modify tabbar item insects
        guard let items = tabBar.items else {return}
        for item in items {
            item.imageInsets = UIEdgeInsets.init(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage,rootvViewController: UIViewController = UIViewController())-> UINavigationController {
        let viewController = rootvViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        tabBar.tintColor = UIColor.black
        return navController
    }
}

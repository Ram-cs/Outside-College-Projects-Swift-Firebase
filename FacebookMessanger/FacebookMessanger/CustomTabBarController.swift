//
//  CustomTabBarController.swift
//  FacebookMessanger
//
//  Created by Ram Yadav on 8/20/17.
//  Copyright © 2017 Ram Yadav. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super .viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        let friendViewController = FriendsController(collectionViewLayout: layout)
        let navController = UINavigationController(rootViewController: friendViewController)
        navController.tabBarItem.title = "Recents"
        navController.tabBarItem.image = UIImage(named: "recent")
        
        let settings = createDummyNavControllerWithTitle(title: "Settings", imageName: "settings")
        let calls = createDummyNavControllerWithTitle(title: "Calls", imageName: "calls")
        let peoples = createDummyNavControllerWithTitle(title: "People", imageName: "people")
        let groups = createDummyNavControllerWithTitle(title: "Groups", imageName: "groups")
        viewControllers = [navController, settings, calls, peoples, groups]
    }
    
    private func createDummyNavControllerWithTitle(title: String, imageName: String)-> UINavigationController {
        let viewController = UIViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = UIImage(named: imageName)
        return navigationController
    }

}

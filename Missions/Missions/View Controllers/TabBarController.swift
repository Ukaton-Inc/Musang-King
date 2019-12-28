//
//  TabBarController.swift
//  Missions
//
//  Created by Elina Lua Ming on 12/27/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // view controllers
        let gamesVC = GamesViewController()
        let gamesIcon = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        gamesVC.tabBarItem = gamesIcon
        
        let homeVC = SetupDeviceTableViewController()
        let homeIcon = UITabBarItem(title: "Home", image: UIImage(named: "settings"), tag: 1)
        homeVC.tabBarItem = homeIcon
        
        // set root vc
        let viewControllers = [homeVC, gamesVC]
        
        self.viewControllers = viewControllers
    }
    
}

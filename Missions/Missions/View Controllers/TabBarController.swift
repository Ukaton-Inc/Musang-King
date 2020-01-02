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
        self.navigationItem.title = "Games"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // view controllers
        let gamesVC = GamesViewController()
        let gamesIcon = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
        gamesVC.tabBarItem = gamesIcon
        
        let settingsVC = SetupDeviceTableViewController()
        let settingsIcon = UITabBarItem(title: "Settings", image: UIImage(named: "settings"), tag: 1)
        settingsVC.tabBarItem = settingsIcon
        
        // set root vc
        let viewControllers = [gamesVC, settingsVC]
        
        self.viewControllers = viewControllers
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0:
            self.navigationItem.title = "Games"
        case 1:
            self.navigationItem.title = "Settings"
        default:
            break
        }
    }
}

//
//  GameOneViewController.swift
//  Missions
//
//  Created by Elina Lua Ming on 12/27/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit

class GameOneViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavBar()
        self.setupViews()
        self.applyConstraints()
    }
    
}

extension GameOneViewController {
    
    func setupNavBar() {
        self.tabBarController?.navigationItem.title = "One"
    }
    
    func setupViews() {
        self.view.backgroundColor = .white
    }
    
    func applyConstraints() {
        
    }

}

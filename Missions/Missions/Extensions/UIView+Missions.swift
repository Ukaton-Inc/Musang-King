//
//  UIView+Ext.swift
//  Missions
//
//  Created by Elina Lua Ming on 12/23/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit

extension UIView {
    
    func pin(to superView: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superView.topAnchor),
            self.bottomAnchor.constraint(equalTo: superView.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superView.trailingAnchor)
        ])
    }
    

    
}

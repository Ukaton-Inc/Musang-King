//
//  NotificationCenter+Missions.swift
//  Missions
//
//  Created by Elina Lua Ming on 12/23/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import Foundation

extension NotificationCenter {
    
    static func postSensorValues(side: BLEDeviceSide, values: [Int]) {
        
        let name = side.rawValue
        self.default.post(
            name: NSNotification.Name(rawValue: name),
            object: nil,
            userInfo: ["values": values]
        )
    }
    
}

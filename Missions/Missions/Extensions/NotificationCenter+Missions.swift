//
//  NotificationCenter+Missions.swift
//  Missions
//
//  Created by Umar Qattan on 12/23/19.
//  Copyright © 2019 Umar Qattan. All rights reserved.
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

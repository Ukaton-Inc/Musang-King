//
//  Array+Missions.swift
//  Missions
//
//  Created by Umar Qattan on 12/23/19.
//  Copyright © 2019 Umar Qattan. All rights reserved.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

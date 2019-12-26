//
//  Enums.swift
//  Missions
//
//  Created by Elina Lua Ming on 12/23/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit


enum BLEDeviceSide: String {
    case left = "left"
    case right = "right"
}

enum BLEAction: UInt8 {
    case stopStream
    case startStream
    case samplingRate
    
    func actionForByte(_ byte: UInt8) -> BLEAction {
        switch byte {
        case 0:
            return .stopStream
        case 1:
            return .startStream
        default:
            return .samplingRate
        }
    }
}

enum Stance: Float {
    case left = -1
    case semiLeft = -0.5
    case neutral = 0.0
    case semiRight = 0.5
    case right = 1
    
    
    static func stanceForValue(_ value: Float) -> Stance {
        switch value {
        case -1.1 ..< -0.75:
            return .left
        case -0.75 ..< -0.25:
            return .semiLeft
        case -0.25 ..< 0.25:
            return .neutral
        case 0.25 ..< 0.75:
            return .semiRight
        case 0.75 ..< 1.1:
            return .right
        default: return .neutral
        }
    }
    
    var valueForStance: Float {
        switch self {
        case .left: return -1
        case .semiLeft: return -0.5
        case .neutral: return 0
        case .semiRight: return 0.5
        case .right: return 1
        }
    }
    
    static func stanceFromString(_ string: String) -> Stance {
        switch string {
        case "left": return .left
        case "semi_left": return .semiLeft
        case "neutral": return .neutral
        case "semi_right": return .semiRight
        case "right": return .right
        default: return .neutral
        }
    }
    
    var stanceString: String {
        switch self {
        case .left: return "left"
        case .semiLeft: return "semi_left"
        case .neutral: return "neutral"
        case .semiRight: return "semi_right"
        case .right: return "right"
        }
    }

    var stanceLabelString: String {
        switch self {
        case .left: return "Left"
        case .semiLeft: return "Semi Left"
        case .neutral: return "Neutral"
        case .semiRight: return "Semi Right"
        case .right: return "Right"
        }
    }
}

enum Activity: String {
    case walk = "walk"
    case run = "run"
    case squat = "squat"
    case stand = "stand"
    
    var activityString: String {
        return self.rawValue.capitalized
    }
    
}

enum Ball: Int {
    case left
    case right
}

@available (iOS 13, *)
enum SessionState: Int {
    case stop
    case record
    
    var image: UIImage? {
        switch self {
        case .stop:
            return UIImage(systemName: "circle.fill")
        case .record:
            return UIImage(systemName: "square.fill")
        }
    }
    
    var toggle: SessionState {
        switch self {
        case .stop:
            return .record
            
        case .record:
            return .stop
        }
    }
}

@available (iOS 13, *)
enum PlaybackState: Int {
    case pause
    case play
    
    var image: UIImage? {
        switch self {
        case .pause:
            return UIImage(systemName: "play.fill")
        case .play:
            return UIImage(systemName: "pause.fill")
        }
    }
    
    var toggle: PlaybackState {
        switch self {
        case .pause:
            return .play
        case .play:
            return .pause
        }
    }
    
    var actualImage: UIImage? {
        switch self {
        case .play:
            return UIImage(systemName: "play.fill")
        case .pause:
            return UIImage(systemName: "pause.fill")
        }
    }
}

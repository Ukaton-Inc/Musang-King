//
//  MissionsView.swift
//  Missions
//
//  Created by Elina Lua Ming on 12/23/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit

class MissionsView: UIView {
    
    struct Constant {
        static let sensor: CGFloat = 27/414
        
        // multiplier 207 is supposed to be the width from NSLayout but idk how to get it
        static let halfScreenWidth = UIScreen.main.bounds.width / 2
        
        static let positionXLeft0: CGFloat = -105/207 * halfScreenWidth
        static let positionYLeft0: CGFloat = -106.5/207 * halfScreenWidth
        static let positionXRight0: CGFloat = 105/207 * halfScreenWidth
        static let positionYRight0: CGFloat = -106.5/207 * halfScreenWidth
        
        static let positionXLeft1: CGFloat = -145/207 * halfScreenWidth
        static let positionYLeft1: CGFloat = -93.5/207 * halfScreenWidth
        static let positionXRight1: CGFloat = 145/207 * halfScreenWidth
        static let positionYRight1: CGFloat = -93.5/207 * halfScreenWidth
        
        static let positionXLeft2: CGFloat = -110/207 * halfScreenWidth
        static let positionYLeft2: CGFloat = 95.5/207 * halfScreenWidth
        static let positionXRight2: CGFloat = 110/207 * halfScreenWidth
        static let positionYRight2: CGFloat = 95.5/207 * halfScreenWidth
        
        static let positionXLeft3: CGFloat = -65/207 * halfScreenWidth
        static let positionYLeft3: CGFloat = -115.5/207 * halfScreenWidth
        static let positionXRight3: CGFloat = 65/207 * halfScreenWidth
        static let positionYRight3: CGFloat = -115.5/207 * halfScreenWidth
        
        static let positionXLeft4: CGFloat = -148/207 * halfScreenWidth
        static let positionYLeft4: CGFloat = 95.5/207 * halfScreenWidth
        static let positionXRight4: CGFloat = 148/207 * halfScreenWidth
        static let positionYRight4: CGFloat = 95.5/207 * halfScreenWidth
        
        static let positionXLeft5: CGFloat = -150/207 * halfScreenWidth
        static let positionYLeft5: CGFloat = 137.5/207 * halfScreenWidth
        static let positionXRight5: CGFloat = 150/207 * halfScreenWidth
        static let positionYRight5: CGFloat = 137.5/207 * halfScreenWidth
    }
    
    // MARK:- Variables
    
    private var image: String = "missions"
    private var imageView = UIImageView()
    private var leftSensors: [UIView] = []
    private var rightSensors: [UIView] = []
    
    // MARK:- Sensors
    
    private lazy var right0: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    private lazy var right1: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    private lazy var right2: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    private lazy var right3: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    private lazy var right4: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    private lazy var right5: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    private lazy var left0: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    private lazy var left1: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    private lazy var left2: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    private lazy var left3: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    private lazy var left4: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    private lazy var left5: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        
        return view
    }()
    
    // MARK:- Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- View did load methods
    
    private func commonInit() {
        self.addSubviews()
        self.applyConstraints()
        
        leftSensors = [left0, left1, left2, left3, left4, left5]
        rightSensors = [right0, right1, right2, right3, right4, right5]
    }
    
    func addSubviews() {
        self.imageView.image = UIImage(named: image)
        
        self.addSubview(imageView)
        
        self.addSubview(left0)
        self.addSubview(left1)
        self.addSubview(left2)
        self.addSubview(left3)
        self.addSubview(left4)
        self.addSubview(left5)
        
        self.addSubview(right0)
        self.addSubview(right1)
        self.addSubview(right2)
        self.addSubview(right3)
        self.addSubview(right4)
        self.addSubview(right5)
    }
    
    func applyConstraints() {
        imageView.pin(to: self)
        NSLayoutConstraint.activate([
            self.left0.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: Constant.positionXLeft0),
            self.left0.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: Constant.positionYLeft0),
            self.left0.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: Constant.sensor),
            self.left0.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: Constant.sensor),
            
            self.left1.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: Constant.positionXLeft1),
            self.left1.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: Constant.positionYLeft1),
            self.left1.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: Constant.sensor),
            self.left1.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: Constant.sensor),
            
            self.left2.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: Constant.positionXLeft2),
            self.left2.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: Constant.positionYLeft2),
            self.left2.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: Constant.sensor),
            self.left2.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: Constant.sensor),
            
            self.left3.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: Constant.positionXLeft3),
            self.left3.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: Constant.positionYLeft3),
            self.left3.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: Constant.sensor),
            self.left3.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: Constant.sensor),
            
            self.left4.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: Constant.positionXLeft4),
            self.left4.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: Constant.positionYLeft4),
            self.left4.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: Constant.sensor),
            self.left4.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: Constant.sensor),
            
            self.left5.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: Constant.positionXLeft5),
            self.left5.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: Constant.positionYLeft5),
            self.left5.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: Constant.sensor),
            self.left5.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: Constant.sensor),
            
            self.right0.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: Constant.positionXRight0),
            self.right0.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: Constant.positionYRight0),
            self.right0.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: Constant.sensor),
            self.right0.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: Constant.sensor),
            
            self.right1.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: Constant.positionXRight1),
            self.right1.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: Constant.positionYRight1),
            self.right1.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: Constant.sensor),
            self.right1.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: Constant.sensor),
            
            self.right2.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: Constant.positionXRight2),
            self.right2.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: Constant.positionYRight2),
            self.right2.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: Constant.sensor),
            self.right2.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: Constant.sensor),
            
            self.right3.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: Constant.positionXRight3),
            self.right3.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: Constant.positionYRight3),
            self.right3.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: Constant.sensor),
            self.right3.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: Constant.sensor),
            
            self.right4.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: Constant.positionXRight4),
            self.right4.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: Constant.positionYRight4),
            self.right4.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: Constant.sensor),
            self.right4.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: Constant.sensor),
            
            self.right5.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: Constant.positionXRight5),
            self.right5.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: Constant.positionYRight5),
            self.right5.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: Constant.sensor),
            self.right5.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: Constant.sensor),
        ])
    }
    
    // MARK:- Sensor update methods
    func updateSensors(side: BLEDeviceSide, values: [Int]) {
        switch side {
        case .left:
            for (i, sensor) in self.leftSensors.enumerated() {
                sensor.backgroundColor = UIColor.green.withAlphaComponent(CGFloat(values[i])/4500)
            }
        case .right:
            for (i, sensor) in self.rightSensors.enumerated() {
                sensor.backgroundColor = UIColor.green.withAlphaComponent(CGFloat(values[i])/4500)
            }
        }
    }
}

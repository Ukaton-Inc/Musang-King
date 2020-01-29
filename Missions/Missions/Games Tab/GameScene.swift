//
//  GameScene.swift
//  Missions
//
//  Created by Elina Lua Ming on 1/15/20.
//  Copyright © 2020 Elina Lua Ming. All rights reserved.
//

import UIKit
import SpriteKit

enum Radius: CGFloat {
    case single = 15.0
}

enum CategoryMask: UInt32 {
    case ball = 0b01
    case food = 0b10
}

enum Layer: CGFloat {
    case ball = 100
}

enum ScoreNotification: String {
    case single = "single"
    
    var notification: Notification.Name {
        return Notification.Name(self.rawValue)
    }
}

class GameScene: SKScene {
        
    private var destX : CGFloat = -100
    private var destY : CGFloat = 500
    
    private var minX: CGFloat?
    private var minY: CGFloat?
    private var maxX: CGFloat?
    private var maxY: CGFloat?
        
    private let ballNode: SKShapeNode = {
        let ballNode = SKShapeNode(circleOfRadius: Radius.single.rawValue)
        ballNode.fillColor = UIColor(red:0.80, green:0.42, blue:0.90, alpha:1.0)
        ballNode.physicsBody = SKPhysicsBody(circleOfRadius: Radius.single.rawValue)
        ballNode.physicsBody?.allowsRotation = true
        ballNode.physicsBody?.restitution = 1
        ballNode.zPosition = Layer.ball.rawValue
        ballNode.physicsBody?.mass = 1.0
        
        return ballNode
    }()
    
    private let foodNode: SKShapeNode = {
        let foodNode = SKShapeNode(rect: CGRect(x: -15.0, y: -15.0, width: 30.0, height: 30.0), cornerRadius: 10.0)
        foodNode.fillColor = .systemRed
        foodNode.position = CGPoint(x: -80, y: 80)
        foodNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 30.0, height: 30.0))
        foodNode.zPosition = Layer.ball.rawValue
        foodNode.physicsBody?.mass = 0.5
        
        return foodNode
    }()
    
    private lazy var horizontalLine: SKShapeNode = {
        var horizontalLine = SKShapeNode()
        var pathToDraw = CGMutablePath()
        pathToDraw.move(to: CGPoint(x: -500, y: 0.0))
        pathToDraw.addLine(to: CGPoint(x: 500, y: 0.0))
        horizontalLine.path = pathToDraw
        horizontalLine.strokeColor = SKColor.white
        horizontalLine.lineWidth = 5
        horizontalLine.isHidden = false
        
        return horizontalLine
    }()
    
    private lazy var verticalLine: SKShapeNode = {
        var verticalLine = SKShapeNode()
        var pathToDraw = CGMutablePath()
        pathToDraw.move(to: CGPoint(x: 0, y: 500))
        pathToDraw.addLine(to: CGPoint(x: 0, y: -500))
        verticalLine.path = pathToDraw
        verticalLine.strokeColor = SKColor.white
        verticalLine.lineWidth = 5
        
        return verticalLine
    }()
        
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        addObservers()
        setupScene()
        addChildren()
        setupCategoryMasks()
        setupCollisionMasks()
        setupContactTestBitMasks()
    }

}

extension GameScene {
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateDestXY(_:)), name: BallPosition.single.notification, object: nil)
    }
    
    func getSceneRangeValues() {
        minX = (-self.frame.width / 2) + Radius.single.rawValue
        maxX = (self.frame.width / 2) - Radius.single.rawValue
        minY = -self.frame.height / 2 + Radius.single.rawValue
        maxY = self.frame.height / 2 - Radius.single.rawValue
    }
    
    @objc func updateDestXY(_ notification: Notification) {
        if let xVector = notification.userInfo?["horizontalConstant"] as? CGFloat, let yVector = notification.userInfo?["verticalConstant"] as? CGFloat {
            destX = xVector
            destY = yVector
        }
    }
    
    func setupCategoryMasks() {
        ballNode.physicsBody?.categoryBitMask = CategoryMask.ball.rawValue
        foodNode.physicsBody?.categoryBitMask = CategoryMask.food.rawValue
    }
    
    func setupCollisionMasks() {
        ballNode.physicsBody?.collisionBitMask = CategoryMask.food.rawValue
        foodNode.physicsBody?.collisionBitMask = CategoryMask.ball.rawValue
    }
    
    func setupContactTestBitMasks() {
        ballNode.physicsBody?.contactTestBitMask = CategoryMask.food.rawValue
        foodNode.physicsBody?.contactTestBitMask = ~(CategoryMask.ball.rawValue)
    }
    
    func setupScene() {
        self.scaleMode = .resizeFill
        self.backgroundColor = UIColor(white: 0.9, alpha: 1)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -0.0)
    }
    
    func addChildren() {
        self.addChild(horizontalLine)
        self.addChild(verticalLine)
        self.addChild(ballNode)
        self.addChild(foodNode)
    }
    
    func clamp(_ value: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
        if value > max {
            return max
        }
        if value < min {
            return min
        }
        return value
    }
    
    override func update(_ currentTime: TimeInterval) {
        updateBallNodePosition()
    }
    
    
    
    func updateBallNodePosition() {
        let minX = (-self.frame.width / 2) + Radius.single.rawValue
        let maxX = (self.frame.width / 2) - Radius.single.rawValue
        let minY = -self.frame.height / 2 + Radius.single.rawValue
        let maxY = self.frame.height / 2 - Radius.single.rawValue
        
        destX = clamp(destX, min: minX, max: maxX)
        destY = clamp(destY, min: minY, max: maxY)
        
        let destXAction = SKAction.moveTo(x: destX, duration: 1.0)
        let destYAction = SKAction.moveTo(y: destY, duration: 1.0)
        self.ballNode.run(destXAction)
        self.ballNode.run(destYAction)
    }
    
    @objc func setDestXY(x: CGFloat, y: CGFloat) {
        self.destX = x
        self.destY = y
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
    }

    func didEnd(_ contact: SKPhysicsContact) {
        // remove foodNode
        self.removeChildren(in: [foodNode])
        
        // update scoreboard in BalanceGameViewController
        NotificationCenter.default.post(name: ScoreNotification.single.notification, object: nil)
        
        // add foodNode again, position foodNode within range
        let minX = (-self.frame.width / 2) + Radius.single.rawValue
        let maxX = (self.frame.width / 2) - Radius.single.rawValue
        let minY = -self.frame.height / 2 + Radius.single.rawValue
        let maxY = self.frame.height / 2 - Radius.single.rawValue
        
        let newPosition = CGPoint(x: CGFloat.random(in: minX..<maxX), y: CGFloat.random(in: minY..<maxY))
        foodNode.position = newPosition
        
        self.addChild(foodNode)
    }
    
}

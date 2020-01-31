//
//  BalanceGameViewController.swift
//  Missions
//
//  Created by Umar Qattan on 12/23/19.
//  Copyright © 2019 Umar Qattan. All rights reserved.
//

import UIKit
import SceneKit

enum OldGameType: Int {
    case single
    case double
    case none
    
    var title: String {
        switch self {
        case .single:
            return "Single"
        case .double:
            return "Double"
        case .none:
            return "None"
        }
    }
}

class OldBalanceGameViewController: UIViewController {

    private var gameType: GameType = .none
    private var missionsView = MissionsView()
    private var updater: CADisplayLink! = nil
    private var playbackState: PlaybackState = .pause
    private var leftValues: [Int] = [Int](repeating: 0, count: 6)
    private var rightValues: [Int] = [Int](repeating: 0, count: 6)
    private var leftBallTopAnchorConstraint = NSLayoutConstraint()
    private var leftBallLeadingAnchorConstraint = NSLayoutConstraint()
    private var rightBallTopAnchorConstraint = NSLayoutConstraint()
    private var rightBallTrailingAnchorConstraint = NSLayoutConstraint()
    private var singleBallTopAnchorConstraint = NSLayoutConstraint()
    private var singleBallLeadingAnchorConstraint = NSLayoutConstraint()
    
    private lazy var soundSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.isContinuous = false
        
        return slider
    }()
    
    private lazy var scoreView: UIView = {
        let scoreView = UIView(frame: .zero)
        scoreView.backgroundColor = .white
        scoreView.translatesAutoresizingMaskIntoConstraints = false
        
        return scoreView
    }()
    
    
    private lazy var scoreViewLabel: UILabel = {
        let scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = "Score :"
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        
        return scoreLabel
    }()
    
    private lazy var scoreLabel: UILabel = {
        let scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = "0"
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        
        return scoreLabel
    }()
    
    private lazy var insolesView: UIView = {
        let topView = UIView(frame: .zero)
        topView.backgroundColor = .white
        topView.translatesAutoresizingMaskIntoConstraints = false
        
        return topView
    }()
    
    private lazy var gameView: UIView = {
        let middleView = UIView(frame: .zero)
        middleView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        middleView.translatesAutoresizingMaskIntoConstraints = false
        
        return middleView
    }()
    
    private lazy var horizontalCrossHair: UIView = {
        let horizontalCrossHair = UIView(frame: .zero)
        horizontalCrossHair.backgroundColor = .white
        horizontalCrossHair.translatesAutoresizingMaskIntoConstraints = false
        horizontalCrossHair.isHidden = true
        
        return horizontalCrossHair
    }()
    
    private lazy var verticalCrossHair: UIView = {
        let verticalCrossHair = UIView(frame: .zero)
        verticalCrossHair.backgroundColor = .white
        verticalCrossHair.translatesAutoresizingMaskIntoConstraints = false
        
        return verticalCrossHair
    }()
    
    private lazy var leftBall: UIView = {
        let leftBall = UIView(frame: .zero)
        leftBall.backgroundColor = UIColor(red:0.32, green:0.44, blue:1.00, alpha:1.0)
        leftBall.translatesAutoresizingMaskIntoConstraints = false
        leftBall.clipsToBounds = true
        
        return leftBall
    }()
    
    private lazy var rightBall: UIView = {
        let rightBall = UIView(frame: .zero)
        rightBall.backgroundColor = UIColor(red:1.00, green:0.34, blue:0.34, alpha:1.0)
        rightBall.translatesAutoresizingMaskIntoConstraints = false
        rightBall.clipsToBounds = true
        
        return rightBall
    }()
    
    private lazy var singleBall: UIView = {
        let singleBall = UIView(frame: .zero)
        singleBall.backgroundColor = UIColor(red:0.80, green:0.42, blue:0.90, alpha:1.0)
        singleBall.translatesAutoresizingMaskIntoConstraints = false
        singleBall.clipsToBounds = true
        singleBall.isHidden = true
        
        return singleBall
    }()
    
    private lazy var audioPlayerView: UIView = {
        let audioPlayerView = UIView(frame: .zero)
        audioPlayerView.translatesAutoresizingMaskIntoConstraints = false
        
        return audioPlayerView
    }()
    
    private lazy var controllerView: UIView = {
        let controllerView = UIView(frame: .zero)
        controllerView.translatesAutoresizingMaskIntoConstraints = false
        
        return controllerView
    }()
    
    private lazy var playButton: UIButton = {
        let playButton = UIButton(frame: .zero)
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        
        return playButton
    }()
    
    private lazy var forwardButton: UIButton = {
        let forwardButton = UIButton(frame: .zero)
        forwardButton.setImage(UIImage(systemName: "forward.end.fill"), for: .normal)
        forwardButton.translatesAutoresizingMaskIntoConstraints = false
        
        return forwardButton
    }()
    
    private lazy var backwardButton: UIButton = {
        let backwardButton = UIButton(frame: .zero)
        backwardButton.setImage(UIImage(systemName: "backward.end.fill"), for: .normal)
        backwardButton.translatesAutoresizingMaskIntoConstraints = false
        
        return backwardButton
    }()
    
    convenience init(gameType: GameType) {
        self.init(nibName:nil, bundle:nil)
        
        self.gameType = gameType
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
     }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // or see Roman Sausarnes's answer
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.applyConstraints()
        self.setupControlButtons()
        self.addObservers()
        self.setupGame()
    }
    
    private func setupControlButtons() {
        self.soundSlider.addTarget(self, action: #selector(handleTouchUp), for: [.touchUpInside, .touchUpOutside])
        self.soundSlider.addTarget(self, action: #selector(handleTouchDown), for: [.touchDown])
        self.soundSlider.addTarget(self, action: #selector(onSoundChanged(_:)), for: [.valueChanged])

        self.playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        self.backwardButton.addTarget(self, action: #selector(backwardTap), for: .touchUpInside)
        self.forwardButton.addTarget(self, action: #selector(forwardTap), for: .touchUpInside)
    }
    
    private func setupViews() {
        self.view.backgroundColor = .white
        self.navigationItem.title = self.gameType.title
                
        // view
        self.view.addSubview(self.scoreView)
        self.view.addSubview(self.insolesView)
        self.view.addSubview(self.gameView)
        self.view.addSubview(self.audioPlayerView)
        
        // score view
        self.scoreView.addSubview(scoreViewLabel)
        self.scoreView.addSubview(scoreLabel)
        
        // game view
        self.gameView.addSubview(self.horizontalCrossHair)
        self.gameView.addSubview(self.verticalCrossHair)
        
        self.gameView.addSubview(self.leftBall)
        self.gameView.addSubview(self.rightBall)
        self.gameView.addSubview(self.singleBall)
        
        // insoles view
        self.insolesView.addSubview(missionsView)

        // audio controller view
        self.audioPlayerView.addSubview(soundSlider)
        self.audioPlayerView.addSubview(controllerView)
        
        self.controllerView.addSubview(playButton)
        self.controllerView.addSubview(backwardButton)
        self.controllerView.addSubview(forwardButton)
    }
    
    private func applyConstraints() {
        let layoutMarginGuide = view.layoutMarginsGuide

        self.leftBallTopAnchorConstraint = self.leftBall.topAnchor.constraint(equalTo: self.gameView.topAnchor)
        self.leftBallLeadingAnchorConstraint = self.leftBall.leadingAnchor.constraint(equalTo: self.gameView.leadingAnchor)
        
        self.rightBallTopAnchorConstraint = self.rightBall.topAnchor.constraint(equalTo: self.gameView.topAnchor)
        self.rightBallTrailingAnchorConstraint = self.rightBall.trailingAnchor.constraint(equalTo: self.gameView.trailingAnchor)
        
        self.singleBallTopAnchorConstraint = self.singleBall.topAnchor.constraint(equalTo: self.gameView.topAnchor)
        self.singleBallLeadingAnchorConstraint = self.singleBall.leadingAnchor.constraint(equalTo: self.gameView.leadingAnchor)
        
        NSLayoutConstraint.activate([
            // score view
            self.scoreView.topAnchor.constraint(equalTo: layoutMarginGuide.topAnchor),
            self.scoreView.leadingAnchor.constraint(equalTo: layoutMarginGuide.leadingAnchor),
            self.scoreView.trailingAnchor.constraint(equalTo: layoutMarginGuide.trailingAnchor),
            self.scoreView.heightAnchor.constraint(equalTo: self.scoreView.widthAnchor, multiplier: 1 / 8),
            
            self.scoreViewLabel.centerYAnchor.constraint(equalTo: self.scoreView.centerYAnchor),
            self.scoreViewLabel.leadingAnchor.constraint(equalTo: self.scoreView.leadingAnchor),
            
            self.scoreLabel.centerYAnchor.constraint(equalTo: self.scoreView.centerYAnchor),
            self.scoreLabel.trailingAnchor.constraint(equalTo: self.scoreView.trailingAnchor),

            // game view
            self.gameView.topAnchor.constraint(equalTo: self.scoreView.bottomAnchor, constant: 10),
            self.gameView.trailingAnchor.constraint(equalTo: layoutMarginGuide.trailingAnchor),
            self.gameView.leadingAnchor.constraint(equalTo: layoutMarginGuide.leadingAnchor),
            self.gameView.heightAnchor.constraint(equalTo: gameView.widthAnchor, multiplier: 3 / 4),
            
            // insoles view
            self.insolesView.topAnchor.constraint(equalTo: self.gameView.bottomAnchor, constant: 20),
            self.insolesView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.insolesView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.insolesView.heightAnchor.constraint(equalTo: self.insolesView.widthAnchor, multiplier: 3 / 4),
                    
            // cross hairs
            self.horizontalCrossHair.widthAnchor.constraint(equalTo: self.gameView.widthAnchor),
            self.horizontalCrossHair.heightAnchor.constraint(equalToConstant: 5),
            self.verticalCrossHair.widthAnchor.constraint(equalToConstant: 5),
            self.verticalCrossHair.heightAnchor.constraint(equalTo: self.gameView.heightAnchor),
            self.horizontalCrossHair.centerYAnchor.constraint(equalTo: self.gameView.centerYAnchor),
            self.verticalCrossHair.centerXAnchor.constraint(equalTo: self.gameView.centerXAnchor),
            
            // left ball
            self.leftBall.heightAnchor.constraint(equalToConstant: 50),
            self.leftBall.widthAnchor.constraint(equalToConstant: 50),
            self.leftBallTopAnchorConstraint,
            self.leftBallLeadingAnchorConstraint,
            
            // right ball
            self.rightBall.heightAnchor.constraint(equalToConstant: 50),
            self.rightBall.widthAnchor.constraint(equalToConstant: 50),
            self.rightBallTopAnchorConstraint,
            self.rightBallTrailingAnchorConstraint,
            
            // single ball
           self.singleBall.heightAnchor.constraint(equalToConstant: 25),
           self.singleBall.widthAnchor.constraint(equalToConstant: 25),
           self.singleBallTopAnchorConstraint,
           self.singleBallLeadingAnchorConstraint,
            
            // audio player view
            self.audioPlayerView.topAnchor.constraint(equalTo: self.insolesView.bottomAnchor),
            self.audioPlayerView.leadingAnchor.constraint(equalTo: layoutMarginGuide.leadingAnchor),
            self.audioPlayerView.trailingAnchor.constraint(equalTo: layoutMarginGuide.trailingAnchor),
            self.audioPlayerView.bottomAnchor.constraint(equalTo: layoutMarginGuide.bottomAnchor),
            
            // sound slider
            self.soundSlider.topAnchor.constraint(equalTo: self.audioPlayerView.topAnchor),
            self.soundSlider.leadingAnchor.constraint(equalTo: audioPlayerView.leadingAnchor),
            self.soundSlider.trailingAnchor.constraint(equalTo: audioPlayerView.trailingAnchor),
            self.soundSlider.heightAnchor.constraint(equalTo: self.audioPlayerView.heightAnchor, multiplier: 1/3),
            
            // controller view
            self.controllerView.topAnchor.constraint(equalTo: self.soundSlider.bottomAnchor),
            self.controllerView.leadingAnchor.constraint(equalTo: audioPlayerView.leadingAnchor),
            self.controllerView.trailingAnchor.constraint(equalTo: audioPlayerView.trailingAnchor),
            self.controllerView.bottomAnchor.constraint(equalTo: self.audioPlayerView.bottomAnchor),
            
            // play button
            self.playButton.centerXAnchor.constraint(equalTo: self.controllerView.centerXAnchor),
            self.playButton.centerYAnchor.constraint(equalTo: self.controllerView.centerYAnchor),
            self.playButton.heightAnchor.constraint(equalTo: self.controllerView.heightAnchor, multiplier: 1/2),
            self.playButton.widthAnchor.constraint(equalTo: self.controllerView.heightAnchor),
            
            // backward button
            self.backwardButton.centerYAnchor.constraint(equalTo: self.controllerView.centerYAnchor),
            self.backwardButton.trailingAnchor.constraint(equalTo: self.playButton.leadingAnchor, constant: self.controllerView.frame.width / 6),
            self.backwardButton.heightAnchor.constraint(equalTo: self.controllerView.heightAnchor, multiplier: 1/2),
            self.backwardButton.widthAnchor.constraint(equalTo: self.controllerView.heightAnchor),
            
            // forward button
            self.forwardButton.centerYAnchor.constraint(equalTo: self.controllerView.centerYAnchor),
            self.forwardButton.leadingAnchor.constraint(equalTo: self.playButton.trailingAnchor, constant: self.controllerView.frame.width / 6),
            self.forwardButton.heightAnchor.constraint(equalTo: self.controllerView.heightAnchor, multiplier: 1/2),
            self.forwardButton.widthAnchor.constraint(equalTo: self.controllerView.heightAnchor)
        ])
        
        missionsView.pin(to: insolesView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // set corner radii of balls
        self.leftBall.layer.cornerRadius = self.leftBall.frame.width / 2
        self.rightBall.layer.cornerRadius = self.rightBall.frame.width / 2
        self.singleBall.layer.cornerRadius = self.singleBall.frame.width / 2

        // set constraint constants of each ball after `viewDidLayoutSubviews()`
        self.leftBallLeadingAnchorConstraint.constant = self.gameView.frame.width / 4 - self.leftBall.frame.width / 2
        self.leftBallTopAnchorConstraint.constant = self.gameView.frame.height - self.leftBall.frame.height
        
        self.rightBallTrailingAnchorConstraint.constant = -(self.gameView.frame.width / 4 - self.rightBall.frame.width / 2)
        self.rightBallTopAnchorConstraint.constant = self.gameView.frame.height - self.rightBall.frame.height
        
        self.singleBallLeadingAnchorConstraint.constant = self.gameView.frame.width / 2 - self.singleBall.frame.width / 2
        self.singleBallTopAnchorConstraint.constant = self.gameView.frame.height / 2 - self.singleBall.frame.height / 2
        
        self.gameView.clipsToBounds = true
        self.gameView.layer.cornerRadius = 10
    }
}

extension OldBalanceGameViewController {
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateLeft(_:)), name: NSNotification.Name(rawValue: BLEDeviceSide.left.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateRight(_:)), name: NSNotification.Name(rawValue: BLEDeviceSide.right.rawValue), object: nil)
    }
    
    @objc func updateLeft(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let values = userInfo["values"] as? [Int]
        else { return }
        
        self.leftValues = values
        self.missionsView.updateSensors(side: .left, values: self.leftValues)
        self.updateValuesFromMissions(left: self.leftValues, right: self.rightValues)
    }
    
    @objc func updateRight(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let values = userInfo["values"] as? [Int]
        else { return }
        
        self.rightValues = values
        self.missionsView.updateSensors(side: .right, values: self.rightValues)
        self.updateValuesFromMissions(left: self.leftValues, right: self.rightValues)
    }
    
    func updateValuesFromMissions(left: [Int], right: [Int]) {
        DispatchQueue.main.async {
            [weak self] in
            guard let `self` = self else { return }
            
            let (leftHorizontalConstant, leftVerticalConstant) = self.getTranslation(.left)
            let (rightHorizontalConstant, rightVerticalConstant) = self.getTranslation(.right)
            let (horizontalConstant, verticalConstant) = self.getTranslation(.single)
            let (panHorizontalConstant, volumeVerticalConstant) = self.getTranslation(.none)
            
            AudioPlayback.shared.setPanValue(Float(panHorizontalConstant))
            AudioPlayback.shared.setVolumeValue(Float(powf(Float(panHorizontalConstant), 1.5)))
            print("Volume: \(Float(volumeVerticalConstant))")
            print("Pan: \(Float(panHorizontalConstant))")
            switch self.gameType {
            case .single:
                self.singleBallTopAnchorConstraint.constant = verticalConstant
                self.singleBallLeadingAnchorConstraint.constant = horizontalConstant
            case .double:
                // left ball constraint constant update
                self.leftBallTopAnchorConstraint.constant = leftVerticalConstant
                self.leftBallLeadingAnchorConstraint.constant = leftHorizontalConstant
                
                // right ball constraint constant update
                self.rightBallTopAnchorConstraint.constant = rightVerticalConstant
                self.rightBallTrailingAnchorConstraint.constant = -rightHorizontalConstant
            case .none:
                break
            }
        }
    }

    /// A helper to get the translation values for horizontal and vertical constraint constants for either left or right balls
    /// - Parameters:
    ///   - view: the ball that needs to update
    private func getTranslation(_ view: Ball) -> (CGFloat, CGFloat) {
        let topSensors = [0, 1, 3]
        let bottomSensors = [2, 4, 5]
        
        let leftSensors = [1, 4, 5]
        let rightSensors = [3, 2]
        
        var topSum: Int = 0
        var bottomSum: Int = 0
        var leftSum: Int = 0
        var rightSum: Int = 0
        
        var leftBottomSum: Int = 0
        var leftTopSum: Int = 0
        var rightBottomSum: Int = 0
        var rightTopSum: Int = 0
        
        var leftLeftSum: Int = 0
        var leftRightSum: Int = 0
        var rightLeftSum: Int = 0
        var rightRightSum: Int = 0
        
        for lValue in leftValues {
            leftSum += lValue
        }
        
        for rValue in rightValues {
            rightSum += rValue
        }
        
        for i in 0..<topSensors.count {
            leftTopSum += self.leftValues[topSensors[i]]
            rightTopSum += self.rightValues[topSensors[i]]
            
            topSum += self.leftValues[topSensors[i]]
            topSum += self.rightValues[topSensors[i]]
        }
        
        for i in 0..<bottomSensors.count {
            leftBottomSum += self.leftValues[bottomSensors[i]]
            rightBottomSum += self.rightValues[bottomSensors[i]]
            
            bottomSum += self.leftValues[bottomSensors[i]]
            bottomSum += self.rightValues[bottomSensors[i]]
        }
        
        for i in 0..<leftSensors.count {
            leftLeftSum += self.leftValues[leftSensors[i]]
            rightLeftSum += self.rightValues[leftSensors[i]]
        }
        
        for i in 0..<rightSensors.count {
            leftRightSum += self.leftValues[rightSensors[i]]
            rightRightSum += self.rightValues[rightSensors[i]]
        }
              
        var verticalConstant: CGFloat
        var horizontalConstant: CGFloat
        
        switch view {
        case .left:
            horizontalConstant = map(
                minRange: -7000,
                maxRange: 7000,
                minDomain: 0,
                maxDomain: self.gameView.frame.width / 2 - self.leftBall.frame.width,
                value: CGFloat(leftRightSum - leftLeftSum)
            )
            verticalConstant = map(
                minRange: -7000,
                maxRange: 7000,
                minDomain: 0,
                maxDomain: self.gameView.frame.height - self.leftBall.frame.height,
                value: CGFloat(leftBottomSum - leftTopSum)
            )
        case .right:
            horizontalConstant = map(
                minRange: -7000,
                maxRange: 7000,
                minDomain: 0,
                maxDomain: self.gameView.frame.width / 2 - self.rightBall.frame.width,
                value: CGFloat(rightRightSum - rightLeftSum)
            )
            verticalConstant = map(
                minRange: -7000,
                maxRange: 7000,
                minDomain: 0,
                maxDomain: self.gameView.frame.height - self.rightBall.frame.height,
                value: CGFloat(rightBottomSum - rightTopSum)
            )
        case .single:
            horizontalConstant = map(
                minRange: -14000,
                maxRange: 14000,
                minDomain: 0,
                maxDomain: self.gameView.frame.width - self.singleBall.frame.width,
                value: CGFloat(rightSum - leftSum + 3500)
            )
            verticalConstant = map(
                minRange: -14000,
                maxRange: 14000,
                minDomain: 0,
                maxDomain: self.gameView.frame.height - self.singleBall.frame.height,
                value: CGFloat((rightBottomSum + leftBottomSum) - (rightTopSum + leftTopSum))
            )
        case .none:
            horizontalConstant = map(
                minRange: 0,
                maxRange: 14000,
                minDomain: 0,
                maxDomain: 0.5,
                value: CGFloat(abs(rightSum - leftSum + 3500))
            )
            verticalConstant = map(
                minRange: 0,
                maxRange: 14000,
                minDomain: 0,
                maxDomain: 0.5,
                value: CGFloat(abs(rightSum - leftSum))
            )
        }
        
        return (horizontalConstant, verticalConstant)
    }
    
    
    func setupGame() {
        switch self.gameType {
        case .single:
            self.singleBall.isHidden = false
            self.leftBall.isHidden = true
            self.rightBall.isHidden = true
            self.horizontalCrossHair.isHidden = false
        case .double:
            self.singleBall.isHidden = true
            self.leftBall.isHidden = false
            self.rightBall.isHidden = false
            self.horizontalCrossHair.isHidden = true
        case .none:
            break
        }
    }
    
    @objc func handleTouchUp() {
        self.updateRunLoop()
    }
    
    @objc func handleTouchDown() {
        if updater != nil {
            updater.invalidate()
            updater = nil
        }
    }
    
    func updateRunLoop() {
        if updater == nil {
            updater = CADisplayLink(target: self, selector: #selector(trackAudio(_:)))
            updater.preferredFramesPerSecond = 10
            updater.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
        }
    }
    
    @objc func trackAudio(_ displayLink: CADisplayLink) {
       let normalizedTime = Float(AudioPlayback.shared.audioPlayer.currentTime * 1 / AudioPlayback.shared.audioPlayer.duration)
       self.soundSlider.setValue(normalizedTime, animated: true)
       
//       let currentTime = Int(floor(AudioPlayback.shared.audioPlayer.currentTime))
//       let timeTaken: String = String(currentTime / 60) + ":" +  String(format: "%02d", currentTime % 60)
//
//       let timeLeft_ = Int(floor(AudioPlayback.shared.audioPlayer.duration - AudioPlayback.shared.audioPlayer.currentTime))
//       let timeLeft: String = String( timeLeft_ / 60) + ":" + String(format: "%02d", timeLeft_ % 60)
       
//       countUpLabel.text = timeTaken
//       countDownLabel.text = "-" + timeLeft
//
//       if countDownLabel.text == "-0:00" &&
//           self.playbackState == .play {
//           self.playbackState = self.playbackState.toggle
//           self.playButton.setImage(self.playbackState.image, for: .normal)
//       }
   }
    
    @objc func playButtonTapped(_ sender: UIButton) {
        if AudioPlayback.shared.audioPlayer.currentTime == AudioPlayback.shared.audioPlayer.duration {
            AudioPlayback.shared.audioPlayer.currentTime = 0.00
        } else {
            self.playbackState = self.playbackState.toggle
            self.playButton.setImage(self.playbackState.image, for: .normal)
            self.updateRunLoop()
        }
        
        AudioPlayback.shared.play(pan: 0.5, volume: 0.0)
    }
    
    @objc func backwardTap(_ sender: UIButton) {
           if playbackState == .play {
               AudioPlayback.shared.skipToStart()
           } else {
               AudioPlayback.shared.audioPlayer.currentTime = 0.0
           }
       }
       
    @objc func forwardTap(_ sender: UIButton) {
           // skip to end
           if playbackState == .play {
               self.playbackState = .pause
               self.playButton.setImage(self.playbackState.image, for: .normal)
           }
           
           AudioPlayback.shared.skipToEnd()
       }
    
    @objc func onSoundChanged(_ sender: UISlider) {
        AudioPlayback.shared.audioPlayer.pause()
        
        let currentTime = Double(sender.value) * AudioPlayback.shared.audioPlayer.duration
        AudioPlayback.shared.audioPlayer.currentTime = currentTime
        
        if playbackState == .play {
            AudioPlayback.shared.audioPlayer.play()
        }
        
        self.updateRunLoop()
    }
}


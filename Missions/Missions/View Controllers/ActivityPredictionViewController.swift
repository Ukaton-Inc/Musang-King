//
//  ActivityPredictionViewController.swift
//  Missions
//
//  Created by Elina Lua Ming on 12/23/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit

class ActivityPredictionViewController: UIViewController {

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
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(frame: .zero)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.insertSegment(withTitle: "1 Ball", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "2 Balls", at: 1, animated: true)
        segmentedControl.apportionsSegmentWidthsByContent = true
        segmentedControl.selectedSegmentIndex = 1
        
        return segmentedControl
    }()
    
    private lazy var soundSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.isContinuous = false
        
        return slider
    }()
    
    private lazy var topView: UIView = {
        let topView = UIView(frame: .zero)
        topView.backgroundColor = .white
        topView.translatesAutoresizingMaskIntoConstraints = false
        
        return topView
    }()
    
    private lazy var middleView: UIView = {
        let middleView = UIView(frame: .zero)
        middleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        middleView.translatesAutoresizingMaskIntoConstraints = false
        
        return middleView
    }()
    
    private lazy var horizontalCrossHair: UIView = {
        let horizontalCrossHair = UIView(frame: .zero)
        horizontalCrossHair.backgroundColor = UIColor.darkGray
        horizontalCrossHair.translatesAutoresizingMaskIntoConstraints = false
        horizontalCrossHair.isHidden = true
        
        return horizontalCrossHair
    }()
    
    private lazy var verticalCrossHair: UIView = {
        let verticalCrossHair = UIView(frame: .zero)
        verticalCrossHair.backgroundColor = UIColor.darkGray
        verticalCrossHair.translatesAutoresizingMaskIntoConstraints = false
        
        return verticalCrossHair
    }()
    
    private lazy var leftBall: UIView = {
        let leftBall = UIView(frame: .zero)
        leftBall.backgroundColor = UIColor.blue
        leftBall.translatesAutoresizingMaskIntoConstraints = false
        leftBall.clipsToBounds = true
        
        return leftBall
    }()
    
    private lazy var rightBall: UIView = {
        let rightBall = UIView(frame: .zero)
        rightBall.backgroundColor = UIColor.red
        rightBall.translatesAutoresizingMaskIntoConstraints = false
        rightBall.clipsToBounds = true
        
        return rightBall
    }()
    
    private lazy var singleBall: UIView = {
        let singleBall = UIView(frame: .zero)
        singleBall.backgroundColor = UIColor.purple
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.applyConstraints()
        self.setupControlButtons()
        self.addObservers()
    }
    
    private func setupControlButtons() {
        self.soundSlider.addTarget(self, action: #selector(handleTouchUp), for: [.touchUpInside, .touchUpOutside])
        self.soundSlider.addTarget(self, action: #selector(handleTouchDown), for: [.touchDown])
        self.soundSlider.addTarget(self, action: #selector(onSoundChanged(_:)), for: [.valueChanged])

        self.playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        self.backwardButton.addTarget(self, action: #selector(backwardTap), for: .touchUpInside)
        self.forwardButton.addTarget(self, action: #selector(forwardTap), for: .touchUpInside)
        
        self.segmentedControl.addTarget(self, action: #selector(didUpdateSegmentedControl(_:)), for: .valueChanged)
    }
    
    private func setupViews() {
        self.view.backgroundColor = .white
        self.topView.addSubview(missionsView)
        self.topView.addSubview(self.segmentedControl)

        self.audioPlayerView.addSubview(soundSlider)
        self.audioPlayerView.addSubview(controllerView)
        
        self.controllerView.addSubview(playButton)
        self.controllerView.addSubview(backwardButton)
        self.controllerView.addSubview(forwardButton)
        
        self.view.addSubview(self.topView)
        self.view.addSubview(self.middleView)
        self.view.addSubview(self.audioPlayerView)
        
        self.middleView.addSubview(self.leftBall)
        self.middleView.addSubview(self.rightBall)
        self.middleView.addSubview(self.singleBall)
        self.middleView.addSubview(self.horizontalCrossHair)
        self.middleView.addSubview(self.verticalCrossHair)
    }
    
    private func applyConstraints() {
        let layoutMarginGuide = view.layoutMarginsGuide

        self.leftBallTopAnchorConstraint = self.leftBall.topAnchor.constraint(equalTo: self.middleView.topAnchor)
        self.leftBallLeadingAnchorConstraint = self.leftBall.leadingAnchor.constraint(equalTo: self.middleView.leadingAnchor)
        
        self.rightBallTopAnchorConstraint = self.rightBall.topAnchor.constraint(equalTo: self.middleView.topAnchor)
        self.rightBallTrailingAnchorConstraint = self.rightBall.trailingAnchor.constraint(equalTo: self.middleView.trailingAnchor)
        
        self.singleBallTopAnchorConstraint = self.singleBall.topAnchor.constraint(equalTo: self.middleView.topAnchor)
        self.singleBallLeadingAnchorConstraint = self.singleBall.leadingAnchor.constraint(equalTo: self.middleView.leadingAnchor)
        
        NSLayoutConstraint.activate([
            // top view
            self.topView.topAnchor.constraint(equalTo: layoutMarginGuide.topAnchor, constant: 20),
            self.topView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.topView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.topView.heightAnchor.constraint(equalTo: self.view.widthAnchor),
                    
            // segmented control
            self.segmentedControl.bottomAnchor.constraint(equalTo: self.topView.bottomAnchor),
            self.segmentedControl.centerXAnchor.constraint(equalTo: self.topView.centerXAnchor),
            
            // middle view
            self.middleView.topAnchor.constraint(equalTo: self.topView.bottomAnchor, constant: 10),
            self.middleView.trailingAnchor.constraint(equalTo: layoutMarginGuide.trailingAnchor),
            self.middleView.leadingAnchor.constraint(equalTo: layoutMarginGuide.leadingAnchor),
            self.middleView.heightAnchor.constraint(equalTo: layoutMarginGuide.heightAnchor, multiplier: 1/4),
            
            // cross hairs
            self.horizontalCrossHair.widthAnchor.constraint(equalTo: self.middleView.widthAnchor),
            self.horizontalCrossHair.heightAnchor.constraint(equalToConstant: 1),
            self.verticalCrossHair.widthAnchor.constraint(equalToConstant: 1),
            self.verticalCrossHair.heightAnchor.constraint(equalTo: self.middleView.heightAnchor),
            self.horizontalCrossHair.centerYAnchor.constraint(equalTo: self.middleView.centerYAnchor),
            self.verticalCrossHair.centerXAnchor.constraint(equalTo: self.middleView.centerXAnchor),
            
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
            self.audioPlayerView.topAnchor.constraint(equalTo: self.middleView.bottomAnchor),
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
        
        missionsView.pin(to: topView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // set corner radii of balls
        self.leftBall.layer.cornerRadius = self.leftBall.frame.width / 2
        self.rightBall.layer.cornerRadius = self.rightBall.frame.width / 2
        self.singleBall.layer.cornerRadius = self.singleBall.frame.width / 2

        // set constraint constants of each ball after `viewDidLayoutSubviews()`
        self.leftBallLeadingAnchorConstraint.constant = self.middleView.frame.width / 4 - self.leftBall.frame.width / 2
        self.leftBallTopAnchorConstraint.constant = self.middleView.frame.height - self.leftBall.frame.height
        
        self.rightBallTrailingAnchorConstraint.constant = -(self.middleView.frame.width / 4 - self.rightBall.frame.width / 2)
        self.rightBallTopAnchorConstraint.constant = self.middleView.frame.height - self.rightBall.frame.height
        
        self.singleBallLeadingAnchorConstraint.constant = self.middleView.frame.width / 2 - self.singleBall.frame.width / 2
        self.singleBallTopAnchorConstraint.constant = self.middleView.frame.height / 2 - self.singleBall.frame.height / 2
        
        self.middleView.clipsToBounds = true
        self.middleView.layer.cornerRadius = 10
        self.middleView.layer.borderColor = UIColor.darkGray.cgColor
        self.middleView.layer.borderWidth = 0.5
    }
}

extension ActivityPredictionViewController {
    
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
            
            switch self.segmentedControl.selectedSegmentIndex {
            case 0:
                self.singleBallTopAnchorConstraint.constant = verticalConstant
                self.singleBallLeadingAnchorConstraint.constant = horizontalConstant
            case 1:
                // left ball constraint constant update
                self.leftBallTopAnchorConstraint.constant = leftVerticalConstant
                self.leftBallLeadingAnchorConstraint.constant = leftHorizontalConstant
                
                // right ball constraint constant update
                self.rightBallTopAnchorConstraint.constant = rightVerticalConstant
                self.rightBallTrailingAnchorConstraint.constant = -rightHorizontalConstant
            default:
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
                maxDomain: self.middleView.frame.width / 2 - self.leftBall.frame.width,
                value: CGFloat(leftRightSum - leftLeftSum)
            )
            verticalConstant = map(
                minRange: -7000,
                maxRange: 7000,
                minDomain: 0,
                maxDomain: self.middleView.frame.height - self.leftBall.frame.height,
                value: CGFloat(leftBottomSum - leftTopSum)
            )
        case .right:
            horizontalConstant = map(
                minRange: -7000,
                maxRange: 7000,
                minDomain: 0,
                maxDomain: self.middleView.frame.width / 2 - self.rightBall.frame.width,
                value: CGFloat(rightRightSum - rightLeftSum)
            )
            verticalConstant = map(
                minRange: -7000,
                maxRange: 7000,
                minDomain: 0,
                maxDomain: self.middleView.frame.height - self.rightBall.frame.height,
                value: CGFloat(rightBottomSum - rightTopSum)
            )
        case .single:
            horizontalConstant = map(
                minRange: -7000,
                maxRange: 7000,
                minDomain: 0,
                maxDomain: self.middleView.frame.width / 2 - self.rightBall.frame.width,
                value: CGFloat(rightSum - leftSum)
            )
            verticalConstant = map(
                minRange: -7000,
                maxRange: 7000,
                minDomain: 0,
                maxDomain: self.middleView.frame.height - self.rightBall.frame.height,
                value: CGFloat((rightBottomSum + leftBottomSum) - (rightTopSum + leftTopSum))
            )
        }
        
        return (horizontalConstant, verticalConstant)
    }
    
    @objc func didUpdateSegmentedControl(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.singleBall.isHidden = false
            self.leftBall.isHidden = true
            self.rightBall.isHidden = true
            
            self.horizontalCrossHair.isHidden = false
        case 1:
            self.singleBall.isHidden = true
            self.leftBall.isHidden = false
            self.rightBall.isHidden = false
            self.horizontalCrossHair.isHidden = true
        default: break
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
        
        AudioPlayback.shared.play(pan: 0.5)
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

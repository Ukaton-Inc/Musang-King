//
//  DashboardViewController.swift
//  Missions
//
//  Created by Elina Lua Ming on 12/23/19.
//  Copyright © 2019 Elina Lua Ming. All rights reserved.
//

import UIKit

@available (iOS 13, *)
class DashboardViewController: UIViewController {
    
    private lazy var missionsView = MissionsView()
    private lazy var appDelegate = UIApplication.shared.delegate as? AppDelegate
    private var sessionState: SessionState = .stop
    private var playbackState: PlaybackState = .pause
    private var timer: Timer!
    private var sessions: [Session] = []
    private var currentSession: Session!
    private var currentSensors: [Sensor] = []
    private var currentTimes: [Date] = []
    private var currentStances: [String] = []
    private var currentActivities: [String] = []
    private var currentValues: [Float] = []
    private var currentActivity: Activity = .stand
    private var currentStance: Stance = .neutral
    private var currentlySelectedIndexPath: IndexPath?
    private var cellModels: [RecordingTableViewCellModel] = []
    
    private var leftValues: [Int] = []
    private var rightValues: [Int] = []
    
    private lazy var stanceSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = -1
        slider.maximumValue = 1
        slider.value = 0
        return slider
    }()
    
    private lazy var stanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Neutral"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var recordButton: UIImageView = {
        let recordButton = UIImageView()
        recordButton.image = UIImage(systemName: "circle.fill")
        recordButton.tintColor = .systemRed
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.isUserInteractionEnabled = true
        
        return recordButton
    }()
    
    private lazy var testButton: UIBarButtonItem = {
        let testButton = UIBarButtonItem(title: "Test", style: .plain, target: self, action: #selector(self.didTapTestButton(_:)))

        return testButton
    }()
    
    private lazy var actionButton: UIBarButtonItem = {
        let actionButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.didTapActionButton(_:)))
        
        return actionButton
    }()
    
    private lazy var settingsButton: UIBarButtonItem = {
        let settingsButton = UIBarButtonItem(image: UIImage(named: AssetConstants.settings), style: .plain, target: self, action: #selector(self.didTapSettingsButton(_:)))
        
        return settingsButton
    }()
    
    private lazy var topView: UIView = {
        let topView = UIView(frame: .zero)
        topView.backgroundColor = .white
        topView.translatesAutoresizingMaskIntoConstraints = false
        
        return topView
    }()
    
    private lazy var middleView: UIView = {
        let middleView = UIView(frame: .zero)
//        middleView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        middleView.translatesAutoresizingMaskIntoConstraints = false
        
        return middleView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.estimatedRowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RecordingTableViewCell.self, forCellReuseIdentifier: "recordingCell")
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavBar()
        self.setupViews()
        self.applyConstraints()
        self.addObservers()
    }
    
}

//  MARK:- viewDidLoad functions
extension DashboardViewController {
    
    func setupNavBar() {
        self.title = "Missions"
        self.navigationItem.rightBarButtonItems = [actionButton, testButton]
        self.navigationItem.leftBarButtonItem = settingsButton
    }
    
    func setupViews() {
        self.view.backgroundColor = .white
        self.topView.addSubview(missionsView)
        self.middleView.addSubview(stanceLabel)
        self.middleView.addSubview(stanceSlider)
        self.middleView.addSubview(recordButton)
        
        self.view.addSubview(topView)
        self.view.addSubview(middleView)
        self.view.addSubview(tableView)
        
        createTapGestureForRecordButton()
        stanceSlider.addTarget(self, action: #selector(onStanceChanged(_:)), for: .valueChanged)
    }
    
    func applyConstraints() {
        let layoutMarginGuide = view.layoutMarginsGuide

        NSLayoutConstraint.activate([
            self.topView.topAnchor.constraint(equalTo: layoutMarginGuide.topAnchor, constant: 20),
            self.topView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.topView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.topView.heightAnchor.constraint(equalTo: self.view.widthAnchor),
            
            self.middleView.topAnchor.constraint(equalTo: self.topView.bottomAnchor, constant: 10),
            self.middleView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.middleView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.middleView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/6),
            
            self.tableView.topAnchor.constraint(equalTo: self.middleView.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: layoutMarginGuide.bottomAnchor),
            
            self.stanceLabel.centerXAnchor.constraint(equalTo: self.middleView.centerXAnchor),
            self.stanceLabel.topAnchor.constraint(equalTo: self.middleView.topAnchor),

            self.stanceSlider.topAnchor.constraint(equalTo: self.stanceLabel.bottomAnchor, constant: 10),
            self.stanceSlider.leadingAnchor.constraint(equalTo: layoutMarginGuide.leadingAnchor),
            self.stanceSlider.trailingAnchor.constraint(equalTo: layoutMarginGuide.trailingAnchor),
            self.stanceSlider.heightAnchor.constraint(equalTo: self.middleView.heightAnchor, multiplier: 1/3),
            
            self.recordButton.centerXAnchor.constraint(equalTo: middleView.centerXAnchor),
            self.recordButton.bottomAnchor.constraint(equalTo: middleView.bottomAnchor),
            self.recordButton.heightAnchor.constraint(equalTo: self.middleView.heightAnchor, multiplier: 1/3),
            self.recordButton.widthAnchor.constraint(equalTo: self.recordButton.heightAnchor)
        ])
        
        missionsView.pin(to: topView)
    }
    
}

//  MARK:- navBar buttons functions

 @objc extension DashboardViewController {
    
    func didTapTestButton(_ sender: UIBarButtonItem) {
        self.navigationController?.pushViewController(BalanceGameViewController(gameType: .none), animated: true)
    }
    
    func didTapActionButton(_ sender: UIBarButtonItem) {
        let fileURL = Disk.getURL(for: .documents)
        let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)

        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func didTapSettingsButton(_ sender: UIBarButtonItem) {
        self.present(SetupDeviceTableViewController(),animated: true, completion: nil)
    }
    
}

extension DashboardViewController {
    
    func createTapGestureForRecordButton() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapRecordButton(_:)))
        tap.numberOfTapsRequired = 1
        recordButton.addGestureRecognizer(tap)
    }
    
    @objc func didTapRecordButton(_ sender: UIView) {
        self.sessionState = self.sessionState.toggle
        self.recordButton.image = self.sessionState.image
        
        if self.sessionState == .record {
            self.stanceSlider.isEnabled = false
        }
        
        if self.sessionState == .stop {
            self.saveNewSession()
            self.tableView.reloadData()
            self.stanceSlider.isEnabled = true
        }
    }
    
    func saveNewSession() {
        self.currentSession = Session(sensors: self.currentSensors, times: self.currentTimes, stances: self.currentStances, activities: self.currentActivities, values: self.currentValues)
        self.sessions.append(self.currentSession)
        self.appDelegate?.saveSessions(self.sessions)
        self.currentSensors = []
        self.currentTimes = []
        self.currentStances = []
        self.currentActivities = []
        self.currentValues = []
        self.cellModels = self.getCellModels()
        print("this is cell modesl count: \(cellModels.count)")
    }
    
    @objc func onStanceChanged(_ sender: UISlider) {
        self.currentStance = Stance.stanceForValue(sender.value)
        self.stanceLabel.text = self.currentStance.stanceLabelString
        sender.setValue(self.currentStance.valueForStance, animated: false)
    }
    
    func addObservers() {
            NotificationCenter.default.addObserver(self, selector: #selector(update(_:)), name: NSNotification.Name(rawValue: BLEDeviceSide.left.rawValue), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(update(_:)), name: NSNotification.Name(rawValue: BLEDeviceSide.right.rawValue), object: nil)
    }
    
    @objc func update(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let values = userInfo["values"] as? [Int]
        else { return }
        
        switch notification.name.rawValue {
        case BLEDeviceSide.left.rawValue:
            self.missionsView.updateSensors(side: .left, values: values)
            self.leftValues = values
        case BLEDeviceSide.right.rawValue:
            self.missionsView.updateSensors(side: .right, values: values)
            self.rightValues = values
        default: break
        }
        
        if self.sessionState == .record {
            let (sensor, time, stance, activity, value) = self.getSessionData(leftValues: self.leftValues, rightValues: self.rightValues)
            self.currentSensors.append(sensor)
            self.currentTimes.append(time)
            self.currentStances.append(stance)
            self.currentActivities.append(activity)
            self.currentValues.append(value)
        }
    }
    
    func getSessionData(leftValues: [Int], rightValues: [Int]) -> (Sensor, Date, String, String, Float) {
        guard leftValues.count == 6, rightValues.count == 6 else {
            let time = Date.getTime()
            return (
                Sensor(values: [Int](repeating: 0, count: 12)),
                time,
                self.currentStance.stanceString,
                self.currentActivity.activityString,
                0
            )
        }
        
        var extendedValues = leftValues
        extendedValues.append(contentsOf: rightValues)
        let sensor = Sensor(values: extendedValues)
        let time = Date.getTime()
        let stance = self.currentStance.stanceString
        let activity = self.currentActivity.activityString
        let value = self.currentStance.valueForStance
        
        return (sensor, time, stance, activity, value)
    }
    
    func getSessions() -> [Session]? {
        return self.appDelegate?.retrieveSessions()
    }
    
    func saveSessions() {
        
    }
    
    func getCellModels() -> [RecordingTableViewCellModel] {
        var cellModels = [RecordingTableViewCellModel]()
        for (i, session) in self.sessions.enumerated() {
            cellModels.append(
                RecordingTableViewCellModel(
                    title: "Session \(i)",
                    date: session.timeCreated(),
                    time: session.duration().toTime(),
                    description: "\(session.activities.first?.capitalized ?? "Stand") \(Stance.stanceFromString(session.stances.first ?? "neutral").stanceLabelString)"
                )
            )
        }
        
        return cellModels
    }
    
}

//  MARK:- tableView delegate and data source functions

extension DashboardViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordingCell") as! RecordingTableViewCell
        print(self.cellModels[indexPath.row])
        cell.bind(with: self.cellModels[indexPath.row])
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

}

extension DashboardViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.sessions.remove(at: indexPath.row)
            self.cellModels.remove(at: indexPath.row)
            self.appDelegate?.clearFile(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath != self.currentlySelectedIndexPath else {
            self.currentlySelectedIndexPath = nil
            self.enableToolBar(false)
            return
        }
        
        self.currentlySelectedIndexPath = indexPath
        self.enableToolBar(true)
        print(self.sessions[indexPath.row].description())
    }
    
    func enableToolBar(_ enable: Bool) {
//        if !enable {
//            self.playbackState = .pause
//
//            self.playButton.image = self.playbackState.image
//        }
//        self.playButton.isEnabled = enable
//        self.forwardButton.isEnabled = enable
//        self.backwardButton.isEnabled = enable
    }
    
}



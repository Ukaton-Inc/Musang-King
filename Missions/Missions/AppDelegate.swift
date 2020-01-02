//
//  AppDelegate.swift
//  Missions
//
//  Created by Umar Qattan on 12/23/19.
//  Copyright © 2019 Umar Qattan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var ble = BLE()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

extension AppDelegate {
    
    func getJSON(from resource: String) -> String? {
        if let path = Bundle.main.path(forResource: resource, ofType: "csv") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return String(data: data, encoding: .utf8)
              } catch {
                return nil
                   // handle error
              }
        } else {
            return nil
        }
        
    }
    
    func storeSessions() {
        for i in 0..<19 {
            let resource = "session\(i)"
            if let json = self.getJSON(from: resource) {
                let csv = CSwiftV(with: json)
                if let keyedRows = csv.keyedRows {
                    let session: Session = Session(rows: keyedRows)
                    Disk.store(session, to: .documents, as: "\(resource).json")
                    print(session.description())
                }
            }
        }
    }
    
    func saveSessions(_ sessions: [Session]) {
        for (i, session) in sessions.enumerated() {
            let resource = "session\(i).json"
            Disk.store(session, to: .documents, as: resource)
            print(session.description())
        }
    }
    
    func retrieveSessions() -> [Session] {
        var sessions: [Session] = []
        for i in 0..<5 {
            let resource = "session\(i).json"
            if Disk.fileExists(resource, in: .documents) {
                let session = Disk.retrieve(resource, from: .documents, as: Session.self)
                sessions.append(session)
                print(session.description())
            } else {
                continue
            }
        }
        return sessions
    }
    
    func clearFile(at index: Int) {
        let fileName = "session\(index).json"
        Disk.remove(fileName, from: .documents)
    }
    
    func delay(_ delay: Double, closure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + delay, execute: closure)
    }
    
}




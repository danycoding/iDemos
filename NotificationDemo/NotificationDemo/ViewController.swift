//
//  ViewController.swift
//  NotificationDemo
//
//  Created by DanyChen on 19/11/15.
//  Copyright © 2015 DanyChen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Tool.registerForNotification()
        scheduleLocalNotification()
    }
    
    func scheduleLocalNotification() {
        let localNotification = UILocalNotification()
        localNotification.fireDate = NSDate().dateByAddingTimeInterval(5)
        localNotification.alertBody = "Hey, you must go shopping, remember?"
        localNotification.alertAction = "View List"
        localNotification.category = "ACTIONABLE"
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


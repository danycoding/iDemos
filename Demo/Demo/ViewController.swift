//
//  ViewController.swift
//  Demo
//
//  Created by DanyChen on 1/12/15.
//  Copyright © 2015 DanyChen. All rights reserved.
//

import UIKit

class User : NSObject {
    
    var id : NSNumber?
    var name : String?
    var avatar : String?
}

func timeCost(function : () -> (), times : Int) -> String {
    let start = NSDate().timeIntervalSince1970
    for _ in 0..<times{
        function()
    }
    return ("cost = \(NSDate().timeIntervalSince1970 - start)")
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let u = User()
        let table = TableWith("user", type: User.self, primaryKey: "id", dbName: "user")
        table.save(u)
        print(timeCost({ () -> () in
//            let value = u.valueForKey("name") as? String?  0.84
//            if let v = value {
//                v.debugDescription
//            }
            
//            u.name?.debugDescription  0.084
            
//                u.setValue("ssss", forKey: "name")   0.84
//            u.name = "ssss"         0.089
            }, times: 1000000))
//        u.name = "fadf2"
//        u.avatar = "adfs2"
//        u.setValue("fdafsdf", forKey: "name")
//        u.id = NSNumber(int: 3)
//        print ( "success = \(tableWith(User.self).save(u))" )
//        
//        
//        let users = tableWith(User.self).queryAll()
//        for user in users {
//            print(user.name! + " " + user.avatar!)
//            if user.id != nil {
//                print(user.id!.description)
//            }else {
//                print("nil ")
//            }
//        }
//        Tool.test()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


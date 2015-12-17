//
//  ViewController.swift
//  Demo
//
//  Created by DanyChen on 1/12/15.
//  Copyright © 2015 DanyChen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let u = User()
        tableWith(User.self).save(u)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


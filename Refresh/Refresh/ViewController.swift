//
//  ViewController.swift
//  Refresh
//
//  Created by Yolanda Yeh on 3/25/15.
//  Copyright (c) 2015 Refresh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var currentStatus: UILabel!
    
    
    @IBOutlet weak var availableButton: UIButton!
    @IBOutlet weak var unavailableButton: UIButton!
    
    @IBAction func clickedAvailableButton(sender: AnyObject) {
        currentStatus.text = "Available"
        var serveruser = ServerUser(yourContactInfo: yourContactInformation, serverConnection: true)
        serveruser.changeStatus(0)
    }

    @IBAction func clickedUnavailableButton(sender: AnyObject) {
        currentStatus.text = "Unavailable"
        var serveruser = ServerUser(yourContactInfo: yourContactInformation, serverConnection: true)
        serveruser.changeStatus(2)
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

}


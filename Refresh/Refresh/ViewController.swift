//
//  ViewController.swift
//  Refresh
//
//  Created by Yolanda Yeh on 3/25/15.
//  Copyright (c) 2015 Refresh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var currentState: UILabel!
    @IBAction func notavailableButton(sender: AnyObject) {
        currentState.text = sender.currentTitle!
        var mainUser = Contacts()
        mainUser.firstName = "Main"
        mainUser.lastName = "User"
        mainUser.callFrequency = 4
        mainUser.lastCallDate = "03/01/2015"
        mainUser.lastCallInfo = "Testing 1"
        mainUser.specialDates = "null"
        mainUser.status = 2
        mainUser.phoneNumber = "6099378865"
        
        var serveruser = ServerUser(yourContactInfo: mainUser, serverConnection: true)
         serveruser.changeStatus(0)
    }
    
    @IBAction func availableButton(sender: UIButton) {
        currentState.text = sender.currentTitle!
        var mainUser = Contacts()
        mainUser.firstName = "Main"
        mainUser.lastName = "User"
        mainUser.callFrequency = 4
        mainUser.lastCallDate = "03/01/2015"
        mainUser.lastCallInfo = "Testing 1"
        mainUser.specialDates = "null"
        mainUser.status = 2
        mainUser.phoneNumber = "6099378865"
        
        var serveruser = ServerUser(yourContactInfo: mainUser, serverConnection: true)
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


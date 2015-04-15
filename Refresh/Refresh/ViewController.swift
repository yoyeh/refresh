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
        var serveruser = ServerUser(yourContactInfo: yourContactInformation, serverConnection: true)
         serveruser.changeStatus(0)
    }
    
    @IBAction func availableButton(sender: UIButton) {
        currentState.text = sender.currentTitle!
        
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


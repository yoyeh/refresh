//
//  ViewController.swift
//  Refresh
//
//  Created by Yolanda Yeh on 3/25/15.
//  Copyright (c) 2015 Refresh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var amountAvailable: UIPickerView!
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var unavailableButton: UIButton!
    
    private var defaults = NSUserDefaults.standardUserDefaults()
    private var startTime = NSTimeInterval()
    private var theTimer = NSTimer()
    private var totalTime : Double = 0
    private var pickerData = ["15 Minutes", "30 Minutes", "45 Minutes", "1 Hour", "A Long Time"]

    // the unavailable button
    @IBAction func clickedUnavailableButton(sender: AnyObject) {
        theTimer.invalidate()
        timer.text = "I am available for:"
        var serveruser = ServerUser(phoneNumber: defaults.stringForKey("mainUserPhoneNumber")!, serverConnection: true)
        serveruser.changeStatus(0)
        
        unavailableButton.hidden = true
        goButton.hidden = false
        amountAvailable.hidden = false
    }
    
    // the button for the availability timer
    @IBAction func startTimer(sender: AnyObject) {
        theTimer.invalidate()
        
        var serveruser = ServerUser(phoneNumber: defaults.stringForKey("mainUserPhoneNumber")!, serverConnection: true)
        serveruser.changeStatus(2)

        if amountAvailable.selectedRowInComponent(0) == 0 {
            totalTime = 15
            // totalTime = 900
        }
        else if amountAvailable.selectedRowInComponent(0) == 1 {
            totalTime = 30
            // totalTime = 1800
        }
        else if amountAvailable.selectedRowInComponent(0) == 2 {
            totalTime = 45
            //totalTime = 2700
        }
        else if amountAvailable.selectedRowInComponent(0) == 3 {
            totalTime = 60
            // totalTime = 3600
        }
        else {
            timer.text = "Available"
            theTimer.invalidate()
        }
        
        if timer.text != "Available" {
            let aSelector : Selector = "updateTime"
            theTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate()
        }
        
        amountAvailable.hidden = true
        goButton.hidden = true
        unavailableButton.hidden = false
    }
    
    // update and print the amount of time left for the availability timer
    func updateTime() {
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        // Find the difference between current time and start time.
        var elapsedTime = currentTime - startTime
        var timeLeft : NSTimeInterval
        timeLeft = totalTime - elapsedTime
        
        if timeLeft <= 0 {
            theTimer.invalidate()
            timer.text = "I am available for:"
            amountAvailable.hidden = false
            goButton.hidden = false
            unavailableButton.hidden = true
            
            var serveruser = ServerUser(phoneNumber: defaults.stringForKey("mainUserPhoneNumber")!, serverConnection: true)
            serveruser.changeStatus(0)
        }
        else {
            // calculate the minutes in elapsed time.
            let minutes = UInt8(timeLeft / 60.0)
            timeLeft -= (NSTimeInterval(minutes) * 60)
        
            // calculate the seconds in elapsed time.
            let seconds = UInt8(timeLeft)
            timeLeft -= NSTimeInterval(seconds)
        
            // add the leading zero for minutes and seconds and store them as string constants
            let strMinutes = minutes > 9 ? String(minutes):"0" + String(minutes)
            let strSeconds = seconds > 9 ? String(seconds):"0" + String(seconds)
        
            timer.text = "\(strMinutes):\(strSeconds)"
        }
    }
    
    // load once, the first time
    override func viewDidLoad() {
        super.viewDidLoad()
        self.amountAvailable.dataSource = self
        self.amountAvailable.delegate = self
        // Do any additional setup after loading the view, typically from a nib
   }
    // necessary for the UIPickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // necessary for the UIPickerView
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // displays names in the picker view
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[row]
    }
}


//
//  ViewController.swift
//  Refresh
//
//  Created by Yolanda Yeh on 3/25/15.
//  Copyright (c) 2015 Refresh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var currentStatus: UILabel!
    @IBOutlet weak var availableButton: UIButton!
    @IBOutlet weak var unavailableButton: UIButton!
    
    @IBOutlet weak var amountAvailable: UIPickerView!
    @IBOutlet weak var timer: UILabel!
    
    private var startTime = NSTimeInterval()
    private var theTimer = NSTimer()
    private var totalTime : Double = 0
    
    @IBAction func clickedAvailableButton(sender: AnyObject) {
        currentStatus.text = "Available"
        theTimer.invalidate()
        timer.text = ""
        var serveruser = ServerUser(yourContactInfo: yourContactInformation, serverConnection: true)
        serveruser.changeStatus(0)
    }

    @IBAction func clickedUnavailableButton(sender: AnyObject) {
        currentStatus.text = "Unavailable"
        theTimer.invalidate()
        timer.text = ""
        var serveruser = ServerUser(yourContactInfo: yourContactInformation, serverConnection: true)
        serveruser.changeStatus(2)
    }
    
    @IBAction func startTimer(sender: AnyObject) {
        theTimer.invalidate()
        currentStatus.text = "Available for"
        var serveruser = ServerUser(yourContactInfo: yourContactInformation, serverConnection: true)
        serveruser.changeStatus(0)
        if amountAvailable.selectedRowInComponent(0) == 0 {
            timer.text = "15:00"
            totalTime = 900
        }
        else if amountAvailable.selectedRowInComponent(0) == 1 {
            timer.text = "30:00"
            totalTime = 1800
        }
        else if amountAvailable.selectedRowInComponent(0) == 2 {
            timer.text = "45:00"
            totalTime = 2700
        }
        else {
            timer.text = "60:00"
            totalTime = 3600
        }
        
        let aSelector : Selector = "updateTime"
        theTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
        startTime = NSDate.timeIntervalSinceReferenceDate()
        //println(amountAvailable.selectedRowInComponent(0))
        
    }
    
    func updateTime() {
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        //Find the difference between current time and start time.
        var elapsedTime = currentTime - startTime
        var timeLeft : NSTimeInterval
        
    
        timeLeft = totalTime - elapsedTime
        
        if timeLeft <= 0 {
            
            theTimer.invalidate()
            
            timer.text = ""
            currentStatus.text = "Unavailable"
            var serveruser = ServerUser(yourContactInfo: yourContactInformation, serverConnection: true)
            serveruser.changeStatus(2)
            return
            
        }
        
        //calculate the minutes in elapsed time.
        let minutes = UInt8(timeLeft / 60.0)
        timeLeft -= (NSTimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        let seconds = UInt8(timeLeft)
        timeLeft -= NSTimeInterval(seconds)
        
        
        //add the leading zero for minutes and seconds and store them as string constants
        let strMinutes = minutes > 9 ? String(minutes):"0" + String(minutes)
        let strSeconds = seconds > 9 ? String(seconds):"0" + String(seconds)
        
        timer.text = "\(strMinutes):\(strSeconds)"
        
    }
    
    let pickerData = ["15 Minutes", "30 Minutes", "45 Minutes", "1 Hour"]
    override func viewDidLoad() {
      super.viewDidLoad()
        timer.text = ""
        self.amountAvailable.dataSource = self
        self.amountAvailable.delegate = self
        // Do any additional setup after loading the view, typically from a nib
   }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[row]
    }
    
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

    private func timerSelectedView() {
        
    }
    
    private func timerNotSelectedView() {
        
    }
    
}


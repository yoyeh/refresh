//
//  SaveInfoController.swift
//  Refresh
//
//  Created by Malena de la Fuente on 4/26/15.
//  Copyright (c) 2015 Refresh. All rights reserved.
//

import Foundation
import UIKit

class SaveInfoController: UIViewController {
    
 
    @IBOutlet weak var callinfotext: UITextField!
    @IBOutlet weak var specialdate: UIDatePicker!
    @IBOutlet weak var yesButton: UIButton!
    
    var calltext : String = "hello"
    var contact : Contacts!
    var specialDate : NSDate!
    
    @IBAction func showDatePicker(sender: UIButton) {
        yesButton.hidden = true
        specialdate.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentDate: NSDate = NSDate()
        specialdate.datePickerMode = UIDatePickerMode.Date
        specialdate.minimumDate = currentDate

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "saveContactInfo" {
            calltext = callinfotext.text
            specialDate = specialdate.date
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
        
        yesButton.hidden = false
        specialdate.hidden = true
    }
    
    // Hide keyboard when user taps anywhere outside keyboard
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
}

//
//  Contacts.swift
//  Refresh
//
//  Created by Yolanda Yeh on 4/1/15.
//  Copyright (c) 2015 Refresh. All rights reserved.
//

import Foundation

class Contacts {
    var firstName = "null"
    var lastName = "null"
    var callFrequency = 0
    var lastCallDate = "null"
    var lastCallInfo = "null"
    var specialDates = ""
    
    var status = 1 // status: [0] unavailable [1] unknown [2] available
    var phoneNumber = "null"
    
    var fullName:String {
        return "\(firstName) \(lastName)"
    }
    
    var contactDetails:String {
        var details = "Last Call\n\(lastCallDate)\n\(lastCallInfo)\n\n"
        details += "Special Dates\n\(specialDates)\n\n"

        return details
    }
    
    init(firstname: String, lastname: String, callfrequency: Int, lastcalldate: String, lastcallinfo: String, specialdates: String, Status: Int, phonenumber: String)
    {
        firstName = firstname
        lastName = lastname
        callFrequency = callfrequency
        lastCallDate = lastcalldate
        lastCallInfo = lastcallinfo
        specialDates = specialdates
        status = Status
        phoneNumber = phonenumber
        
    }
    
    init() {}
    
    func sortLastDate(contact : Contacts) -> Int
    {
        let dateformatter = NSDateFormatter()
        dateformatter.dateStyle = .ShortStyle
        dateformatter.timeStyle = .ShortStyle
        let date2 = dateformatter.dateFromString(contact.lastCallDate)
        println(date2)
        
        let last = date2?.timeIntervalSince1970
        let df2 = NSDateFormatter()
        df2.dateStyle = .ShortStyle
        df2.timeStyle = .ShortStyle
        let date3 = df2.stringFromDate(NSDate())
        let date4 = df2.dateFromString(date3)
        let current = date4?.timeIntervalSince1970
        
        let frequency = contact.callFrequency * 7
        var days : Int
        
        if contact.lastCallDate == "null"
        {
            days = 0
        }
        else
        {
            let timeElapsed = Int(current! - last!)
            days = frequency - timeElapsed/1440
        }
        println(days)
        return days
    }
    
    func removeOldDates(contact : Contacts) -> String
    {
        var dateformat = NSDateFormatter()
        dateformat.dateStyle = .ShortStyle
        dateformat.timeStyle = .ShortStyle
        var newDates : String = ""
        let allDates = contact.specialDates.componentsSeparatedByString("\n")
        for dateString in allDates
        {
           let date = dateformat.dateFromString(dateString)
            if date?.earlierDate(NSDate()) != date {
                println("yes")
                if newDates == "" {
                    newDates = dateString
                }
                else
                {
                    newDates = "\(newDates)\n\(dateString)"
                }
            }
            else { println("no")}
        }
        return newDates
    }
}
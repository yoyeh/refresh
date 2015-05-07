//
//  Contacts.swift
//  Refresh
//
//  Created by Yolanda Yeh on 4/1/15.
//  Copyright (c) 2015 Refresh. All rights reserved.
//

import Foundation

class Contacts {
    var firstName = ""
    var lastName = ""
    var callFrequency = 2
    var lastCallDate = ""
    var lastCallInfo = ""
    var specialDates = ""
    var activeSince = -1
    
    var status = 1 // status: [0] unavailable [1] unknown [2] available
    var phoneNumber = ""
    
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
    
    // sort the contacts by the last date they were called (for sorting in the Now view)
    func sortLastDate() -> Int
    {
        let dateformatter = NSDateFormatter()
        dateformatter.dateStyle = .ShortStyle
        //dateformatter.timeStyle = .ShortStyle
        let date2 = dateformatter.dateFromString(lastCallDate)
        //println(date2)
        
        let last = date2?.timeIntervalSince1970
        //println(last)
        let current = NSDate().timeIntervalSince1970
        //println(current)
        let frequency = callFrequency * 7
        var days : Int
        
        if lastCallDate == ""
        {
            days = 0
        }
        else
        {
            var dateformat = NSDateFormatter()
            dateformat.dateStyle = .ShortStyle
            //dateformat.timeStyle = .ShortStyle
            let calendar = NSCalendar.currentCalendar()
            if specialDates != "" {
            let allDates = specialDates.componentsSeparatedByString("\n")
            for dateString in allDates
            {
                let date = dateformat.dateFromString(dateString)
                
                if (calendar.isDate(date!, inSameDayAsDate: NSDate())) {
                    days = Int.min
                    return days
                }
            }
            }
            let timeElapsed = Int(current - last!)
            days = frequency - timeElapsed/86460
        }
        //println(days)
        return days
    }
    
    // remove dates that have already passed from the special dates part of the contact (don't remove days that are today)
    func removeOldDates() -> String
    {
        var dateformat = NSDateFormatter()
        dateformat.dateStyle = .ShortStyle
        //dateformat.timeStyle = .ShortStyle
        var newDates : String = ""
        let allDates = specialDates.componentsSeparatedByString("\n")
        for dateString in allDates
        {
            let date = dateformat.dateFromString(dateString)
            let otherdate = NSDate()
            let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
            let newDate = cal!.startOfDayForDate(otherdate)
            //println(newDate)
            if date != nil && (newDate.earlierDate(date!) != date || newDate.isEqualToDate(date!)) {
                //println("yes")
                if newDates == "" {
                    newDates = dateString
                }
                else
                {
                    newDates = "\(newDates)\n\(dateString)"
                }
            }
           // else { println("no")}
        }
        return newDates
    }
}
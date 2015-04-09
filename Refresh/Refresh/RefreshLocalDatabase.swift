//
//  RefreshLocalDatabase.swift
//  Refresh
//
//  Created by Yolanda Yeh on 4/8/15.
//  Copyright (c) 2015 Refresh. All rights reserved.
//

import Foundation

class LocalDatabase
{
    private var databasePath = NSString()
    
    func initializeDatabase()
    {
        // creating path to database
        let filemgr = NSFileManager.defaultManager()
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        let docsDir = dirPaths[0] as String
        // checking if database exists
        databasePath = docsDir.stringByAppendingPathComponent("contacts.db")
        
        // creating database if none exists
        if !filemgr.fileExistsAtPath(databasePath) {
            let contactDB = FMDatabase(path: databasePath)
            
            if contactDB == nil {
                println("Error: \(contactDB.lastErrorMessage())")
            }
            
            if contactDB.open() {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, PHONE TEXT, FREQUENCY INTEGER, LASTDATE TEXT, LASTINFO TEXT, SPECIALDATES TEXT, AVAILABLE TEXT)"
                
                if !contactDB.executeStatements(sql_stmt) {
                    println("Error: \(contactDB.lastErrorMessage())")
                }
                
                // close database
                contactDB.close()
            }
            else {
                println("Error: \(contactDB.lastErrorMessage())")
            }
        }
    }
    
    // Add a single new contact
    func addContact(name : NSString, phone : NSString)
    {
        let contactDB = FMDatabase(path: databasePath)
        
        var contact = Contacts()
        
        contact.callFrequency = 2
        
        if contactDB.open() {
            // insert contact into database
            let insertSQL = "INSERT INTO CONTACTS (name, phone, frequency, lastdate, lastinfo, specialdates, available) VALUES ('\(name)', '\(phone)', '\(contact.callFrequency)', '\(contact.lastCallDate)', '\(contact.lastCallInfo)', '\(contact.specialDates)', '\(contact.status)')"
            // check it was inserted
            let result = contactDB.executeUpdate(insertSQL, withArgumentsInArray: nil)
            
            if !result {
                println("Error: \(contactDB.lastErrorMessage())")
            }
        }
        
    }
    
    // Accesses a single contact using phone number
    func accessContact(phone : NSString)
    {
        let contactDB = FMDatabase(path : databasePath)
        
        if contactDB.open() {
            let querySQL = "SELECT name, frequency, lastdate, specialdates, lastinfo, available FROM CONTACTS WHERE phone = '\(phone)'"
            
            let results:FMResultSet? = contactDB.executeQuery(querySQL,
                withArgumentsInArray: nil)
            if results?.next() == true {
                println(results?.stringForColumn("name"))
                println(results?.stringForColumn("frequency"))
                println(results?.stringForColumn("lastdate"))
                println(results?.stringForColumn("specialdates"))
                println(results?.stringForColumn("lastinfo"))
                println(results?.stringForColumn("available"))
            }
            else {
                println("not found")
            }
            contactDB.close()
        }
        else {
            println("Error: \(contactDB.lastErrorMessage())")
        }
    }
    
    // Return list of all contacts
    
    // Delete contact
}
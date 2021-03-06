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
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        let docsDir = dirPaths[0] as! String
        // checking if database exists
        databasePath = docsDir.stringByAppendingPathComponent("contacts.db")
        
        // creating database if none exists
        if !filemgr.fileExistsAtPath(databasePath as String) {
            let contactDB = FMDatabase(path: databasePath as String)
            
            if contactDB == nil {
                println("Error: \(contactDB.lastErrorMessage())")
            }
            
            if contactDB.open() {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, FIRSTNAME TEXT, LASTNAME TEXT, PHONE TEXT, FREQUENCY INTEGER, LASTDATE TEXT, LASTINFO TEXT, SPECIALDATES TEXT, AVAILABLE INTEGER)"
                
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
    func addContact(contact: Contacts)
    {
        var firstname = contact.firstName
        var lastname = contact.lastName
        var phone = contact.phoneNumber
        let contactDB = FMDatabase(path: databasePath as String)
        
        if contactDB.open() {
            // insert contact into database
            if (!doesContactExist(contact)) {
            let insertSQL = "INSERT INTO CONTACTS (firstname, lastname, phone, frequency, lastdate, lastinfo, specialdates, available) VALUES ('\(firstname)', '\(lastname)', '\(phone)', '\(contact.callFrequency)', '\(contact.lastCallDate)', '\(contact.lastCallInfo)', '\(contact.specialDates)', '\(contact.status)')"
            // check it was inserted
            let result = contactDB.executeUpdate(insertSQL, withArgumentsInArray: nil)
            
            if !result {
                println("Custom Error: \(contactDB.lastErrorMessage())")
                }
                contactDB.close()
                return
                }
        }
            if (doesContactExist(contact)) {
                editContact(contact)
                return
            }
        println("Custom Error: \(contactDB.lastErrorMessage())")
        return
    }
    
    // Accesses a single contact
    func accessContact(contact: Contacts) -> Contacts?
    {
        var phoneNumber = contact.phoneNumber
        let contactDB = FMDatabase(path : databasePath as String)
        
        if contactDB.open() {
            let querySQL = "SELECT firstname, lastname, frequency, lastdate, specialdates, lastinfo, available FROM CONTACTS WHERE phone = '\(phoneNumber)'"
            let results:FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsInArray: nil)
            
            var resultContact = Contacts()
            
            if results?.next() == true {
                resultContact.phoneNumber = phoneNumber
                resultContact.firstName = results!.stringForColumn("firstname")
                resultContact.lastName = results!.stringForColumn("lastname")
                resultContact.callFrequency = results!.stringForColumn("frequency").toInt()!
                resultContact.lastCallDate = results!.stringForColumn("lastdate")
                resultContact.lastCallInfo = results!.stringForColumn("lastinfo")
                resultContact.specialDates = results!.stringForColumn("specialdates")
                //println(results?.stringForColumn("available"))
                
                contactDB.close()
                return resultContact
            }
            contactDB.close()
            println("not found")
            return nil
        }
        println("Custom Error: \(contactDB.lastErrorMessage())")
        return nil
    }
    
    // Return list of all contacts
    func returnContactList() -> [Contacts]?
    {
        var contactsArray:[Contacts] = []
        let contactDB = FMDatabase(path : databasePath as String)
        
        if contactDB.open() {
            let querySQL = "SELECT * FROM CONTACTS"
            let results:FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsInArray: nil)
            
            while results?.next() == true {
                var newContact = Contacts()
                
                newContact.phoneNumber = results!.stringForColumn("phone")
                newContact.firstName = results!.stringForColumn("firstname")
                newContact.lastName = results!.stringForColumn("lastname")
                newContact.callFrequency = results!.stringForColumn("frequency").toInt()!
                newContact.lastCallDate = results!.stringForColumn("lastdate")
                newContact.lastCallInfo = results!.stringForColumn("lastinfo")
                newContact.specialDates = results!.stringForColumn("specialdates")
                //println(results?.stringForColumn("available"))
                
                contactsArray.append(newContact)
            }
            contactDB.close()
            return contactsArray
        }

        println("Custom Error: \(contactDB.lastErrorMessage())")
        return nil
    }
    
    // Delete contact
    func deleteContact(contact : Contacts)
    {
        var phone = contact.phoneNumber
        let contactDB = FMDatabase(path : databasePath as String)
        
        if contactDB.open() {
            let querySQL = "DELETE FROM CONTACTS WHERE PHONE = '\(phone)'"
            let deleted = contactDB.executeUpdate(querySQL, withArgumentsInArray: nil)
            
            if (!deleted){
                println("Custom Error: \(contactDB.lastErrorMessage())")
            }
            contactDB.close()
            return
            
        }
        println("Custom Error: \(contactDB.lastErrorMessage())")
        return
    }
    
    
    
    // Edit contact
    func editContact(contact : Contacts) -> Contacts?
    {
        var phone = contact.phoneNumber
        let contactDB = FMDatabase(path : databasePath as String)
        let info = contact.lastCallInfo.stringByReplacingOccurrencesOfString("'", withString: "''")
        let first = contact.firstName.stringByReplacingOccurrencesOfString("'", withString: "''")
        let last = contact.lastName.stringByReplacingOccurrencesOfString("'", withString: "''")
        
        if contactDB.open() {
            let querySQL = "UPDATE CONTACTS SET firstname = '\(first)', lastname = '\(last)',  frequency = '\(contact.callFrequency)', lastdate = '\(contact.lastCallDate)', lastinfo = '\(info)', specialdates = '\(contact.specialDates)', available = '\(contact.status)' WHERE phone = '\(phone)'"
            let items = contactDB.executeUpdate(querySQL, withArgumentsInArray: nil)
            
            if items {
                contactDB.close()
                return contact
            }
            contactDB.close()
            return nil
        }
        println("Custom Error: \(contactDB.lastErrorMessage())")
        return nil
    }
    
    func doesContactExist(contact : Contacts)->Bool
    {
        var phone = contact.phoneNumber
        let contactDB = FMDatabase(path : databasePath as String)
        
        if contactDB.open() {
        let querySQL = "SELECT * FROM CONTACTS WHERE phone = '\(phone)'"
        let results:FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsInArray: nil)
            if results?.next() == true {
                contactDB.close()
                return true
            }
            contactDB.close()
            return false
        }
        println("Custom Error: \(contactDB.lastErrorMessage())")
        return false
        
    }
}
    

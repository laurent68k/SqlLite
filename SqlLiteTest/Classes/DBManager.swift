//
//  DBManager.swift
//  SqlLiteTest
//
//  Created by Laurent Favard on 26/01/2018.
//  Copyright © 2018 laurent68k . All rights reserved.
//

import Foundation
import SQLite3

class SQLDataBaseManager {
    
    private (set) static var sharedInstance = SQLDataBaseManager()
    private (set) var databaseName = ""
    
    private var dataBase: OpaquePointer? = nil
    
    private let deleteStatementString = "DELETE FROM Contact WHERE Id = ?;"
    private let updateStatementString = "UPDATE Contact SET Name = ? WHERE Id = ?;"
    private let queryStatementString = "SELECT * FROM Contact;"
    private let insertStatementString = "INSERT INTO Contact (Id, Name) VALUES (?, ?);"
    private let createTableString = """
                                    CREATE TABLE Contact(
                                                Id INT PRIMARY KEY NOT NULL,
                                                Name CHAR(255)
                                    );
                                    """

    private init() {
        
    }
    
    func openDatabase(forBasename name: String ) -> Bool {
        
        var db: OpaquePointer? = nil
        
        self.databaseName = name
        if sqlite3_open(self.databaseName, &db) == SQLITE_OK {
        
            print("Successfully opened connection to database at \(self.databaseName)")
            
            self.dataBase = db
            return true
        }
        else {
            
            print("Unable to open database. Verify that you created the directory described " +
                "in the Getting Started section.")
        }
        return false
    }
    
    func createTable() {
        
        var createTableStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.dataBase, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                
                print("Contact table created.")
            }
            else {
                print("Contact table could not be created.")
            }
        }
        else {
            print("CREATE TABLE statement could not be prepared.")
        }

        sqlite3_finalize(createTableStatement)
    }

    func insert(forKey:Int32, name:String) {
        
        var insertStatement: OpaquePointer? = nil
        
        // 1
        if sqlite3_prepare_v2(self.dataBase, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            let nsName : NSString = name as NSString
            
            // 2
            sqlite3_bind_int(insertStatement, 1, forKey)
            // 3
            sqlite3_bind_text(insertStatement, 2, nsName.utf8String, -1, nil)
            
            // 4
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        // 5
        sqlite3_finalize(insertStatement)
    }
    
    func select() {
     
        var queryStatement: OpaquePointer? = nil
        // 1
        if sqlite3_prepare_v2(self.dataBase, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
        
            // 2
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
            
                let id = sqlite3_column_int(queryStatement, 0)
                let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
                let name = String(cString: queryResultCol1!)
                print("Query Result:")
                print("\(id) | \(name)")
            }
            
        }
        else {
            print("SELECT statement could not be prepared")
        }
        
        // 6
        sqlite3_finalize(queryStatement)
    }
    
    func update(forKey:Int32, name:String) {
        var updateStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.dataBase, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
        
            let nsName : NSString = name as NSString
            
            sqlite3_bind_text(updateStatement, 1, nsName.utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 2, forKey)

            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            }
            else {
                print("Could not update row.")
            }
        }
        else {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
    func delete(key:Int32) {
        
        var deleteStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.dataBase, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_int(deleteStatement, 1, key)

            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            }
            else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        
        sqlite3_finalize(deleteStatement)
    }
}

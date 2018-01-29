//
//  ViewController.swift
//  SqlLiteTest
//
//  Created by Laurent Favard on 26/01/2018.
//  Copyright © 2018 laurent68k. All rights reserved.
//
//  https://www.raywenderlich.com/167743/sqlite-swift-tutorial-getting-started

import UIKit

class ViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.execute()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func execute() {
        
        let db = SQLDataBaseManager.sharedInstance
        
        var documentDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
        documentDirectory?.appendPathComponent("MyDataBase")
        
        if let documentDirectory = documentDirectory {

            if db.openDatabase(forBasename: documentDirectory.absoluteString) {
             
                db.createTable()
                
                db.insert(forKey:1, name:"Mizuho Lin")
                db.insert(forKey:2, name:"Yes")

                db.select()
                
                db.update(forKey: 1, name:"Mizuho Lin The Beauty")
                
                db.delete(key:2)

                db.select()
            }
        }
    }
    
}


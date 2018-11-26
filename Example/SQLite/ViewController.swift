//
//  ViewController.swift
//  SQLite
//
//  Created by ervivek40 on 08/18/2018.
//  Copyright (c) 2018 ervivek40. All rights reserved.
//

import UIKit
import SQLite

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.


        //Create or switch new database
        SQLite.shared.databaseName = "NewDatabaseName"

        //Get new pointer to current database
        let databasePointer = SQLite.shared.getDB()

        //Get current pointer to working database
        let currentDatabasePointer = SQLite.shared.db

        //Get Current database name
        let currentDatabaseName = SQLite.shared.databaseName

        //Execute raw SQL Query
        SQLite.shared.execute(query: "Your_Raw_SQL_Query")

        //Execute and know executed successfully or error occured
        let flag = SQLite.shared.execute(queryString: "Your_Raw_SQL_Query")

        //Get rows with column name
        SQLite.shared.getRowsWithCol(query: "Your_select_query")





    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


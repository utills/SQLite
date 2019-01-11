//
//  DatabaseViewController.swift
//  SQLite_Example
//
//  Created by Vivek Kumar on 11/01/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class DatabaseViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func toggleAdd(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Create New Database", message: "Please Enter Database Name", preferredStyle: .alert)
        
    }
}

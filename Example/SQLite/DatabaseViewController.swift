//
//  DatabaseViewController.swift
//  SQLite_Example
//
//  Created by Vivek Kumar on 11/01/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import SQLite
class DatabaseViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    var allFiles :[File] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getAllDB()
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
        AlertUtil.shared.alertWithTextField(parent: self, title: "Create New Database", message: "Enter Database Name", placeholder: "Database Name", value: "", proceedTitle: "Create", cancelTitle: "Later", didProceed: { (dbname) in
            SQLite.shared.databaseName = dbname
            self.getAllDB()
        }) {
           
        }
    }
    
    func getAllDB() {
        self.allFiles = FileUtility.shared.scanDirectory(directory: FileUtility.shared.defaultPath)
        self.tableView.reloadData()
    }
}
extension DatabaseViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.allFiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let file = self.allFiles[indexPath.row]
        cell.textLabel?.text = file.name
        cell.detailTextLabel?.text = file.size
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}

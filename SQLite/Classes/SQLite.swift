//
//  SQLLiteDatabase.swift
//  S-NOC
//
//  Created by Vivek Kumar on 12/6/17.
//  Copyright © 2018 Vivek Kumar. All rights reserved.
//

import Foundation
import SQLite3
public enum fetch{
    case single,column,columns,row,rows,all
}
public enum SQLiteError: Error {
    case OpenDatabase(message: String)
    case Prepare(message: String)
    case Step(message: String)
    case Bind(message: String)
}

public class SQLite{
   public static let shared = SQLite()
    var db : OpaquePointer? = nil
    var databaseName = "PrimaryDatabase"{
        didSet{
           self.db = self.getDB()
        }
    }

    public func closeDb(){
        if #available(iOS 8.2, *) {
            if sqlite3_close_v2(self.db) == SQLITE_DONE{
                print("Database with name " + self.databaseName + " Closed")
            }else{
                print("Unable to close Database with name " + self.databaseName + " Closed")
            }
        } else {
            // Fallback on earlier versions
        }
    }
    public func getDB()->OpaquePointer?{
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask,appropriateFor:nil,create: false).appendingPathComponent(self.databaseName + ".sqlite")
        var databaseConnectionPointer : OpaquePointer? = nil
        if sqlite3_open_v2(fileURL.path, &databaseConnectionPointer, SQLITE_OPEN_CREATE|SQLITE_OPEN_READWRITE|SQLITE_OPEN_FULLMUTEX, nil) == SQLITE_OK{
          print("Database with name " + self.databaseName + " Opened")
        }
        else{
            print("Unable to Open Database")
        }
        return databaseConnectionPointer
    }

    public func checkConnection() {
        if(self.db == nil){
            self.db = self.getDB()
        }
    }

    public func execute(query:String){
        self.checkConnection()
        var statement : OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK
        {
            if sqlite3_step(statement) == SQLITE_DONE{
                //                debugPrint("Executed Successfully.\n \(query)")
                sqlite3_finalize(statement)
            }
            else{
                debugPrint(sqlite3_errmsg(statement))
                debugPrint("Statement is \n \(query)")
            }
        }
        else{
            print("\(sqlite3_errmsg(db)) for statement \(query)")
        }
        statement = nil
    }
    public func execute(queryString:String)->Bool{
        var status = false
        self.checkConnection()
        var statement : OpaquePointer? = nil
        if sqlite3_prepare_v2(db, queryString, -1, &statement, nil) == SQLITE_OK
        {
            if sqlite3_step(statement) == SQLITE_DONE{
                status = true
                //                debugPrint("Executed Successfully.\n \(query)")
                sqlite3_finalize(statement)
            }
            else{
                status = false
                debugPrint(sqlite3_errmsg(statement))
                debugPrint("Statement is \n \(queryString)")
            }
        }
        else{
            print("\(sqlite3_errmsg(db)) for statement \(queryString)")
        }
        statement = nil
        return status
    }

    public func execute(query:String,contents:fetch)->String{
        self.checkConnection()
        var retStr = ""
        var statement : OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK
        {
            if sqlite3_step(statement) == SQLITE_DONE{
                debugPrint("Executed Successfully.\n \(query)")
                if contents == fetch.single{
                    retStr = String(cString: (sqlite3_column_text(statement, 0)))
                }
            }
        }
        sqlite3_finalize(statement)
        return retStr
    }
    public func execute(query:String,contents:fetch)->[String]{
        self.checkConnection()
        var statement : OpaquePointer? = nil
        var retAr : [String]? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK
        {
            if sqlite3_step(statement) == SQLITE_ROW{
                debugPrint("Executed Successfully.\n \(query)")

                while (sqlite3_step(statement) == SQLITE_ROW) {
                    let id = sqlite3_column_text(statement, 0)
                    let name = String(cString: id!)
                    if(retAr != nil){
                        retAr?.append(name)
                    }
                    else{
                        retAr = [name]
                    }
                }
            }
        }
        sqlite3_finalize(statement)
        if(retAr != nil){
            return retAr!
        }
        else{
            return [""]
        }
    }
    //Get Single Row
    public func getRow(table:String,fromCol:String,whereCol:String,equalTo:Int) -> String {
        self.checkConnection()
        var rowStr = ""
        var SqlStatement : OpaquePointer? = nil
        let query = """
        SELECT \(fromCol) FROM \(table) WHERE \(whereCol) = \(equalTo)
        """
        if sqlite3_prepare_v2(self.db, query, -1, &SqlStatement, nil) == SQLITE_OK
        {
            if (sqlite3_step(SqlStatement) == SQLITE_ROW) {

                var row = sqlite3_column_text(SqlStatement, 0)
                rowStr = String(cString: row!)
            }
        }
        sqlite3_finalize(SqlStatement)
        return rowStr
    }
    public func getRows(table:String,fromCol:String,whereCol:String,equalTo:Int) -> [String]? {
        self.checkConnection()
        var allRows : [String]?
        var SqlStatement : OpaquePointer? = nil
        let query = """
        SELECT \(fromCol) FROM \(table) WHERE \(whereCol) = \(equalTo)
        """
        if sqlite3_prepare_v2(self.db, query, -1, &SqlStatement, nil) == SQLITE_OK
        {
            while (sqlite3_step(SqlStatement) == SQLITE_ROW) {

                let row = sqlite3_column_text(SqlStatement, 0)
                let rowStr = String(cString: row!)
                if(rowStr != ""){
                    if(allRows == nil){
                        allRows = [rowStr]
                    }
                    else{
                        allRows?.append(rowStr)
                    }
                }
            }
        }
        sqlite3_finalize(SqlStatement)
        if(allRows != nil){
            return allRows!
        }
        else{
            return []
        }
    }

    public func getRows(query:String) -> [String:String]? {
        self.checkConnection()
        var allRows : [String:String] = [:]
        var SqlStatement : OpaquePointer? = nil
        if sqlite3_prepare_v2(self.db, query, -1, &SqlStatement, nil) == SQLITE_OK
        {
            while (sqlite3_step(SqlStatement) == SQLITE_ROW) {

                let val1 = sqlite3_column_text(SqlStatement, 0)
                let val2 = sqlite3_column_text(SqlStatement, 1)
                let row1Str = String(cString: val1!)
                let row2Str = String(cString: val2!)
                if(row1Str != "" && row2Str != ""){
                    allRows[row1Str] = row2Str
                }
            }
        }
        sqlite3_finalize(SqlStatement)
        return allRows
    }

    public func getRows(query:String,numberOfCol:Int) -> [[String]] {
        self.checkConnection()
        var allRows : [[String]] = [[]]
        var singleRow : [String] = []
        var SqlStatement : OpaquePointer? = nil
        if sqlite3_prepare_v2(self.db, query, -1, &SqlStatement, nil) == SQLITE_OK
        {
            var count = 0
            while (sqlite3_step(SqlStatement) == SQLITE_ROW) {
                while count < numberOfCol{
                    if let val = sqlite3_column_text(SqlStatement, Int32(count)){
                        let rowStr = String(cString: val)
                        singleRow.append(rowStr)
                    }else{
                        singleRow.append("")
                    }

                    count = count + 1
                }
                if(singleRow != []){
                    allRows.append(singleRow)
                    singleRow = []
                }
                count = 0
            }
        }else{

        }
        sqlite3_finalize(SqlStatement)
        allRows.remove(at: 0)
        return allRows
    }

    public func getRowsWithCol(query:String,numberOfCol:Int) -> [NSMutableDictionary] {
        self.checkConnection()
        var allRows : [NSMutableDictionary] = []
        var singleRow : NSMutableDictionary = [:]
        var SqlStatement : OpaquePointer? = nil
        if sqlite3_prepare_v2(self.db, query, -1, &SqlStatement, nil) == SQLITE_OK
        {
            var count = 0
            while (sqlite3_step(SqlStatement) == SQLITE_ROW) {
                while count < numberOfCol{
                    if let col = sqlite3_column_name(SqlStatement, Int32(count)){
                        let colName = String(cString:col)
                        if let val = sqlite3_column_text(SqlStatement, Int32(count)){
                                singleRow[colName] = String(cString: val)
                            }else{
                              singleRow[colName] = ""
                            }
                        }
                    count = count + 1
                }
                if(singleRow != [:]){
                    allRows.append(singleRow)
                    singleRow = [:]
                }
                count = 0
            }
        }else{

        }
        sqlite3_finalize(SqlStatement)
        return allRows
    }
    public func getRowsWithCol(query:String) -> [NSMutableDictionary] {
        self.checkConnection()
        var allRows : [NSMutableDictionary] = []
        var singleRow : NSMutableDictionary = [:]
        var SqlStatement : OpaquePointer? = nil
        if sqlite3_prepare_v2(self.db, query, -1, &SqlStatement, nil) == SQLITE_OK
        {
            var count = 0
            while (sqlite3_step(SqlStatement) == SQLITE_ROW) {
                let numberOfCol = sqlite3_column_count(SqlStatement)
                while count < numberOfCol{
                    if let col = sqlite3_column_name(SqlStatement, Int32(count)){
                        let colName = String(cString:col)
                        if let val = sqlite3_column_text(SqlStatement, Int32(count)){
                            singleRow[colName] = String(cString: val)
                        }else{
                            singleRow[colName] = ""
                        }
                    }
                    count = count + 1
                }
                if(singleRow != [:]){
                    allRows.append(singleRow)
                    singleRow = [:]
                }
                count = 0
            }
        }else{

        }
        sqlite3_finalize(SqlStatement)
        return allRows
    }

    public func getColumn(query:String) -> [String] {
        self.checkConnection()
        var columns : [String] = []
        var SqlStatement : OpaquePointer? = nil
        if sqlite3_prepare_v2(self.db, query, -1, &SqlStatement, nil) == SQLITE_OK
        {
            while (sqlite3_step(SqlStatement) == SQLITE_ROW) {
                let val = sqlite3_column_text(SqlStatement, 0)
                let rowStr = String(cString: val!)
                columns.append(rowStr)
            }

        }else{
            print(sqlite3_errmsg(db))
        }
        sqlite3_finalize(SqlStatement)
        return columns
    }
    public func getRow(query:String,numberOfCol:Int) -> [String] {
        self.checkConnection()
        var singleRow : [String] = []
        var SqlStatement : OpaquePointer? = nil
        if sqlite3_prepare_v2(self.db, query, -1, &SqlStatement, nil) == SQLITE_OK
        {
            var count = 0
            if (sqlite3_step(SqlStatement) == SQLITE_ROW) {
                while count < numberOfCol{
                    if let val = sqlite3_column_text(SqlStatement, Int32(count)){
                        let rowStr = String(cString: val)
                        if(rowStr != ""){
                            singleRow.append(rowStr)
                        }
                    }
                    count += 1
                }
                count = 0
            }
        }else{
            print(sqlite3_errmsg(db))
        }
        sqlite3_finalize(SqlStatement)
        return singleRow
    }
    public func getValue(query:String) -> String? {
        self.checkConnection()
        var value : String?
        var SqlStatement : OpaquePointer? = nil
        if sqlite3_prepare_v2(self.db, query, -1, &SqlStatement, nil) == SQLITE_OK
        {
            if (sqlite3_step(SqlStatement) == SQLITE_ROW) {
                if let val = sqlite3_column_text(SqlStatement, 0){
                    value = String(cString: val)
                }
            }
        }else{
            print(sqlite3_errmsg(db))
        }
        sqlite3_finalize(SqlStatement)
        return value
    }
    //============================================================
    public func getSingleElement(sqlStr:String)->String{
        self.checkConnection()
        var valueStr = ""
        var statement : OpaquePointer? = nil
        if sqlite3_prepare_v2(db, sqlStr, -1, &statement, nil) == SQLITE_OK
        {
            if sqlite3_step(statement) == SQLITE_ROW{
                debugPrint("Executed Successfully.\n \(sqlStr)")
                valueStr = String(cString: (sqlite3_column_text(statement, 0)))
            }
            else{
                debugPrint(sqlite3_errmsg(statement))
            }
        }
        else{
            debugPrint(sqlite3_errmsg(db))
        }
        sqlite3_finalize(statement)
        return valueStr
    }
    //============================================================
    public func getRows(table:String,fromCol:String,whereCol:String,equalTo:Int,whereCol2:String,equalTo2:String) -> [String]? {
        self.checkConnection()
        var allRows : [String]?
        var SqlStatement : OpaquePointer? = nil
        let query = """
        SELECT \(fromCol) FROM \(table) WHERE \(whereCol) = \(equalTo) AND \(whereCol2) = '\(equalTo2)'
        """
        if sqlite3_prepare_v2(self.db, query, -1, &SqlStatement, nil) == SQLITE_OK
        {
            while (sqlite3_step(SqlStatement) == SQLITE_ROW) {

                let row = sqlite3_column_text(SqlStatement, 0)
                let rowStr = String(cString: row!)
                if(rowStr != ""){
                    if(allRows == nil){
                        allRows = [rowStr]
                    }
                    else{
                        allRows?.append(rowStr)
                    }
                }
            }
        }
        sqlite3_finalize(SqlStatement)
        if(allRows != nil){
            return allRows!
        }
        else{
            return []
        }
    }

    public func insertTable(_ contentValues: NSMutableDictionary,_ table:String ,_ isIgnoreConflict: Bool)->Bool
    {
        self.checkConnection()
        var query = " \(table) ("
        for items in contentValues{
            query = query + (items.key as! String)
            query = query + ","
        }
        query.removeLast()
        query = query + ") VALUES("
        for items in contentValues{
            let keyStr = items.key as! String
            if(keyStr.last == "N"){
                if(items.value is String){
                    query = query + "'\(items.value)'"
                }else{
                    query = query + "\(items.value)"
                }
            }else{
                query = query + "'\(items.value)'"
            }
            query = query + ","
        }
        query.removeLast()
        query = query + ")"
        if(isIgnoreConflict)
        {
            query = "INSERT OR REPLACE INTO " + query
            self.execute(query: query)
        }
        else
        {
            query = "INSERT INTO " + query
            self.execute(query: query)
        }
      //  self.endTransaction()
        return true;
    }

    public func insertTable(_ contentValues: Dictionary<String, Any>,_ table:String ,_ isIgnoreConflict: Bool)->Bool
    {
        self.checkConnection()
        var query = " \(table) ("
        for items in contentValues{
            query = query + (items.key as! String)
            query = query + ","
        }
        query.removeLast()
        query = query + ") VALUES("
        for items in contentValues{
            let keyStr = items.key as! String
            if(keyStr.last == "N"){
                query = query + "\(items.value)"
            }else{
                query = query + "'\(items.value)'"
            }
            query = query + ","
        }
        query.removeLast()
        query = query + ")"
        if(isIgnoreConflict)
        {
            query = "INSERT OR REPLACE INTO " + query
            self.execute(query: query)
        }
        else
        {
            query = "INSERT INTO " + query
            self.execute(query: query)
        }
        //  self.endTransaction()
        return true;
    }


    public func updateTable(_ contentValues:NSMutableDictionary ,_ table: String ,_ whereClause: String)->Bool
    {
        self.checkConnection()
        var query = "UPDATE \(table) SET "
        for items in contentValues{
            let keyStr = items.key as! String
            query = query + keyStr + " = "
            if(keyStr.last == "N"){
                query = query +  "\(items.value)"
            }else{
                query = query + "'\(items.value)'"
            }
            query = query + ","
        }
        query.removeLast()
        query = query + " WHERE " + whereClause

       return self.execute(queryString: query)
    }
}



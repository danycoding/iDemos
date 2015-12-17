//
//  DB.swift
//  Demo
//
//  Created by DanyChen on 15/12/15.
//  Copyright © 2015 DanyChen. All rights reserved.
//

import UIKit

enum Column : String{
    
    case status, id, type
    
    case userId, userName, userAvatar
    
    case syncState
    
    case pid, category, categoryName
}

enum ColumnType : String {
    case INTEGER, TEXT
}

class TableDesc {
    
    var primaryColumn : (name: String, type : ColumnType)?
    var columns = [(name : String, type : ColumnType)]()
    var dbName : String?
    var name : String
    
    init(name : String, primaryKey : Column?, type : ColumnType = .INTEGER) {
        self.name = name
        if primaryKey != nil {
            primaryColumn = (primaryKey!.rawValue, type)
        }
    }
    
    func addColumn(name : Column, type : ColumnType = .TEXT) -> TableDesc {
        columns.append((name.rawValue, type))
        return self
    }
    
    func columns(names : Column...) -> TableDesc {
        for name in names {
            addColumn(name)
        }
        return self
    }
    
    
}

let userTable = TableDesc(name : "user", primaryKey: .userId).columns(.userName, .userAvatar)

func tableWith<T : Serializable>(type : T.Type) -> Table<T> {
    return Table<T>()
}

class Table<T : Serializable> {
    
    func save<T : Serializable>(obj : T) -> Bool {
        DB.sharedInstance
        
        return true
    }
    
    func saveAll<T : Serializable>(objs : [T]) -> Bool {
        return true
    }
    
    func query(columnName : Column, value : String) -> [T] {
        return [T]()
    }
    
    func query(columnName : Column, value : Int) -> [T] {
        return [T]()
    }
    
    func delete(columnName : Column, value : String) {
        
    }
}

extension Dictionary {
    func saveToTable(table : TableDesc) {
        
    }
}

protocol Serializable {
    
    func toDB() -> (columns : [Column], values : [String])
    static func fromDB(resultSet: FMResultSet) -> AnyObject
    static var tableDesc : TableDesc { get }
    
}

class Product : NSDictionary, Serializable {
    
    func toDB() -> (columns: [Column], values: [String]) {
        return (columns: [.pid, .category], values : [stringForColumn(.pid), stringForColumn(.category)])
    }
    
    static func fromDB(resultSet: FMResultSet) -> AnyObject {
        let product = Product()
        return product
    }
    
    static var tableDesc :  TableDesc {
        return TableDesc(name : "product", primaryKey: .pid).columns(.category, .userAvatar, .categoryName)
    }
    
    func stringForColumn(column : Column) -> String {
        if let value = objectForKey(column.rawValue)?.stringRepresentation {
            return value
        }else {
            return ""
        }
    }
    
}



extension Serializable {
    
    static func nameOf(column : Column) -> String {
        return column.rawValue
    }
    
}

class User {
    
    var id : UInt64?
    var name : String?
    var avatar : String?
    
}

extension User : Serializable {
    
    func toDB() -> (columns: [Column], values: [String]) {
        return (columns: [.userId, .userName, .userAvatar], values : [])
    }
    
    static func fromDB(resultSet: FMResultSet) -> AnyObject {
        let user = User()
        user.id = resultSet.unsignedLongLongIntForColumn(nameOf(.id))
        user.name = resultSet.stringForColumn(nameOf(.userName))
        user.avatar = resultSet.stringForColumn(nameOf(.userAvatar))
        return user
    }
    
    static var tableDesc :  TableDesc {
        return TableDesc(name : "user", primaryKey: .userId).columns(.userName, .userAvatar)
    }
}

class DB: NSObject {
    
    static let sharedInstance = DB()
    var databaseMap = [String : FMDatabase]()
    
    let databaseDescs = ["Default" : [User.tableDesc], "Other" : [Product.tableDesc]]
    
    var initSuccess = true
    
    override init() {
        super.init()
        for (databaseName, tables) in databaseDescs {
            if let database = tablesInit(databaseName, tables: tables) {
                databaseMap[databaseName] = database
            }else {
                initSuccess = false
            }
        }
    }
    
    func setUp() -> Bool{
        if initSuccess {
            return initSuccess
        }
        initSuccess = true
        for (databaseName, tables) in databaseDescs {
            if databaseMap[databaseName] == nil {
                if let database = tablesInit(databaseName, tables: tables) {
                    databaseMap[databaseName] = database
                }else {
                    initSuccess = false
                }
            }
        }
        return initSuccess
    }
    
    func tablesInit(databaseName : String, tables : [TableDesc]) -> FMDatabase? {
        // open db
        let fileManager = NSFileManager.defaultManager()
        let documents = try! fileManager.URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent("test.sqlite")
        let databaseExist = fileManager.fileExistsAtPath(fileURL.path!)
        let database = FMDatabase(path: fileURL.path)
        if !database.open() {
            print("Unable to open database")
            database.close()
            if let path = fileURL.path {
                do {
                    try fileManager.removeItemAtPath(path)
                    print("delete database file success")
                }catch {
                    print("Unable to delete database")
                }
            }
            return nil
        }
        if !databaseExist {
            for table in tables {
                createTable(database, table: table)
                table.dbName = databaseName
            }
            
        }else{
            // 0. query current existed table
            // 1. create if not exist
            // 2. query exist table schemas & compare, if not the same, add column
            // 3. init success
            var success = true
            for table in tables {
                if let existingColumns = getExistingColumnsOfTable(database, tableName: table.name) {
                    success = updateTableStructure(database, table: table, originColumnNames: existingColumns)
                }else {
                    success = createTable(database, table: table)
                }
                table.dbName = databaseName
            }
            if !success {
                database.close()
                return nil
            }
        }
        
        return database
    }
    
    func getExistingColumnsOfTable(database : FMDatabase, tableName : String) -> Set<String>? {
        let rs = database.executeQuery("PRAGMA table_info(\(tableName))", withArgumentsInArray: nil)
        var result = Set<String>()
        while rs.next() {
            if let columnName = rs.stringForColumn("name") {
                result.insert(columnName)
            }
        }
        return result.count > 0 ? result : nil
    }
    
    func createTable(database : FMDatabase, table : TableDesc) -> Bool {
        var sql = "create table " + table.name + "("
        if let primaryColumn =  table.primaryColumn {
            sql += primaryColumn.name + " " + primaryColumn.type.rawValue + " primary key"
        }else {
            sql += "id " + ColumnType.INTEGER.rawValue + " primary key" + "autoincrement"
        }
        for column in table.columns {
            sql += ", " + column.name + " " + column.type.rawValue
        }
        sql += ")"
        return database.executeUpdate(sql, withArgumentsInArray: nil)
    }
    
    func updateTableStructure(database : FMDatabase, table : TableDesc, originColumnNames : Set<String>) -> Bool{
        //ALTER TABLE {tableName} ADD COLUMN COLNew {type};
        var columnsNeedToAdd = [(name : String, type : ColumnType)]()
        var result = true
        for column in table.columns {
            if !originColumnNames.contains(column.name) {
                columnsNeedToAdd.append(column)
            }
        }
        if columnsNeedToAdd.count == 0 {
            return true
        }
        
        for column in columnsNeedToAdd {
            let sql = "alter table " + table.name + " add column " + column.name + " " + column.type.rawValue
            result = database.executeUpdate(sql, withArgumentsInArray: nil)
        }
        
        return result
    }
    
    func insert(table : TableDesc, columns : [String], values : [String]) -> Bool {
        if setUp() {
            if let database = databaseMap[table.name] {
                //            columns.
                
                //            database.executeUpdate("insert into test (x, y, z) values (?, ?, ?)", values: ["a", "b", "c"])
            }
        }
        
        return false
    }
    
    func bulkInsert() {
        
    }
    
    func queryAll(table : TableDesc) -> FMResultSet? {
        if setUp() {
            if let database = databaseMap[table.name] {
                return database.executeQuery("select * from " + table.name, withArgumentsInArray: nil)
            }
        }
        return nil
    }
 }

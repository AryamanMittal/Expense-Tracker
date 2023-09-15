//
//  SQLiteWrapper.swift
import Foundation
import SQLite3

class SQLiteWrapper
{
    static var dbPath = " ";
    
    static func copyDBFromBundleToDocDir()
    {
        //get path of db from bundle
        let sourcePath:String? = Bundle.main.path(forResource: "expenseinfo", ofType: "sqlite");
        print(sourcePath!)
        
        //prepare path to copy DB to document dir
        let pathArray:[String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true);
        
        dbPath = pathArray[0] + "/expenseinfo.sqlite"
        
        //check if db is already copied
        let fm:FileManager = FileManager.default
       
        if ( fm.fileExists(atPath: dbPath))
        {
            print(" db already copied")
        }
        else //if not copied then copy it
        {
            do{
                try fm.copyItem(atPath: sourcePath!, toPath: dbPath)
                
                print("File copied")
            }catch
            {
                print("error in copy :", error)
            }
        }
        
        //----------------
        print(dbPath)
        
    }
    
   static func executeSelectQuery(query:String) -> [ [Int:String]  ]
    {
        var resultset = Array<Dictionary<Int,String>>()
        
        //declare database pointer
        var dbPointer : OpaquePointer? = nil
        
        let openResult = sqlite3_open(SQLiteWrapper.dbPath, &dbPointer)
        
        if(openResult == SQLITE_OK)
        {
            //convert query in c-string
            let cquery = query.cString(using: String.Encoding.utf8)
            
            var resultStatement : OpaquePointer? = nil
            //resultStatement is like cursor
            let queryResultCode = sqlite3_prepare_v2(dbPointer, cquery, -1, &resultStatement, nil)
            
            if(queryResultCode==SQLITE_OK)
            {
                //read one row at a time from resultStatement
               while( sqlite3_step(resultStatement) == SQLITE_ROW )
                {
                    //store current row data in dictionary
                    let columnCount = sqlite3_column_count(resultStatement)
                    var rowDictionary=Dictionary<Int,String>()
                    for colPos in 0...columnCount-1
                    {
                        let columnValue = sqlite3_column_text(resultStatement, colPos)
                        
                        //convert columnValue as swift string
                    let ptr = UnsafeRawPointer.init(columnValue)
                        
                    let uptr = ptr?.bindMemory(to:CChar.self, capacity:0)
                    if(uptr != nil)
                    {
                     let txt = String(validatingUTF8:uptr!)
                     rowDictionary[ Int(colPos) ] = txt;
                    }else
                    {
                     rowDictionary[Int(colPos)] = ""
                    }
                        
                    }
                    //add dictionary of row to array
                    resultset.append(rowDictionary)

                }
                
            }else
                {
                    print("error in query")
                    let errPtr = sqlite3_errmsg(dbPointer)
                    let errStr = String(cString: errPtr!);
                    print(" error ------ ", errStr)
                    
            }
            
        }
         sqlite3_close(dbPointer)
        return resultset;
    }
    
    //create functios to execute queries
   static func executeNonSelectQuery(query:String)
    {
        //declare database pointer
        var dbPointer : OpaquePointer? = nil
        
        let openResult = sqlite3_open(SQLiteWrapper.dbPath, &dbPointer)
        
        if(openResult == SQLITE_OK)
        {
            //db is opened. now execute query
            
            var errmsg : OpaquePointer? = nil;
           
            //convert query in c - string
            let sqlStatement = query.cString(using: String.Encoding.utf8)
            
            let execResult =  sqlite3_exec(dbPointer, sqlStatement, nil, nil, nil);
            
            if(execResult==SQLITE_OK)
            {
                print("query succesfull")
            }else
            {
                print("error in query")
                let errPtr = sqlite3_errmsg(dbPointer)
                let errStr = String(cString: errPtr!);
                print(" error ------ ", errStr)
                
            }
            
            sqlite3_close(dbPointer)
        }
        
    }
    
}









//
//  ToDoItemModel.swift
//  ToDoList
//
/*
 MIT License
 
 Copyright (c) 2018 Gwinyai Nyatsoka
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Foundation
import RealmSwift

public class LocalDatabaseManager {
    
    static var realm : Realm? {
        
        get {
            
            do {
                let realm = try Realm()
                return realm
            }
            catch {
                return nil
            }

        }
        
        
    }
    
}

//struct toDoItem {
//
//    var name : String
//
//    var details : String
//
//    var completionDate : Date
//
//    var startDate : Date
//
//    var isComplete : Bool
//
//    init(name: String, details: String, completionDate: Date) {
//        self.name = name
//        self.details = details
//        self.completionDate = completionDate
//
//        self.isComplete = false
//        self.startDate = Date()
//    }
//
//}

//Realm based class model:

class Task : Object {
    
    @objc dynamic var id = 0
    
    override static func primaryKey() -> String {
        return "id"
    }
    
    @objc dynamic var name = ""
    
    @objc dynamic var details = ""
    
    @objc dynamic var completionDate = NSDate()
    
    @objc dynamic var startDate = NSDate()
    
    @objc dynamic var isComplete = false
    
}


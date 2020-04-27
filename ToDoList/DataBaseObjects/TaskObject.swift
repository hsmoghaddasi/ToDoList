//
//  Task.swift
//  ToDoList
//
//  Created by Hassan Sadegh Moghaddasi on 4/26/20.
//  Copyright © 2020 Hassan Sadegh Moghaddasi. All rights reserved.
//

import Foundation
import RealmSwift

class TaskObject: Object {
    @objc dynamic var id = String()
    @objc dynamic var suoTitr = String()
    @objc dynamic var title = String()
    @objc dynamic var detail = String()
    @objc dynamic var deadLine = String() // yyyy-MM-dd hh:mm
    @objc dynamic var estimatedTime: TimeInterval = 0 // unit: minute
    @objc dynamic var progress: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

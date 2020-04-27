//
//  TaskModel.swift
//  ToDoList
//
//  Created by Hassan Sadegh Moghaddasi on 4/26/20.
//  Copyright © 2020 Hassan Sadegh Moghaddasi. All rights reserved.
//

import Foundation
import RealmSwift

class TaskModel {
    
    static func InsertTask(NewTask: TaskObject, Completion: @escaping (Bool) -> (Void)) {
        var realm: Realm!
        do {
            realm = try Realm()
            do {
                try realm.write {
                    realm.add(NewTask)
                    Completion(true)
                }
            }catch let Err as NSError {
                print(Err)
                Completion(false)
            }
        }catch let err as NSError{
            print("Error On Insert Object Task DataBase")
            print("Error: \(err)")
            Completion(false)
        }
    }
    
    static func GetTask(Filter: NSPredicate? = nil, Completion: @escaping ([TaskObject]) -> (Void)) {
        var realm: Realm!
        do {
            realm = try Realm()
            let Res = realm.objects(TaskObject.self).filter(Filter!).toArray(ofType: TaskObject.self) as [TaskObject]
            Completion(Res.count > 0 ? Res : [])
        }catch let err as NSError{
            print("Error On Get from Task DataBase")
            print("Error: \(err)")
            Completion([])
        }
    }
    
    static func UpdateTask(UpdatedTask: TaskObject, Completion: @escaping (Bool)->(Void)) {
        var realm: Realm!
        do {
            realm = try Realm()
            do {
                try realm.write {
                    realm.add(UpdatedTask, update: .all)
                    Completion(true)
                }
            }catch let Err as NSError {
                print("Update Task Failed: \(Err)")
                Completion(false)
            }
        }catch let err as NSError{
            print("Error On Update Task DataBase")
            print("Error: \(err)")
            Completion(false)
        }
    }
    
    static func DeleteTask(DeletingTask: TaskObject, Completion: @escaping (Bool) -> (Void)) {
        var realm: Realm!
        do {
            realm = try Realm()
            try realm.write{
                realm.delete(DeletingTask)
                Completion(true)
            }
        }catch let err as NSError{
            print("Error On Update Task DataBase")
            print("Error: \(err)")
            Completion(false)
        }
    }
    
    static func DeleteTasks(Completion: @escaping (Bool) -> (Void)) {
       var realm: Realm!
        do {
            realm = try Realm()
            do {
                try realm.write {
                    let allTasks = realm.objects(TaskObject.self)
                     realm.delete(allTasks)
                    
                    //Completion(true)
                }
            }catch let Err as NSError {
                print("Delete Task Failed, Error: \(Err)")
                //Completion(false)
            }
        }catch let err as NSError{
            print("Error On Clear Tasks on Task DataBase")
            print("Error: \(err)")
            return
        }
    }
    
}

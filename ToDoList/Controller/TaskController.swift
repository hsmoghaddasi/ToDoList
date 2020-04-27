//
//  TaskController.swift
//  ToDoList
//
//  Created by Hassan Sadegh Moghaddasi on 4/26/20.
//  Copyright © 2020 Hassan Sadegh Moghaddasi. All rights reserved.
//

import Foundation
import RealmSwift


class TaskController {
    static func InsertTask(SuTitr: String, Title: String, Detail: String, DeadLine: String, EstimatedTime: TimeInterval, Progress: Int, Completion: @escaping (Bool)->(Void)) {
        let NewTask = TaskObject()
        NewTask.id = UUID().uuidString
        NewTask.suoTitr = SuTitr
        NewTask.title = Title
        NewTask.detail = Detail
        NewTask.deadLine = DeadLine
        NewTask.estimatedTime = EstimatedTime
        NewTask.progress = Progress
        TaskModel.InsertTask(NewTask: NewTask, Completion: {
            result in
            Completion(result)
        })
    }
    
    
    
    static func EditTask(ID: String, SuTitr: String = "", Title: String  = "", Detail: String = "", DeadLine: String = "", EstimatedTime: TimeInterval = -1, Progress: Int = -1, Completion: @escaping (Bool)->(Void)) {
        TaskController.GetTask(byID: ID, Completion: {
            FetchedTask in
            if FetchedTask.id.isEmpty { // Not Exist
                Completion(false)
            }else {
                let EditedTask = TaskObject()
                EditedTask.id = ID
                EditedTask.suoTitr = SuTitr.isEmpty ? FetchedTask.suoTitr: SuTitr
                EditedTask.title = Title.isEmpty ? FetchedTask.title: Title
                EditedTask.detail = Detail.isEmpty ? FetchedTask.detail: Detail
                EditedTask.deadLine = DeadLine.isEmpty ? FetchedTask.deadLine: DeadLine
                EditedTask.estimatedTime = EstimatedTime == -1 ? FetchedTask.estimatedTime : EstimatedTime
                EditedTask.progress = Progress == -1 ? FetchedTask.progress : Progress
                TaskModel.UpdateTask(UpdatedTask: EditedTask, Completion: {
                    result in
                    Completion(result)
                })
            }
        })
    }
    
    static func DeleteTask(ID: String, Completion: @escaping (Bool)->(Void)) {
        TaskController.GetTask(byID: ID, Completion: {
            FetchedTask in
            if !(FetchedTask.id.isEmpty) {
                TaskModel.DeleteTask(DeletingTask: FetchedTask, Completion: {
                    result in
                    Completion(result)
                })
            }else {
                Completion(false)
            }
        })
        
    }
    
    
    static func GetTask(byID id: String, Completion: @escaping (TaskObject)->()) {
        TaskController().GetTasks(id: id, Completion: {
            TaskList in
            Completion(TaskList.first ?? TaskObject())
        })
    }
    
    static func GetTask(byDate date: String, Completion: @escaping ([TaskObject])->()) {
        TaskController().GetTasks(Date: date, Completion: {
            TaskList in
            Completion(TaskList)
        })
    }
    
    private func GetTasks(id: String = "", Date: String = "", Completion: @escaping ([TaskObject])->()) {
        if !(id.isEmpty) { //Search by ID
            let predicate = NSPredicate(format: "id = %@", id)
            TaskModel.GetTask(Filter: predicate, Completion: { FetchedTasks in
                Completion(FetchedTasks)
            })
        }else if !(Date.isEmpty) { // Search by Date
            let predicate = NSPredicate(format: "deadLine BEGINSWITH %@", Date)
            TaskModel.GetTask(Filter: predicate, Completion: { FetchedTasks in
                Completion(FetchedTasks)
            })
        }else { // Get Tasks List
            
            TaskModel.GetTask(Completion: { FetchedTasks in
                Completion(FetchedTasks)
            })
        }
    }
    
    
}

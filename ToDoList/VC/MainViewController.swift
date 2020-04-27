//
//  MainViewController.swift
//  ToDoList
//
//  Created by Hassan Sadegh Moghaddasi on 4/26/20.
//  Copyright © 2020 Hassan Sadegh Moghaddasi. All rights reserved.
//

import UIKit
import SwipeCellKit
import Kingfisher
import CircleProgressBar

protocol ReloadDelegate: class {
    func ReloadData(date: String)
}

class MainViewController: UIViewController, UITableViewDataSource, SwipeTableViewCellDelegate, ReloadDelegate {

    // Outlets
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var LeftButton: UIButton!
    @IBOutlet weak var RightButton: UIButton!
    @IBOutlet weak var TasksTableView: UITableView!
    @IBOutlet weak var PlusButton: UIButton!
    
    // Variables
    var TaskList = [TaskObject]()
    var defaultOptions = SwipeOptions()
    var isSwipeRightEnabled = true
    var buttonDisplayMode: ButtonDisplayMode = .imageOnly
    var buttonStyle: ButtonStyle = .circular
    var usesTallCells = false

    // Sysmte Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TasksTableView.allowsMultipleSelectionDuringEditing = false
        self.TasksTableView.backgroundColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1)
        
        self.LoadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as? TaskTableViewCell else {
            fatalError("Misconfigured cell type, TaskTableViewCell")
        }
        cell.delegate = self
        cell.selectionStyle = .none
        cell.TaskInfo = TaskList[indexPath.row]
        cell.SuTitrLabel.text = TaskList[indexPath.row].suoTitr
        cell.TitleLabel.text = TaskList[indexPath.row].title
        cell.DateLabel.text = TaskList[indexPath.row].deadLine
        cell.ProgressView.setProgress(CGFloat(TaskList[indexPath.row].progress) / (100), animated: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .left {
            let DoneSituation = SwipeAction(style: .default, title: nil) { action, indexPath in
                let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
                if self.TaskList[indexPath.row].progress < 100 {
                    TaskController.EditTask(ID: self.TaskList[indexPath.row].id, Progress: 100, Completion: {
                        res in
                        self.ReloadData(date: (self.TitleLabel.text != "Today" ? self.TitleLabel.text: "")!)
                    })
                }else {
                    TaskController.EditTask(ID: self.TaskList[indexPath.row].id, Progress: 0, Completion: {
                        res in
                        self.ReloadData(date: (self.TitleLabel.text != "Today" ? self.TitleLabel.text: "")!)
                    })
                }
            }
            
            let descriptor: ActionDescriptor!
            if self.TaskList[indexPath.row].progress < 100 {
                descriptor = .done
                
            }else {
                descriptor = .undone
            }
             
            configure(action: DoneSituation, with: descriptor)
            return [DoneSituation]
            
        } else {
            let edit = SwipeAction(style: .default, title: nil) { action, indexPath in
                
                self.performSegue(withIdentifier: "TaskDeatilSegue", sender: indexPath)
            }
            
            configure(action: edit, with: .edit)
            
            let delete = SwipeAction(style: .destructive, title: nil) { action, indexPath in
                TaskController.DeleteTask(ID: self.TaskList[indexPath.row].id, Completion: {
                    res in
                    self.ReloadData(date: (self.TitleLabel.text != "Today" ? self.TitleLabel.text: "")!)
                })
            }
            configure(action: delete, with: .delete)
            
            return [delete, edit]
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TaskDeatilSegue" {
            guard ((segue.destination as? NewTaskViewController) != nil) else {
                return
            }
            if let indexPath = sender as? IndexPath {
                (segue.destination as? NewTaskViewController)?.TaskInfo = TaskList[indexPath.row]
            }
            (segue.destination as? NewTaskViewController)?.delegate = self
        }
    }
    
    // Actions
    @IBAction func LeftButton(_ sender: UIButton) {
        let NewDate = self.GetNewDate(AddingDay: -1)
        if NewDate != "" {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let DayString = formatter.string(from: Date())
            if DayString == NewDate {
                self.TitleLabel.text = "Today"
            }else {
                self.TitleLabel.text = NewDate
            }
            ReloadData(date: NewDate)
        }
        
    }
    
    @IBAction func RightButton(_ sender: UIButton) {
        let NewDate = self.GetNewDate(AddingDay: 1)
        if NewDate != "" {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let DayString = formatter.string(from: Date())
            if DayString == NewDate {
                self.TitleLabel.text = "Today"
            }else {
                self.TitleLabel.text = NewDate
            }
            ReloadData(date: NewDate)
        }
    }
    
    // My functions
    
    func LoadData() {
        self.LeftButton.setTitle("", for: .normal)
        KingfisherManager.shared.retrieveImage(with: URL(string: URLList.NavigationBarLeftIConURL.rawValue)!, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
            self.LeftButton.setImage(image, for: .normal)
        })
        self.RightButton.setTitle("", for: .normal)
        KingfisherManager.shared.retrieveImage(with: URL(string: URLList.NavigationBarRightIconURL.rawValue)!, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
            self.RightButton.setImage(image, for: .normal)
        })
        
        self.PlusButton.setTitle("", for: .normal)
        KingfisherManager.shared.retrieveImage(with: URL(string: URLList.PlusIconURL.rawValue)!, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
            self.PlusButton.setImage(image, for: .normal)
        })
        self.PlusButton.tintColor = UIColor.white
        self.PlusButton.backgroundColor = UIColor(red: 0, green: 200/255, blue: 250/255, alpha: 1)
        self.PlusButton.layer.cornerRadius = 25
        self.ReloadData()
        
    }
    
    @objc func ReloadData(date: String = "") {
        var DayString = ""
        if date.isEmpty {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            DayString = formatter.string(from: Date())
        }else {
            DayString = date
        }
        self.TaskList.removeAll()
        TaskController.GetTask(byDate: DayString, Completion: {
            res in
            self.TaskList = res
            self.TasksTableView.reloadData()
        })
    }
    
    func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
        action.title = descriptor.title(forDisplayMode: buttonDisplayMode)
        descriptor.image(forStyle: buttonStyle, displayMode: buttonDisplayMode, Completion: {
            image in
            action.image = image
            switch self.buttonStyle {
            case .backgroundColor:
                action.backgroundColor = descriptor.color(forStyle: self.buttonStyle)
            case .circular:
                action.backgroundColor = .clear
                action.textColor = descriptor.color(forStyle: self.buttonStyle)
                action.font = .systemFont(ofSize: 13)
                action.transitionDelegate = ScaleTransition.default
            }
            
        })
    }
    
    func GetNewDate(AddingDay: Int) ->String {
        var currentDate: Date!
        if self.TitleLabel.text == "Today" {
            currentDate = Date()
        }else {
            let NewDateFormatter = DateFormatter()
            NewDateFormatter.dateFormat =  "yyyy-MM-dd"
            if let newDate = NewDateFormatter.date(from: self.TitleLabel.text!) {
                currentDate = newDate
            }
        }
        var dateComponent = DateComponents()
        dateComponent.day = AddingDay
        let NewDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        
        let component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: NewDate ?? Date())
        if let year = component.year, let month = component.month, let day = component.day {
            let NewStringDate = "\(year)-\(NumberFormatter.AddZero(Number: month))-\(NumberFormatter.AddZero(Number: day))"
            return NewStringDate
        }else {
            return ""
        }
    }
    
}

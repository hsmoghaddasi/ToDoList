//
//  NewTaskViewController.swift
//  ToDoList
//
//  Created by Hassan Sadegh Moghaddasi on 4/27/20.
//  Copyright © 2020 Hassan Sadegh Moghaddasi. All rights reserved.
//

import UIKit

class NewTaskViewController: UIViewController {

    
    // Outlets
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var HeadingLabel: UILabel!
    @IBOutlet weak var HeadingTextField: UITextField!
    @IBOutlet weak var TaskTitleLabel: UILabel!
    @IBOutlet weak var TaskTitleTextField: UITextField!
    @IBOutlet weak var DetailLabel: UILabel!
    @IBOutlet weak var DetailTextView: UITextView!
    @IBOutlet weak var TimeEstimationLabel: UILabel!
    @IBOutlet weak var TimeEstimationPickerView: UIDatePicker!
    @IBOutlet weak var ProgressTitleLabel: UILabel!
    @IBOutlet weak var ProgressValueLabel: UILabel!
    @IBOutlet weak var TaskProgressView: UISlider!
    @IBOutlet weak var DeadLineLabel: UILabel!
    @IBOutlet weak var DeadLinePickerView: UIDatePicker!
    @IBOutlet weak var CancelButtonOutlet: UIButton!
    @IBOutlet weak var AddButtonOutlet: UIButton!
    
    
    // Variables
    var EstimaedTime = NSTimeIntervalSince1970
    var DeadLine = String()
    var Progress = Int()
    var TaskInfo = TaskObject()
    weak var delegate: ReloadDelegate?
    
    // System Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.Design()
        if !(self.TaskInfo.id.isEmpty) {
            self.LoadData()
        }
    }
    
    
    
    
    // Actions
    
    @IBAction func TimeEstimatePickerView(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: sender.date)
        if let hour = components.hour, let minutes = components.minute {
            self.EstimaedTime = Double((hour * 60) + minutes)
        }
    }
    
    
    @IBAction func DeadLinePickerView(_ sender: UIDatePicker) {
        let component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: sender.date)
        if let year = component.year, let month = component.month, let day = component.day, let hour = component.hour, let minutes = component.minute {
            self.DeadLine = "\(year)-\(NumberFormatter.AddZero(Number: month))-\(NumberFormatter.AddZero(Number: day)) \(NumberFormatter.AddZero(Number: hour)):\(NumberFormatter.AddZero(Number: minutes))"
        }
    }
    
    
    @IBAction func ProgressSlider(_ sender: UISlider) {
        self.Progress = Int(sender.value)
        self.ProgressValueLabel.text = String(self.Progress) + "%"
    }
    
    @IBAction func CancelButton(_ sender: UIButton) {
        self.delegate?.ReloadData(date: "")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func AddButton(_ sender: UIButton) {
        // Check for Empty and Add to DB show message and dismiss
        if HeadingTextField.text!.isEmpty || TaskTitleTextField.text!.isEmpty {
            return
        }
        if self.EstimaedTime == 0 {
            self.EstimaedTime = 1
        }
        
        if self.DeadLine == "" {
            let component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
            if let year = component.year, let month = component.month, let day = component.day, let hour = component.hour, let minutes = component.minute {
                self.DeadLine = "\(year)-\(NumberFormatter.AddZero(Number: month))-\(NumberFormatter.AddZero(Number: day)) \(NumberFormatter.AddZero(Number: hour)):\(NumberFormatter.AddZero(Number: minutes))"
            }
        }
        
        if self.TaskInfo.id.isEmpty { // New Task
            TaskController.InsertTask(SuTitr: HeadingTextField.text!, Title: TaskTitleTextField.text!, Detail: DetailTextView.text!, DeadLine: DeadLine, EstimatedTime: self.EstimaedTime, Progress: self.Progress, Completion: {
                res in
                if res {
                    self.delegate?.ReloadData(date: "")
                    self.dismiss(animated: true, completion: nil)
                }else {
                    print("failed")
                }
            })
        }else { // Edit Task
            TaskController.EditTask(ID: self.TaskInfo.id, SuTitr: HeadingTextField.text!, Title: self.TaskTitleTextField.text!, Detail: self.DetailTextView.text!, DeadLine: self.DeadLine, EstimatedTime: self.EstimaedTime, Progress: self.Progress, Completion: {res in
                if res {
                    self.delegate?.ReloadData(date: "")
                    self.dismiss(animated: true, completion: nil)
                }else {
                    print("failed")
                }
            })
        }
        
    }
    
    
    
    // My Functions
    func Design() {
        self.HeadingTextField.layer.borderColor = UIColor.gray.cgColor
        self.HeadingTextField.layer.borderWidth = 0.3
        self.HeadingTextField.layer.shouldRasterize = true
        
        self.TaskTitleTextField.layer.borderColor = UIColor.gray.cgColor
        self.TaskTitleTextField.layer.borderWidth = 0.3
        
        self.DetailTextView.backgroundColor = .white
        self.DetailTextView.textColor = .black
        self.DetailTextView.layer.borderColor = UIColor.gray.cgColor
        self.DetailTextView.layer.borderWidth = 0.3
        self.DetailTextView.isOpaque = false
        self.DetailTextView.layer.cornerRadius = 5
        self.DetailTextView.clipsToBounds = true
        
        self.DeadLinePickerView.minimumDate = Date()
        
        self.CancelButtonOutlet.backgroundColor = UIColor(red: 0, green: 200/255, blue: 250/255, alpha: 1)
        self.CancelButtonOutlet.layer.cornerRadius = 20
        
        self.AddButtonOutlet.backgroundColor = UIColor(red: 0, green: 200/255, blue: 250/255, alpha: 1)
        self.AddButtonOutlet.layer.cornerRadius = 20
    }
    
    
    func LoadData() {
        self.AddButtonOutlet.setTitle("Update", for: .normal)
        self.HeadingTextField.text = self.TaskInfo.suoTitr
        self.TaskTitleTextField.text = self.TaskInfo.title
        self.DetailTextView.text = self.TaskInfo.detail
        self.EstimaedTime = self.TaskInfo.estimatedTime
        let hours = self.TaskInfo.estimatedTime / 60
        let minutes = self.TaskInfo.estimatedTime.remainder(dividingBy: 60)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        if let estimateTime = dateFormatter.date(from: "\(NumberFormatter.AddZero(Number: Int(hours))):\(NumberFormatter.AddZero(Number: Int(minutes)))") {
            TimeEstimationPickerView.setDate(estimateTime, animated: true)
        }
        self.Progress = self.TaskInfo.progress
        self.ProgressValueLabel.text = String(self.TaskInfo.progress) + "%"
        self.TaskProgressView.setValue(Float(self.TaskInfo.progress), animated: true)
        self.DeadLine = self.TaskInfo.deadLine
        let DeadLineDateFormatter = DateFormatter()
        DeadLineDateFormatter.dateFormat =  "yyyy-MM-dd HH:mm"
        if let deadLine = DeadLineDateFormatter.date(from: self.TaskInfo.deadLine) {
            DeadLinePickerView.setDate(deadLine, animated: true)
        }

    }

}

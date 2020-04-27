//
//  TaskTableViewCell.swift
//  ToDoList
//
//  Created by Hassan Sadegh Moghaddasi on 4/26/20.
//  Copyright © 2020 Hassan Sadegh Moghaddasi. All rights reserved.
//

import UIKit
import SwipeCellKit
import CircleProgressBar

class TaskTableViewCell: SwipeTableViewCell {

    // Outlets
    @IBOutlet weak var CustomBackGroundView: UIView!
    @IBOutlet weak var ProgressBarBackgroundView: UIView!
    @IBOutlet weak var SuTitrLabel: UILabel!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var ProgressView: CircleProgressBar!
    
    //variables
    var TaskInfo = TaskObject()
    
    
    // System Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        self.CustomBackGroundView.layer.borderColor = UIColor.gray.cgColor
        self.CustomBackGroundView.layer.borderWidth = 0.3
        self.CustomBackGroundView.layer.cornerRadius = 20
        self.ProgressView.hintTextFont = UIFont.boldSystemFont(ofSize: 13)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // My functions
    

}

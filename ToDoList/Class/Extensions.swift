//
//  Extensions.swift
//  ToDoList
//
//  Created by Hassan Sadegh Moghaddasi on 4/27/20.
//  Copyright © 2020 Hassan Sadegh Moghaddasi. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

extension UIViewController {
    
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }

        return array
    }
}

extension NumberFormatter {
    
    static func AddZero(Number: Int) -> String{
        switch Number {
        case 1:
            return "01"
        case 2:
            return "02"
        case 3:
            return "03"
        case 4:
            return "04"
        case 5:
            return "05"
        case 6:
            return "06"
        case 7:
            return "07"
        case 8:
            return "08"
        case 9:
            return "09"
        default:
            if Number > 9 {
                return "\(Number)"
            }else {
                return "00"
            }
        }
    }
}

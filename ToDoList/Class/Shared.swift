//
//  Shared.swift
//  ToDoList
//
//  Created by Hassan Sadegh Moghaddasi on 4/26/20.
//  Copyright © 2020 Hassan Sadegh Moghaddasi. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class IndicatorView: UIView {
    var color = UIColor.clear {
        didSet { setNeedsDisplay() }
    }
    
    override func draw(_ rect: CGRect) {
        color.set()
        UIBezierPath(ovalIn: rect).fill()
    }
}

enum ActionDescriptor {
    case more, flag, delete, edit, done, undone
    
    func title(forDisplayMode displayMode: ButtonDisplayMode) -> String? {
        guard displayMode != .imageOnly else { return nil }
        
        switch self {
        
        case .more: return "More"
        case .flag: return "Flag"
        case .delete: return "Delete"
        case .edit: return "Edit"
        case .done: return "Done"
        case .undone: return "UnDone"
        }
    }
    
    func image(forStyle style: ButtonStyle, displayMode: ButtonDisplayMode, Completion: @escaping (UIImage?)->(Void)) {
        //guard displayMode != .titleOnly else {  return }
        if displayMode == .titleOnly {
            Completion(nil)
        }
        let name: String
        switch self {
        
        case .more: name = "More"
        case .flag: name = "Flag"
        case .delete: name = "Delete"
        case .edit: name = "Edit"
        case .done: name = "Done"
        case .undone: name = "UnDone"
        }
        
    #if canImport(Combine)
        if #available(iOS 13.0, *) {
            let name: String
            switch self {
            
            case .more: name = "ellipsis.circle.fill"
            case .flag: name = "flag.fill"
            case .delete: name = URLList.DeleteIconURL.rawValue
            case .edit: name = URLList.EditIconURL.rawValue
            case .done: name = URLList.DoneIconURL.rawValue
            case .undone: name = URLList.UnDoneIconURL.rawValue
            }
            
            if style == .backgroundColor {
                //let config = UIImage.SymbolConfiguration(pointSize: 23.0, weight: .regular)
                //Completion(UIImage(systemName: name, withConfiguration: config))
                KingfisherManager.shared.retrieveImage(with: URL(string: name)!, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                    
                    let FinalImage = image?.withTintColor(.white, renderingMode: .alwaysTemplate)
                    Completion(FinalImage)
                })
            } else {
                //let config = UIImage.SymbolConfiguration(pointSize: 22.0, weight: .regular)
                
                KingfisherManager.shared.retrieveImage(with: URL(string: name)!, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                    
                    let FinalImage = image?.withTintColor(.white, renderingMode: .alwaysTemplate)
                    Completion(self.circularIcon(with: self.color(forStyle: style), size: CGSize(width: 50, height: 50), icon: FinalImage))
                })
                //let iimage = UIImage(systemName: name, withConfiguration: config)?.withTintColor(.white, renderingMode: .alwaysTemplate)
                
                
                
            }
        } else {
            Completion(UIImage(named: style == .backgroundColor ? name : name + "-circle"))
        }
    #else
        Completion(UIImage(named: style == .backgroundColor ? name : name + "-circle"))
    #endif
    }
    
    func color(forStyle style: ButtonStyle) -> UIColor {
    #if canImport(Combine)
        switch self {
        case .more: return #colorLiteral(red: 0.7803494334, green: 0.7761332393, blue: 0.7967314124, alpha: 1)
        case .flag: return UIColor.yellow
        case .delete: return UIColor.red
        case .edit: return UIColor.orange
        case .done: return UIColor.green
        case .undone: return UIColor.red
        }
    #else
        switch self {
        case .more: return #colorLiteral(red: 0.7803494334, green: 0.7761332393, blue: 0.7967314124, alpha: 1)
        case .flag: return #colorLiteral(red: 1, green: 0.5803921569, blue: 0, alpha: 1)
        case .trash: return #colorLiteral(red: 1, green: 0.2352941176, blue: 0.1882352941, alpha: 1)
        }
    #endif
    }
    
    func circularIcon(with color: UIColor, size: CGSize, icon: UIImage? = nil) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        UIBezierPath(ovalIn: rect).addClip()

        color.setFill()
        UIRectFill(rect)

        if let icon = icon {
            let iconRect = CGRect(x: (rect.size.width - icon.size.width) / 2,
                                  y: (rect.size.height - icon.size.height) / 2,
                                  width: icon.size.width,
                                  height: icon.size.height)
            icon.draw(in: iconRect, blendMode: .normal, alpha: 1.0)
        }

        defer { UIGraphicsEndImageContext() }
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
enum ButtonDisplayMode {
    case titleAndImage, titleOnly, imageOnly
}

enum ButtonStyle {
    case backgroundColor, circular
}

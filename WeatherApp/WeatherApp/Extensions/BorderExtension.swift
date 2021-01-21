//
//  BorderExtension.swift
//  MyWeatherApp#2
//
//  Created by Evian on 16.12.2020.
//

import UIKit

extension CALayer {
  
  func addBorder(edge: UIRectEdge, color: UIColor) {
    
    let thickness : CGFloat = 0.7
    let border = CALayer()
    
    switch edge {
    case .top:
      border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
    case .bottom:
      border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
    case .left:
      border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
    case .right:
      border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
    default:
      break
    }
    
    border.backgroundColor = color.cgColor;
    
    addSublayer(border)
  }
}



//
//  Conversions.swift
//  CardBattleGame
//
//  Created by SAHNAWAJ BISWAS on 15/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

extension Double {
  
  func toCelcius() -> Double {
    return ((self - 32.0) / 1.8)
  }
  
  func toKPH() -> Double {
    return (self * 1.609344)
  }
}

extension Date {
  func toString(withFormat format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: self)
  }
}

extension UIView {
  func dropShadow(scale: Bool = true) {
    self.layer.masksToBounds = false
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowOpacity = 0.5
    self.layer.shadowOffset = CGSize(width: -1, height: 1)
    self.layer.shadowRadius = 1
    self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    self.layer.shouldRasterize = true
    self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
  
  func roundBorder(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: CGColor) {
    self.layer.cornerRadius = cornerRadius
    self.layer.borderWidth = borderWidth
    self.layer.borderColor = borderColor
  }
}

extension UIViewController {
  
  func cbg_presentErrorAlert(withTitle title: String, message: String) {
    let alertController =  UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    let okAction  = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) in
    }
    alertController.addAction(okAction)
    self.present(alertController, animated: true, completion: nil)
  }
}

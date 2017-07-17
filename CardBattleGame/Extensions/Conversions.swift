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
}

extension CGFloat {
  var degrees: CGFloat {
    return self * CGFloat(180.0 / Double.pi)
  }
}

extension Array {
  func subArray(size: Int) -> [Element] {
    var result = [Element]()
    if size < count {
      var temporaryArray = self
      while result.count < size {
        let idx = getRandomNumber(maxNumber: temporaryArray.count)
        result.append(temporaryArray[idx])
        temporaryArray.remove(at: idx)
      }
    }
    return result
  }
}

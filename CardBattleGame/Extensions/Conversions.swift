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

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        print(dateFormatter.string(from: self))
        return dateFormatter.string(from: self)
    }
}

extension UIView {
    
    func dropShadow(scale: Bool = true)
    {
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

extension UILabel {
    
    func setDefaultProperties() {
        self.font = UIFont(name: "systemFont-Bold", size: 14)
        self.textColor = UIColor.white
        self.textAlignment = NSTextAlignment.center
    }
}

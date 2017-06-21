//
//  Common.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 19/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

class Common: NSObject
{

    //MARK: Utility Methods
    public func randomIntFrom(start: Int, to end: Int) -> Int
    {
        var a = start
        var b = end
        // swap to prevent negative integer crashes
        if a > b {
            swap(&a, &b)
        }
        return Int(arc4random_uniform(UInt32(b - a + 1))) + a
    }
    
    func setTextProperties(textLbl : UILabel) -> UILabel
    {
        textLbl.font = UIFont(name: "systemFont-Bold", size: 14)
        textLbl.textColor = UIColor.white
        textLbl.textAlignment = NSTextAlignment.center
        
        return textLbl
    }
}

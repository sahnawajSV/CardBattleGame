//
//  cardLabel.swift
//  CardBattleGame
//
//  Created by BuRn on 27/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

/// Label subclass to customize the Labels displayed on the Card
class cardLabel: UILabel {

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    self.commonInit()
    
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.commonInit()
  }
  
  func commonInit(){
    self.clipsToBounds = true
    self.textColor = UIColor.white
    self.textAlignment = .center
    self.font = font.withSize(15)
    self.setProperties(borderWidth: 1.0, borderColor:UIColor.black)
  }
  
  func setProperties(borderWidth: Float, borderColor: UIColor) {
    self.layer.borderWidth = CGFloat(borderWidth)
    self.layer.borderColor = borderColor.cgColor
  }

}

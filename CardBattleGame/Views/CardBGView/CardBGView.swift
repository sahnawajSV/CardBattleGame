//
//  CardBGView.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 21/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

/// Contains implementations for Card BG View - This is the view visible before the actual card is played on top of it
class CardBGView: UIView {
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    addUIBehavior()
  }
  
  func addUIBehavior() {
    self.backgroundColor = UIColor.clear
    self.layer.cornerRadius = 10.0
    self.layer.borderColor = UIColor.brown.cgColor
    self.layer.borderWidth = 2
    self.clipsToBounds = true
  }

}

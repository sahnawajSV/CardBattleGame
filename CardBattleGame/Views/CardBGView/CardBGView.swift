//
//  CardBGView.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 21/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

class CardBGView: UIView {
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    addUIBehavior()
  }
  
  func addUIBehavior() {
//    self.dropShadow(scale: true)
  }

}

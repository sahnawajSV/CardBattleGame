//
//  DeckCollectionViewCell.swift
//  CardBattleGame
//
//  Created by SAHNAWAJ BISWAS on 23/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

class DeckCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var nameLbl: UILabel!
  @IBOutlet weak var healthLbl: UILabel!
  @IBOutlet weak var attackLbl: UILabel!
  @IBOutlet weak var battlePointLbl: UILabel!
  @IBOutlet weak var addDeckButton: UIButton!
  
  override var isSelected: Bool {
    willSet {
      contentView.backgroundColor = newValue ? .orange : .clear
    }
  }
  
  override var isHighlighted: Bool {
    willSet {
      contentView.backgroundColor = newValue ? .green : .clear
    }
  }
}

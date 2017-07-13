//
//  EditDeckCollectionViewCell.swift
//  CardBattleGame
//
//  Created by SAHNAWAJ BISWAS on 20/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

protocol EditDeckCollectionViewCellDelegate : class {
  func didPressAddButton(_ sender: UICollectionViewCell)
}

/// Edit Deck UICollectionViewCell used to set the IBOutlet to the custom Deck cell
class EditDeckCollectionViewCell: UICollectionViewCell {
  
  weak var cellDelegate: EditDeckCollectionViewCellDelegate?
  
  @IBOutlet weak var cardView: UIView!
  @IBOutlet weak var nameLbl: UILabel!
  @IBOutlet weak var healthLbl: UILabel!
  @IBOutlet weak var attackLbl: UILabel!
  @IBOutlet weak var battlePointLbl: UILabel!
  @IBOutlet weak var addDeckButton: UIButton!
  
  @IBAction func addButtonPressed(_ sender: UIButton) {
    cellDelegate?.didPressAddButton(self)
  }
}

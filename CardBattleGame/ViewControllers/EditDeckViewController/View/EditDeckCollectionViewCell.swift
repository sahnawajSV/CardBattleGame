//
//  EditDeckCollectionViewCell.swift
//  CardBattleGame
//
//  Created by SAHNAWAJ BISWAS on 20/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit


/// Edit Deck UICollectionViewCell used to set the IBOutlet to the custom Deck cell  
class EditDeckCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var healthLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var battlePointLbl: UILabel!
    @IBOutlet weak var addDeckButton: UIButton!

}

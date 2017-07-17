//
//  CardView.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 19/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

enum CardState: String {
  case canAttack
  case cannotAttack
  case isSelected
  case neutral
}

/// This is the actual Card View containing the BattlePoints, Name, Attack and Health Points data
class CardView: UIView {
  //MARK: - Accessor Objects
  var bpText: cardLabel = cardLabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
  var attackText: cardLabel = cardLabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
  var healthText: cardLabel = cardLabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
  var nameText: cardLabel = cardLabel(frame: CGRect(x: 0 , y: 0, width: 194, height: 254))
  var cardButton: UIButton = UIButton(frame: CGRect(x: 0 , y: 0, width: 194, height: 254))
  var bpView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
  var attackView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
  var healthView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
  var nameView = UIView(frame: CGRect(x: 0 , y: 0, width: 50, height: 50))
  var cardImage = UIImageView(frame: CGRect(x: 0 , y: 0, width: 194, height: 254))
  var cardBack = UIImageView(frame: CGRect(x: 0 , y: 0, width: 194, height: 254))
  //Required for Player To AI Attack
  var cardIndex: Int = 0
  
  //MARK: - Class Initializers
  override init(frame: CGRect) {
    super.init(frame: frame)
    addUIBehavior(frame: frame)
  }
  
  convenience init() {
    self.init(frame: CGRect.zero)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func addUIBehavior(frame: CGRect) {
    let cardView = UIView(frame: CGRect(origin: .zero, size: frame.size))
    cardView.backgroundColor = UIColor.black
    
    //CARD Back
    cardBack = UIImageView(frame: CGRect(origin: .zero, size: cardView.frame.size))
    cardBack.image = #imageLiteral(resourceName: "cardFlipBG")
    cardView.addSubview(cardBack)
    
    //Card Background Image
    cardImage = UIImageView(frame: CGRect(origin: .zero, size: cardView.frame.size))
    cardView.addSubview(cardImage)
    
    //Battle Points
    bpView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    bpView.backgroundColor = UIColor.blue
    
    bpView.addSubview(bpText)
    
    cardView.addSubview(bpView)
    
    //Attack
    attackView = UIView(frame: CGRect(x: 0, y: 0 + (cardView.frame.size.height) - 50, width: 50, height: 50))
    attackView.backgroundColor = UIColor.init(colorLiteralRed: 0.75, green: 0.12, blue: 0.0078, alpha: 1)
    
    attackView.addSubview(attackText)
    cardView.addSubview(attackView)
    
    //Health
    healthView = UIView(frame: CGRect(x: 0 + (cardView.frame.size.width) - 50, y: 0 + (cardView.frame.size.height) - 50, width: 50, height: 50))
    healthView.backgroundColor = UIColor.init(colorLiteralRed: 0.12, green: 0.75, blue: 0.0078, alpha: 1)
    
    healthView.addSubview(healthText)
    
    cardView.addSubview(healthView)
    
    //Card Name
    nameView = UIView(frame: CGRect(origin: .zero, size: cardView.frame.size))
    nameView.backgroundColor = UIColor.clear
    
    nameText = cardLabel(frame: CGRect(origin: .zero, size: nameView.frame.size))
    
    nameView.addSubview(nameText)
    cardView.addSubview(nameView)
    
    //Card Button
    cardView.addSubview(cardButton)
    
    //BG Color based on canAttack value
    cardView.layer.borderColor = UIColor.red.cgColor
    cardView.layer.borderWidth = 5.0
    
    
    self.addSubview(cardView)
  }
  
  func toggleHidingOfLabelsOnCard(hideStatus: Bool) {
    bpView.isHidden = hideStatus
    healthView.isHidden = hideStatus
    attackView.isHidden = hideStatus
    nameView.isHidden = hideStatus
    cardImage.isHidden = hideStatus
  }
  
  func changeCardState(cardState: CardState) {
    switch cardState {
    case .canAttack:
      layer.borderColor = UIColor.green.cgColor
      break
    case .cannotAttack:
      layer.borderColor = UIColor.red.cgColor
      break
    case .isSelected:
      layer.borderColor = UIColor.blue.cgColor
      break
    case .neutral:
      layer.borderColor = UIColor.yellow.cgColor
      
      break
    }
    layer.borderWidth = 5.0
  }
}

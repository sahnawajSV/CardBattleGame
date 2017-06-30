//
//  CardView.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 19/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

/// This is the actual Card View containing the BattlePoints, Name, Attack and Health Points data
class CardView: UIView {
  //MARK: - Accessor Objects
  var bpText: cardLabel = cardLabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
  var attackText: cardLabel = cardLabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
  var healthText: cardLabel = cardLabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
  var nameText: cardLabel = cardLabel(frame: CGRect(x: 0 , y: 0, width: 194, height: 254))
  var cardButton: UIButton = UIButton(frame: CGRect(x: 0 , y: 0, width: 194, height: 254))
  
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
    let cardView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
    cardView.backgroundColor = UIColor.black
    
    //BATTLE POINT
    let bpView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    bpView.backgroundColor = UIColor.blue
    
    bpView.addSubview(bpText)
    
    cardView.addSubview(bpView)
    
    //ATTACK
    let attackView = UIView(frame: CGRect(x: 0, y: 0 + (cardView.frame.size.height) - 50, width: 50, height: 50))
    attackView.backgroundColor = UIColor.red
    
    attackView.addSubview(attackText)
    cardView.addSubview(attackView)
    
    //HEALTH
    let healthView = UIView(frame: CGRect(x: 0 + (cardView.frame.size.width) - 50, y: 0 + (cardView.frame.size.height) - 50, width: 50, height: 50))
    healthView.backgroundColor = UIColor.green
    
    healthView.addSubview(healthText)
    
    cardView.addSubview(healthView)
    
    //CARD NAME
    let nameView = UIView(frame: CGRect(x: 0 , y: 0, width: (cardView.frame.size.width), height: (cardView.frame.size.height)))
    nameView.backgroundColor = UIColor.clear
    
    nameText = cardLabel(frame: CGRect(x: 0 , y: 0, width: (nameView.frame.size.width), height: (nameView.frame.size.height)))
    
    nameView.addSubview(nameText)
    cardView.addSubview(nameView)
    
    //CARD BUTTON
    cardView.addSubview(cardButton)
    
    
    self.addSubview(cardView)
  }
}

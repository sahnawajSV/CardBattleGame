//
//  Card.swift
//  CardBattleGame
//
//  Created by SAHNAWAJ BISWAS on 16/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//
import Foundation

class Card: NSObject {
  
  var name: String = ""
  var id: Int16 = 0
  var attack: Int16 = 0
  var battlepoint: Int16 = 0
  var health: Int16 = 0
  
  
  init?(dictionary: NSDictionary) {
    
    guard let name = dictionary["name"] as? String,
      let id = Int16((dictionary["id"] as? String)!),
      let attack = Int16((dictionary["attack"] as? String)!),
      let battlepoint = Int16((dictionary["battlepoint"] as? String)!),
      let health = Int16((dictionary["health"] as? String)!) else {
        return nil
    }
    
    self.name = name
    self.id = id
    self.attack = attack
    self.battlepoint = battlepoint
    self.health = health
    
    super.init()
    
  }
  
}

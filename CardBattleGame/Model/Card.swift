//
//  Card.swift
//  CardBattleGame
//
//  Created by SAHNAWAJ BISWAS on 16/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//


/// Card Model class to hold data for every individual class
class Card {
  
  var name: String
  var id: Int16
  var attack: Int16
  var battlepoint: Int16
  var health: Int16
  
  
  init?(dictionary: Dictionary<String, Any>) {
    
    guard let name = dictionary["name"] as? String,
      let id = dictionary["id"] as? Int16,
      let attack = dictionary["attack"]  as? Int16,
      let battlepoint = dictionary["battlepoint"] as? Int16,
      let health = dictionary["health"]  as? Int16 else {
        return nil
    }
    
    self.name = name
    self.id = id
    self.attack = attack
    self.battlepoint = battlepoint
    self.health = health
    
  }
  
}

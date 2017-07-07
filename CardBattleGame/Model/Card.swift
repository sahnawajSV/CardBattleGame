//
//  Card.swift
//  CardBattleGame
//
//  Created by SAHNAWAJ BISWAS on 16/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//


/// Card Model class to hold data for every individual class
struct Card: Equatable {
  
  var name: String
  var id: Int16
  var attack: Int16
  var battlepoint: Int16
  var health: Int16
  var imageName: String
  var canAttack: Bool
  
  init?(dictionary: [String: Any]) {
    
    guard let name = dictionary["name"] as? String,
      let id = dictionary["id"] as? Int16,
      let attack = dictionary["attack"]  as? Int16,
      let battlepoint = dictionary["battlepoint"] as? Int16,
      let health = dictionary["health"]  as? Int16,
      let imageName = dictionary["imageName"]  as? String,
      let canAttack = dictionary["canAttack"]  as? Bool else {
        return nil
    }
    
    self.name = name
    self.id = id
    self.attack = attack
    self.battlepoint = battlepoint
    self.health = health
    self.imageName = imageName
    self.canAttack = canAttack
  }
  
  public static func ==(lhs: Card, rhs: Card) -> Bool {
    if lhs.id == rhs.id {
      return true
    }
    return false
  }
}

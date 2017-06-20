//
//  Card.swift
//  CardBattleGame
//
//  Created by SAHNAWAJ BISWAS on 16/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//
import Foundation

class Card: NSObject {
    
    var name:String?
    var id:String?
    var attack:String?
    var battlepoint:String?
    var health:String?
    

    
    init?(dictionary: NSDictionary) {
        
        guard let name: String = dictionary["name"] as? String else {
            return nil
        }
        
        guard let id: String = dictionary["id"] as? String else {
            return nil
        }
        
        guard let attack: String = dictionary["attack"] as? String else {
            return nil
        }
        
        guard let battlepoint: String = dictionary["battlepoint"] as? String else {
            return nil
        }
        
        guard let health: String = dictionary["health"] as? String else {
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

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
        
        guard let name = dictionary["name"] as? String,
            let id = dictionary["id"] as? String,
            let attack = dictionary["attack"] as? String,
            let battlepoint = dictionary["battlepoint"] as? String,
            let health: String = dictionary["health"] as? String else {
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

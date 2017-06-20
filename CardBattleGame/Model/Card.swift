//
//  Card.swift
//  CardBattleGame
//
//  Created by SAHNAWAJ BISWAS on 16/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//


class Card{
    
    var name:String?
    var id:String?
    var attack:String?
    var battlepoint:String?
    var health:String?
    var canAttack:Bool?
    
    init(name: String, id: String, attack: String, battlepoint: String, health: String, canAttack: Bool) {
        self.name = name
        self.id = id
        self.attack = attack
        self.battlepoint = battlepoint
        self.health = health
        self.canAttack = canAttack
    }
}

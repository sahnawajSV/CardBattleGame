//
//  Game.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 19/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

class Game: NSObject
{
    var inDeck:Array<Card>?
    var inHand:Array<Card>?
    var inPlay:Array<Card>?
    var battlePoints: String?
    var health: String?
    
    init(inDeck: Array<Card>, inHand: Array<Card>, inPlay: Array<Card>, battlePoints: String, health: String) {
        self.inDeck = inDeck
        self.inHand = inHand
        self.inPlay = inPlay
        self.battlePoints = battlePoints
        self.health = health
    }
}

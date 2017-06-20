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
    var inDeck:Array<Card> = Array<Card>()
    var inHand:Array<Card> = Array<Card>()
    var inPlay:Array<Card> = Array<Card>()
    var battlePoints: String = "0"
    var health: String = "100"
    
    init(inDeck: Array<Card>, inHand: Array<Card>, inPlay: Array<Card>, battlePoints: String, health: String) {
        self.inDeck = inDeck
        self.inHand = inHand
        self.inPlay = inPlay
        self.battlePoints = battlePoints
        self.health = health
    }
    
    
    func drawCards(numToDraw : Int)
    {
        var cardsDrawnIndexes = Array<Int>()
        
        for _ in 0...numToDraw-1
        {
            let cardIndex = randomCard(cardCount: inDeck.count)
            cardsDrawnIndexes.append(cardIndex)
        }
        
        var newInDeck: Array<Card> = inDeck
        
        for index in 0...cardsDrawnIndexes.count-1
        {
            let cardIndex = cardsDrawnIndexes[index]
            let card = inDeck[cardIndex]
            if let itemToRemoveIndex = newInDeck.index(where: { (card) -> Bool in
                return true
            })
            {
                newInDeck.remove(at: itemToRemoveIndex)
            }
            
            //Append only if there are 4 or less cards in Hand
            if inHand.count <= 4
            {
                inHand.append(card)
            }
        }
        
        inDeck = newInDeck
    }
    
    func playCard(cardIndex: Int)
    {
        let card : Card = inHand[cardIndex]
        let newBattlePoints = Int(battlePoints)! - Int(card.battlepoint)
        battlePoints = String(describing: newBattlePoints)
        inPlay.append(inHand[cardIndex])
        inHand.remove(at: cardIndex)
    }
    
    
    //Mark: -- Logic Handlers
    func randomCard(cardCount : Int) -> Int
    {
        let randomIndex = arc4random_uniform(UInt32(cardCount))
        return Int(randomIndex)
    }
    
    func incrementBattlePoints()
    {
        var battlePoints : Int = Int(self.battlePoints)!
        if battlePoints < Defaults.maximum_battle_point
        {
            battlePoints = battlePoints + Defaults.battle_point_increment
        }
        
        self.battlePoints = String(battlePoints)
    }

}

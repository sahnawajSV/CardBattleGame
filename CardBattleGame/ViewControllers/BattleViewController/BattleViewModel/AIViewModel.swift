//
//  AIViewModal.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 16/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

class AIViewModel: BattleViewModel
{
    var AIPlayableCards: NSMutableArray? = NSMutableArray();
    
    //Player Field Card Data Variables
    
    
    //Init
    override init()
    {
        super.init()
    }
    
    //Data Methods
    func GetRequiredCardInformation ()
    {
        
    }
    
    //AI Logic
    func FightWithPlayableCards()
    {
        if (AICardsInHand?.count)! < 5
        {
            if (AICardsInHand?.count)! > 0
            {
                AIPlayableCards?.removeAllObjects()
                
                //Adding Cards that can be played from Hand to Play area to the Array
                for (index,_) in (AICardsInHand?.enumerated())!
                {
                    let card : Dictionary<String, Any> = playerCardsInPlay?[index] as! Dictionary<String, Any>
                    let cardBPText : String = card["battlePoint"] as! String
                    let cardBP = Int(cardBPText)
                    
                    if cardBP! > AIBattlePoints
                    {
                        AIPlayableCards?.add(card)
                    }
                }
                
                var highestAttackPower : Int? = 0
                
                //Finding card on Player Play area with the highest attack
                if (playerCardsInPlay?.count)! > 0
                {
                    //Adding Cards that can be played from Hand to Play area to the Array
                    for (index,_) in (playerCardsInPlay?.enumerated())!
                    {
                        let card : Dictionary<String, Any> = playerCardsInPlay?[index] as! Dictionary<String, Any>
                        let attackText : String = card["attack"] as! String
                        let attackValue = Int(attackText)
                        
                        if attackValue! > highestAttackPower!
                        {
                            highestAttackPower = attackValue
                        }
                    }
                }
                
                var AICardIndexToPlay : Int?
                var highesthealth : Int? = 0
                var AIHighestAttackPower : Int? = 0
                
                //Checking for AI Playable Cards in Hand for something that can survive player played cards
                if (AIPlayableCards?.count)! > 0
                {
                    for (index,_) in (AIPlayableCards?.enumerated())!
                    {
                        let card : Dictionary<String, Any> = AIPlayableCards?[index] as! Dictionary<String, Any>
                        let healthText : String = card["health"] as! String
                        let healthValue = Int(healthText)
                        
                        if healthValue! > highestAttackPower!
                        {
                            highesthealth = healthValue
                            AICardIndexToPlay = index
                        }
                        else
                        {
                            let attackText : String = card["attack"] as! String
                            let attackValue = Int(attackText)
                            
                            if attackValue! > AIHighestAttackPower!
                            {
                                AIHighestAttackPower = attackValue
                                AICardIndexToPlay = index
                            }
                        }
                    }
                    
                    if highesthealth! > 0 || AIHighestAttackPower! > 0
                    {
                        PlayCardPressed(cardIndex: AICardIndexToPlay!)
                    }
                    else
                    {
                        //Attack & End Turn
                        AttackPlayer()
                    }
                }
                else
                {
                    //Attack & End Turn
                    AttackPlayer()
                }
            }
        }
        else
        {
            //Attack & End Turn
            AttackPlayer()
        }
    }
    
    
    func AttackPlayer()
    {
        if (AICardsInPlay?.count)! > 0
        {
            var AICardIndexToPlay : Int? = 99
            var PLCardIndexToAttack : Int? = 99
            
            //Checking if AI has a card with more attack and health than a player card in field
            for (index,_) in (AICardsInPlay?.enumerated())!
            {
                let card : Dictionary<String, Any> = AIPlayableCards?[index] as! Dictionary<String, Any>
                let healthText : String = card["health"] as! String
                let healthValue = Int(healthText)
                
                let attackText : String = card["attack"] as! String
                let attackValue = Int(attackText)
                
                for (plIndex,_) in (playerCardsInPlay?.enumerated())!
                {
                    let PLcard : Dictionary<String, Any> = playerCardsInPlay?[plIndex] as! Dictionary<String, Any>
                    let PLattackText : String = PLcard["attack"] as! String
                    let PLattackValue = Int(PLattackText)
                    
                    let PLhealthText : String = PLcard["health"] as! String
                    let PLhealthValue = Int(PLhealthText)
                    
                    if attackValue! > PLattackValue! && healthValue! > PLhealthValue!
                    {
                        AICardIndexToPlay = index
                        PLCardIndexToAttack = plIndex
                        
                        break
                    }
                }
            }
            
            if AICardIndexToPlay! < 5 && PLCardIndexToAttack! < 5
            {
                //Attack Player Cards
                self.delegate?.attackPlayerCard(fromIndex: AICardIndexToPlay!, toIndex: PLCardIndexToAttack!)
            }
            else
            {
                var PLCardIndexToAttack : Int? = 99
                var highestAttackPower : Int? = 0
                var chosenCardHealth : Int? = 0
                
                //Finding card on Player Play area with the highest attack
                if (playerCardsInPlay?.count)! > 0
                {
                    for (index,_) in (playerCardsInPlay?.enumerated())!
                    {
                        let card : Dictionary<String, Any> = playerCardsInPlay?[index] as! Dictionary<String, Any>
                        let attackText : String = card["attack"] as! String
                        let attackValue = Int(attackText)
                        
                        if attackValue! > highestAttackPower!
                        {
                            let healthText : String = card["health"] as! String
                            let healthValue = Int(healthText)
                            
                            highestAttackPower = attackValue
                            chosenCardHealth = healthValue
                            PLCardIndexToAttack = index
                        }
                    }
                }
                
                //Finding the card with more attack than that card
                var AICardIndexToPlay : Int?
                var AIHigherAttack : Int? = 0
                
                //Checking for AI Playable Cards in Hand for something that can survive player played cards
                if (AIPlayableCards?.count)! > 0
                {
                    for (index,_) in (AIPlayableCards?.enumerated())!
                    {
                        let card : Dictionary<String, Any> = AIPlayableCards?[index] as! Dictionary<String, Any>
                        let attackText : String = card["attack"] as! String
                        let attackValue = Int(attackText)
                        
                        if attackValue! > chosenCardHealth!
                        {
                            AIHigherAttack = attackValue
                            AICardIndexToPlay = index
                        }
                    }
                    
                    if AIHigherAttack! > 0
                    {
                        //Attack Player Cards
                        self.delegate?.attackPlayerCard(fromIndex: AICardIndexToPlay!, toIndex: PLCardIndexToAttack!)
                    }
                    else
                    {
                        //Attack Player Avatar Directly
                        for (index,_) in (AIPlayableCards?.enumerated())!
                        {
                            self.delegate?.attackPlayerAvatar(fromIndex: index)
                        }
                    }
                    
                    // End Turn
                    endTurnPressed()
                }
                else
                {
                    // End Turn
                    endTurnPressed()
                }
            }
        }
        else
        {
            //End Turn
            endTurnPressed()
        }
    }
}


/*
 *Check if AI Play Area already has 5 cards,
 if Yes, attack with one of those. Once all attacks are over, check if AI Play Area still has 5 Cards. If yes, end turn
 
 *if No, check if AI has any playable card based on BP
    if yes, collect its list, check all cards on Player Play Area, compare it and check if any of AI playable cards has more health than the highest atk of player cards. If yes, play that. else, check if one of your card has higher attack power than the highest health in player played cards. If yes, play that. Else play the card with the highest health by default.
 
 *if no, end turn.
 
 *Attack Pattern:
 *Check if player has played cards, collect the list, check if any of your card has more attack than a players cards health and check if the same card has more health than the player card attack. If yes, destroy the player card.
 *Still have attack cards left?
    Find the highest attack power card on player side, check if you have a playable card with more attack power than the health of that card. If yes, use it to destroy it.
 *Still have cards left?
    Hit the player in the FACE!
 
 */

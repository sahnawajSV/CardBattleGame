//
//  BattleViewModel.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 14/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

protocol BattleProtocol
{
    weak var delegate: BattleProtocolDelegate? { get set }
    
    var playerName: String? { get }
    var playerHealth: String? { get }
    var playerBattlePoints: Int! { get }
    var playerBattlePointsText: String? { get }
    var playerNumCardsInDeck: String? { get }
    var playerCardsInDeck: NSMutableArray? { get }
    var playerCardsInHand: NSMutableArray? { get }
    var playerCardsInPlay: NSMutableArray? { get }
    
    var AIName: String? { get }
    var AIHealth: String? { get }
    var AIBattlePoints: Int! { get }
    var AIBattlePointsText: String? { get }
    var AINumCardsInDeck: String? { get }
    var AICardsInDeck: NSMutableArray? { get }
    var AICardsInHand: NSMutableArray? { get }
    var AICardsInPlay: NSMutableArray? { get }
    
    var playerHandStartRect : CGRect? { get }
    var playerHandGap : Int! { get }
    var playerGameAreaStartRect : CGRect? { get }
    var playerGameAreaGap : Int! { get }
    
    var AIHandStartRect : CGRect? { get }
    var AIHandGap : Int! { get }
    var AIGameAreaStartRect : CGRect? { get }
    var AIGameAreaGap : Int! { get }
    
    func endTurnPressed()
    func PlayCardPressed(cardIndex : Int)
    func PerformCardToAvatarAttackAnimation(cardView : UIView, toView : UIView, cardIndex: Int)
    func PerformCardToCardAttackAnimation(cardView : UIView, toView : UIView, attackCardIndex: Int, defendCardIndex: Int)
    func PerformBackToPlaceAnimation(cardView : UIView, toFrame : CGRect)
}

protocol BattleProtocolDelegate: class
{
//    func CardDrawn(forPlayer : Bool)
//    func CardPlayed(byPlayer : Bool)
    func reloadAllViewData()
    func attackPlayerCard(fromIndex : Int, toIndex : Int)
    func attackPlayerAvatar(fromIndex : Int)
}

class BattleViewModel: BattleProtocol
{
    weak var delegate: BattleProtocolDelegate?
    
    var AILogic : AIViewModel?
    
    var playerName: String? = "Player Name"
    var playerHealth: String? = "100"
    var playerBattlePoints: Int! = 0
    var playerBattlePointsText: String?
    var playerCardsInDeck: NSMutableArray? = NSMutableArray();
    var playerCardsInHand: NSMutableArray? = NSMutableArray();
    var playerCardsInPlay: NSMutableArray? = NSMutableArray();
    var playerNumCardsInDeck: String?
    
    var AIName: String? = "AI Name"
    var AIHealth: String? = "100"
    var AIBattlePoints: Int! = 0
    var AIBattlePointsText: String?
    var AICardsInDeck: NSMutableArray? = NSMutableArray();
    var AICardsInHand: NSMutableArray? = NSMutableArray();
    var AICardsInPlay: NSMutableArray? = NSMutableArray();
    var AINumCardsInDeck: String?
    
    var playerHandStartRect : CGRect?
    var playerHandGap : Int!
    var playerGameAreaStartRect : CGRect?
    var playerGameAreaGap : Int!
    
    var AIHandStartRect : CGRect?
    var AIHandGap : Int!
    var AIGameAreaStartRect : CGRect?
    var AIGameAreaGap : Int!
    
    var originalCardViewFrame : CGRect?
    
    //MARK: Game Variables
    var isPlayerTurn: Bool? = false
    
    //MARK: Initialization
    func initializeTheGame()
    {
        //Adding Player Cards
        for i in 0...19
        {
            let attackValue = randomIntFrom(start: 1, to: 10)
            let healthValue = randomIntFrom(start: 1, to: 10)
            let bpValue = randomIntFrom(start: 1, to: 10)
            let populatedDictionary = ["id": "\(i)", "name": "Name_\(i)", "attack": "\(attackValue)", "health": "\(healthValue)", "battlePoint": "\(bpValue)"]
            
            playerCardsInDeck?.add(populatedDictionary)
        }
        
        //Adding AI Cards
        for i in 0...19
        {
            let attackValue = randomIntFrom(start: 1, to: 10)
            let healthValue = randomIntFrom(start: 1, to: 10)
            let bpValue = randomIntFrom(start: 1, to: 10)
            let populatedDictionary = ["id": "\(i)", "name": "Name_\(i)", "attack": "\(attackValue)", "health": "\(healthValue)", "battlePoint": "\(bpValue)"]
            
            AICardsInDeck?.add(populatedDictionary)
        }
        
        //TEMPORARY - Adding a card to play for the AI
        let tempDict = randomCard(myArray: AICardsInDeck!)
        AICardsInPlay?.add(tempDict)
        
        drawInitialCards()
        setCardInHandRects()
        setCardInPlayRects()
        calculateBattlePointInformation()
        calculateCardInformation()
        endTurnPressed()
    }
    
    func drawInitialCards()
    {
        //Adding Player Cards from Deck to Hand
        for _ in 0...2
        {
            let cardDictionary = randomCard(myArray: playerCardsInDeck!)
            playerCardsInHand?.add(cardDictionary)
        }
        
        //Adding AI Cards from Deck to Hand
        for _ in 0...2
        {
            let cardDictionary = randomCard(myArray: AICardsInDeck!)
            AICardsInHand?.add(cardDictionary)
        }
    }
    
    func setCardInHandRects()
    {
        playerHandStartRect = CGRect(x: 286, y: 0, width: 194, height: 254)
        playerHandGap = 8;
        AIHandStartRect = CGRect(x: 286, y: -80, width: 194, height: 254)
        AIHandGap = 8;
    }
    
    func setCardInPlayRects()
    {
        playerGameAreaStartRect = CGRect(x: 488, y: 552, width: 194, height: 254)
        playerGameAreaGap = 8;
        AIGameAreaStartRect = CGRect(x: 488, y: 217, width: 194, height: 254)
        AIGameAreaGap = 8;
    }
    
    func calculateBattlePointInformation()
    {
        playerBattlePointsText = "\(String(describing: playerBattlePoints!)) / 10 BP"
        AIBattlePointsText = "\(String(describing: AIBattlePoints!)) / 10 BP"
    }
    
    func calculateCardInformation()
    {
        playerNumCardsInDeck = "\(String(describing: playerCardsInDeck!.count)) / 20 Cards"
        AINumCardsInDeck = "\(String(describing: AICardsInDeck!.count)) / 20 Cards"
    }
    
    //MARK: Gameplay Methods
    
    func endTurnPressed()
    {
        if isPlayerTurn!
        {
            AITurnStart()
        }
        else
        {
            playerTurnStart()
        }
    }
    
    func playerTurnStart()
    {
        isPlayerTurn = true
        
        //Battle Points
        incrementBattlePoints()
        
        //Draw a Card
        let cardDrawn : Dictionary<String, Any> = DrawCard(forPlayer: true)
        if cardDrawn.count > 0
        {
            playerCardsInHand?.add(cardDrawn)
        }
        
        calculateCardInHandRects()
        calculateCardInformation()
    }
    
    func AITurnStart()
    {
        isPlayerTurn = false
        
        //Battle Points
        incrementBattlePoints()
        
        //Draw a Card
        let cardDrawn : Dictionary<String, Any>  = DrawCard(forPlayer: false)
        if cardDrawn.count > 0
        {
            AICardsInHand?.add(cardDrawn)
        }
        
        calculateCardInHandRects()
        calculateCardInformation()
        
        if AILogic == nil
        {
            AILogic = AIViewModel()
        }
        
        AILogic?.FightWithPlayableCards()
    }
    
    func PlayCardPressed(cardIndex : Int)
    {
        let playedCard : Dictionary<String, Any> = PlayCard(cardIndex: cardIndex)
        
        if isPlayerTurn!
        {
            if playedCard.count > 0
            {
                playerCardsInPlay?.add(playedCard)
            }
        }
        else
        {
            if playedCard.count > 0
            {
                AICardsInPlay?.add(playedCard)
            }
        }
        
        calculateCardInHandRects()
        calculateCardInPlayRects()
        calculateBattlePointInformation()
    }
    
    func PlayCard (cardIndex : Int) -> Dictionary<String, Any>
    {
        if isPlayerTurn!
        {
            let cardInfoDict : Dictionary<String, Any> = playerCardsInHand?[cardIndex] as! Dictionary<String, Any>
            let requiredBattlePointsText : String = cardInfoDict["battlePoint"] as! String
            let requiredBattlePoints = Int(requiredBattlePointsText)
            
            if (playerCardsInPlay?.count)! < 5 && requiredBattlePoints! <= playerBattlePoints
            {
                playerBattlePoints = playerBattlePoints - requiredBattlePoints!
                let playedCard : Dictionary<String, Any> = playerCardsInHand?[cardIndex] as! Dictionary<String, Any>
                playerCardsInHand?.removeObject(at: cardIndex)
                return playedCard
            }
        }
        else
        {
            let cardInfoDict : Dictionary<String, Any> = AICardsInHand?[cardIndex] as! Dictionary<String, Any>
            let requiredBattlePointsText : String = cardInfoDict["battlePoint"] as! String
            let requiredBattlePoints = Int(requiredBattlePointsText)
            
            if (AICardsInPlay?.count)! < 5 && requiredBattlePoints! <= AIBattlePoints
            {
                AIBattlePoints = AIBattlePoints - requiredBattlePoints!
                let playedCard : Dictionary<String, Any> = AICardsInHand?[cardIndex] as! Dictionary<String, Any>
                AICardsInHand?.removeObject(at: cardIndex)
                return playedCard
            }
        }
        
        let playedCard = [String: Any]()
        return playedCard
    }
    
    func AttackAvatar(cardIndex : Int)
    {
        if isPlayerTurn!
        {
            let attackCard : Dictionary<String, Any> = playerCardsInPlay?[cardIndex] as! Dictionary<String, Any>
            let attackValueText : String = attackCard["attack"] as! String
            let attackValue = Int(attackValueText)
            
            let AIHealthText : String = AIHealth!
            var AIHealthValue = Int(AIHealthText)
            
            AIHealthValue = AIHealthValue! - attackValue!
            
            AIHealth = String(describing: AIHealthValue!)
        }
        else
        {
            let attackCard : Dictionary<String, Any> = AICardsInPlay?[cardIndex] as! Dictionary<String, Any>
            let attackValueText : String = attackCard["attack"] as! String
            let attackValue = Int(attackValueText)
            
            let playerHeathText : String = playerHealth!
            var playerHealthValue = Int(playerHeathText)
            
            playerHealthValue = playerHealthValue! - attackValue!
            
            playerHealth = String(describing: playerHealthValue!)
        }
    }
    
    func AttackCard(attackCardIndex : Int, defenceCardIndex : Int)
    {
        var attackIndex = attackCardIndex
        var defenceIndex = defenceCardIndex
        if !isPlayerTurn!
        {
            let temp = attackIndex
            attackIndex = defenceIndex
            defenceIndex = temp
        }
        
        var shouldRemoveAICard : Bool = false
        var shouldRemovePLCard : Bool = false
        
        let attackCard : Dictionary<String, Any> = playerCardsInPlay?[attackIndex] as! Dictionary<String, Any>
        let attackValueText : String = attackCard["attack"] as! String
        let attackValue = Int(attackValueText)
        
        var defenceCard : Dictionary<String, Any> = AICardsInPlay?[defenceIndex] as! Dictionary<String, Any>
        let defenceValueText : String = defenceCard["health"] as! String
        var defenceValue = Int(defenceValueText)
        
        defenceValue = defenceValue! - attackValue!
        
        if defenceValue! <= 0
        {
            shouldRemoveAICard = true
        }
        else
        {
            defenceCard["health"] = String(describing: defenceValue!)
            AICardsInPlay?.replaceObject(at: defenceIndex, with: defenceCard)
        }
        
        let AIattackCard = AICardsInPlay?[attackIndex] as! Dictionary<String, Any>
        let AIattackValueText = AIattackCard["attack"] as! String
        let AIattackValue = Int(AIattackValueText)
        
        var PLdefenceCard = playerCardsInPlay?[defenceIndex] as! Dictionary<String, Any>
        let PLdefenceValueText = PLdefenceCard["health"] as! String
        var PLdefenceValue = Int(PLdefenceValueText)
        
        PLdefenceValue = PLdefenceValue! - AIattackValue!
        
        if PLdefenceValue! <= 0
        {
            shouldRemovePLCard = true
        }
        else
        {
            PLdefenceCard["health"] = String(describing: defenceValue!)
            playerCardsInPlay?.replaceObject(at: attackIndex, with: PLdefenceCard)
        }
        
        if shouldRemoveAICard
        {
            AICardsInPlay?.removeObject(at: defenceIndex)
        }
        
        if shouldRemovePLCard
        {
            playerCardsInPlay?.removeObject(at: attackIndex)
        }
    }
    
    func PerformCardToAvatarAttackAnimation(cardView : UIView, toView : UIView, cardIndex: Int)
    {
        var y : CGFloat?
        var chargeY : CGFloat?
        var fallbackY : CGFloat?
        
        if isPlayerTurn!
        {
            y = toView.frame.origin.y + toView.frame.size.height + 100
            chargeY = toView.frame.origin.y + (toView.frame.size.height / 2)
            fallbackY = toView.frame.origin.y + toView.frame.size.height + 30
        }
        else
        {
            y = toView.frame.origin.y - 100
            chargeY = toView.frame.origin.y - (toView.frame.size.height / 2)
            fallbackY = toView.frame.origin.y - 30
        }
        
        //Move Back
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations:
        {
            cardView.frame = CGRect(x: toView.frame.origin.x +  ((toView.frame.size.width - cardView.frame.size.width) / 2), y: y!, width: (cardView.frame.size.width), height: (cardView.frame.size.height))
        }, completion: { (finished: Bool) in
            //Charge
            UIView.animate(withDuration: 0.20, delay: 0.0, options: [], animations:
            {
                    cardView.frame = CGRect(x: toView.frame.origin.x + ((toView.frame.size.width - cardView.frame.size.width) / 2), y: chargeY!, width: (cardView.frame.size.width), height: (cardView.frame.size.height))
            }, completion: { (finished: Bool) in
                //Fall a little after attack
                UIView.animate(withDuration: 0.10, delay: 0.0, options: [], animations:
                    {
                        cardView.frame = CGRect(x: toView.frame.origin.x + ((toView.frame.size.width - cardView.frame.size.width) / 2), y: fallbackY!, width: (cardView.frame.size.width), height: (cardView.frame.size.height))
                }, completion: { (finished: Bool) in
                    self.AttackAvatar(cardIndex: cardIndex)
                    self.PerformBackToPlaceAnimation(cardView: cardView, toFrame: self.originalCardViewFrame!)
                })
            })
        })
    }
    
    func PerformCardToCardAttackAnimation(cardView : UIView, toView : UIView, attackCardIndex: Int, defendCardIndex: Int)
    {
        var y : CGFloat?
        var chargeY : CGFloat?
        var fallbackY : CGFloat?
        
        if isPlayerTurn!
        {
            y = toView.frame.origin.y + toView.frame.size.height + 100
            chargeY = toView.frame.origin.y + (toView.frame.size.height / 2)
            fallbackY = toView.frame.origin.y + toView.frame.size.height + 30
        }
        else
        {
            y = toView.frame.origin.y - 100
            chargeY = toView.frame.origin.y - (toView.frame.size.height / 2)
            fallbackY = toView.frame.origin.y - 30
        }
        
        //Move Back
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations:
            {
                cardView.frame = CGRect(x: toView.frame.origin.x +  ((toView.frame.size.width - cardView.frame.size.width) / 2), y: y!, width: (cardView.frame.size.width), height: (cardView.frame.size.height))
        }, completion: { (finished: Bool) in
            //Charge
            UIView.animate(withDuration: 0.20, delay: 0.0, options: [], animations:
                {
                    cardView.frame = CGRect(x: toView.frame.origin.x + ((toView.frame.size.width - cardView.frame.size.width) / 2), y: chargeY!, width: (cardView.frame.size.width), height: (cardView.frame.size.height))
            }, completion: { (finished: Bool) in
                //Fall a little after attack
                UIView.animate(withDuration: 0.10, delay: 0.0, options: [], animations:
                {
                        cardView.frame = CGRect(x: toView.frame.origin.x + ((toView.frame.size.width - cardView.frame.size.width) / 2), y: fallbackY!, width: (cardView.frame.size.width), height: (cardView.frame.size.height))
                }, completion: { (finished: Bool) in
                    self.AttackCard(attackCardIndex: attackCardIndex, defenceCardIndex: defendCardIndex)
                    self.PerformBackToPlaceAnimation(cardView: cardView, toFrame: self.originalCardViewFrame!)
                })
            })
        })
    }

    
    func PerformBackToPlaceAnimation(cardView : UIView, toFrame : CGRect)
    {
        //Go back to original position
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations:
            {
                cardView.frame = toFrame
                self.delegate?.reloadAllViewData()
        }, completion: { (finished: Bool) in
            
        })
    }
    
    
    //MARK: Utility Methods
    func numberOfObjectsInPlayerDeck() -> Int
    {
        return playerCardsInDeck!.count
    }
    
    func numberOfObjectsInAIDeck() -> Int
    {
        return AICardsInDeck!.count
    }
    
    func randomIntFrom(start: Int, to end: Int) -> Int
    {
        var a = start
        var b = end
        // swap to prevent negative integer crashes
        if a > b {
            swap(&a, &b)
        }
        return Int(arc4random_uniform(UInt32(b - a + 1))) + a
    }
    
    func randomCard(myArray : NSMutableArray) -> Dictionary<String, Any>
    {
        let randomIndex = arc4random_uniform(UInt32(myArray.count))
        let randomCard : Dictionary<String, Any> = myArray[randomIndex.hashValue] as! Dictionary<String, Any>
        
        myArray.removeObject(at: randomIndex.hashValue)
        
        return randomCard
    }
    
    func incrementBattlePoints()
    {
        if isPlayerTurn!
        {
            if playerBattlePoints! < 10
            {
                playerBattlePoints = playerBattlePoints! + 1
            }
        }
        else
        {
            if AIBattlePoints! < 10
            {
                AIBattlePoints = AIBattlePoints! + 1
            }
        }
        
        calculateBattlePointInformation()
    }
    
    func DrawCard (forPlayer : Bool) -> Dictionary<String, Any>
    {
        if forPlayer
        {
            if (playerCardsInDeck?.count)! > 0
            {
                var drawnCard : Dictionary<String, Any> = playerCardsInDeck?.lastObject as! Dictionary<String, Any>
                playerCardsInDeck?.removeLastObject()
                
                if (playerCardsInHand?.count)! > 4
                {
                    drawnCard = [String: Any]()
                    return drawnCard
                }
                
                return drawnCard
            }
        }
        else
        {
            if (AICardsInDeck?.count)! > 0
            {
                var drawnCard : Dictionary<String, Any> = AICardsInDeck?.lastObject as! Dictionary<String, Any>
                AICardsInDeck?.removeLastObject()
                
                if (AICardsInHand?.count)! > 4
                {
                    drawnCard = [String: Any]()
                    return drawnCard
                }
                
                return drawnCard
            }
        }
        
        let drawnCard = [String: Any]()
        return drawnCard 
    }
    
    func calculateCardInHandRects()
    {
        if isPlayerTurn!
        {
            if (playerCardsInHand?.count)! <= 1
            {
                playerHandStartRect = CGRect(x: 488, y: 0, width: 194, height: 254)
                playerHandGap = 8;
            }
            else if (playerCardsInHand?.count)! == 2
            {
                playerHandStartRect = CGRect(x: 387, y: 0, width: 194, height: 254)
                playerHandGap = 8;
            }
            else if (playerCardsInHand?.count)! == 3
            {
                playerHandStartRect = CGRect(x: 286, y: 0, width: 194, height: 254)
                playerHandGap = 8;
            }
            else if (playerCardsInHand?.count)! == 4
            {
                playerHandStartRect = CGRect(x: 185, y: 0, width: 194, height: 254)
                playerHandGap = 8;
            }
            else if (playerCardsInHand?.count)! == 5
            {
                playerHandStartRect = CGRect(x: 84, y: 0, width: 194, height: 254)
                playerHandGap = 8;
            }
        }
        else
        {
            if (AICardsInHand?.count)! <= 1
            {
                AIHandStartRect = CGRect(x: 488, y: -80, width: 194, height: 254)
                AIHandGap = 8;
            }
            else if (AICardsInHand?.count)! == 2
            {
                AIHandStartRect = CGRect(x: 387, y: -80, width: 194, height: 254)
                AIHandGap = 8;
            }
            else if (AICardsInHand?.count)! == 3
            {
                AIHandStartRect = CGRect(x: 286, y: -80, width: 194, height: 254)
                AIHandGap = 8;
            }
            else if (AICardsInHand?.count)! == 4
            {
                AIHandStartRect = CGRect(x: 185, y: -80, width: 194, height: 254)
                AIHandGap = 8;
            }
            else if (AICardsInHand?.count)! == 5
            {
                AIHandStartRect = CGRect(x: 84, y: -80, width: 194, height: 254)
                AIHandGap = 8;
            }

        }
    }
    
    func calculateCardInPlayRects()
    {
        if isPlayerTurn!
        {
            if (playerCardsInPlay?.count)! <= 1
            {
                playerGameAreaStartRect = CGRect(x: 488, y: 552, width: 194, height: 254)
                playerGameAreaGap = 8;
            }
            else if (playerCardsInPlay?.count)! == 2
            {
                playerGameAreaStartRect = CGRect(x: 387, y: 552, width: 194, height: 254)
                playerGameAreaGap = 8;
            }
            else if (playerCardsInPlay?.count)! == 3
            {
                playerGameAreaStartRect = CGRect(x: 286, y: 552, width: 194, height: 254)
                playerGameAreaGap = 8;
            }
            else if (playerCardsInPlay?.count)! == 4
            {
                playerGameAreaStartRect = CGRect(x: 185, y: 552, width: 194, height: 254)
                playerGameAreaGap = 8;
            }
            else if (playerCardsInPlay?.count)! == 5
            {
                playerGameAreaStartRect = CGRect(x: 84, y: 552, width: 194, height: 254)
                playerGameAreaGap = 8;
            }
        }
        else
        {
            if (AICardsInPlay?.count)! <= 1
            {
                AIGameAreaStartRect = CGRect(x: 488, y: 217, width: 194, height: 254)
                AIGameAreaGap = 8;
            }
            else if (AICardsInPlay?.count)! == 2
            {
                AIGameAreaStartRect = CGRect(x: 387, y: 217, width: 194, height: 254)
                AIGameAreaGap = 8;
            }
            else if (AICardsInPlay?.count)! == 3
            {
                AIGameAreaStartRect = CGRect(x: 286, y: 217, width: 194, height: 254)
                AIGameAreaGap = 8;
            }
            else if (AICardsInPlay?.count)! == 4
            {
                AIGameAreaStartRect = CGRect(x: 185, y: 217, width: 194, height: 254)
                AIHandGap = 8;
            }
            else if (AICardsInPlay?.count)! == 5
            {
                AIGameAreaStartRect = CGRect(x: 84, y: 217, width: 194, height: 254)
                AIGameAreaGap = 8;
            }

        }
    }
}

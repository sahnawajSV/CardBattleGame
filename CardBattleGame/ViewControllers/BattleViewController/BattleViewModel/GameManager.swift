//
//  GameManager.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 19/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

protocol GameProtocol
{
    weak var delegate: GameDelegate? { get set }
}

protocol GameDelegate: class
{
    func initializationStatus(success : Bool)
    func reloadAllViews()
}


class GameManager: GameProtocol
{
    weak var delegate: GameDelegate?
    //Mark: - View Model
    var viewModel = BattleSystemViewModel()
    
    //MARK: - Model Handlers
    var playerStats: Stats?
    var aiStats: Stats?
    
    //Mark: - Common Utility Method Handler
    var common = Common()
    
    //Mark: - Game Handlers
    var isPlayerTurn: Bool = true
    
    //MARK: - Game Initialization
    func initializeTheGame()
    {
        let globalCardData = CardListDataSource()
        let cardList = globalCardData.fetchCardList()
        
        var pl_CardArray : Array<Card> = Array<Card>()
        var ai_CardArray : Array<Card>  = Array<Card>()
        
        //Adding Player Cards
        for i in 0...(cardList.count-1)
        {
            let card : Card = cardList[i]
            
            pl_CardArray.append(card)
        
            //TODO: TEMP - Create AI Card List based on Player Card Strength
            ai_CardArray.append(card)
        }
        
        let playerDeckList = Deck(name: "Deck_1", id: "1", cardList: pl_CardArray)
        let aiDeckList = Deck(name: "Deck_1", id: "1", cardList: ai_CardArray)
        
        //EMPTY - for Card Drawn or Played
        let emptyArray = Array<Card>()
        
        //TODO: Change it based on deck selected for play before the game starts
        playerStats = Stats(name: "Player", id: "1", deckList: [playerDeckList], gameStats: Game(inDeck: playerDeckList.cardList!, inHand: emptyArray, inPlay: emptyArray, battlePoints: String(Defaults.BATTLE_POINTS), health: String(Defaults.HEALTH)))
        aiStats = Stats(name: "AI", id: "2", deckList: [aiDeckList], gameStats: Game(inDeck: aiDeckList.cardList!, inHand: emptyArray, inPlay: emptyArray, battlePoints: String(Defaults.BATTLE_POINTS), health: String(Defaults.HEALTH)))
        
        //Pass the message to ViewController - To check if initialization was a success or failure
        if (playerDeckList.cardList?.count)! > 5 && (aiDeckList.cardList?.count)! > 5 && (playerStats != nil) && (aiStats != nil)
        {
            tellDelegateToCheckForInitialization(success: true)
        }
        else
        {
            tellDelegateToCheckForInitialization(success: false)
        }
    }
    
    //Draw initial cards from deck
    func drawCardsFromDeck()
    {
        drawPlayerCards(numToDraw: Defaults.NUM_OF_CARDS_TO_DRAW_INITIALLY)
        drawAICards(numToDraw: Defaults.NUM_OF_CARDS_TO_DRAW_INITIALLY)
    }
    
    func drawPlayerCards(numToDraw: Int)
    {
        if (playerStats?.gameStats?.inDeck?.count)! > 0
        {
            var cardsDrawnIndex: Array<Int> = viewModel.drawCards(cardCount: (playerStats?.gameStats?.inDeck?.count)!, numToDraw: numToDraw)
            var newInDeck: Array<Card> = (playerStats?.gameStats?.inDeck)!
            
            for index in 0...cardsDrawnIndex.count-1
            {
                let cardIndex = cardsDrawnIndex[index]
                let card = playerStats?.gameStats?.inDeck?[cardIndex]
                if let itemToRemoveIndex = newInDeck.index(where: { (card) -> Bool in
                    return true
                })
                {
                    newInDeck.remove(at: itemToRemoveIndex)
                }
                
                //Append only if there are 4 or less cards in Hand
                if (playerStats?.gameStats?.inHand?.count)! <= 4
                {
                    playerStats?.gameStats?.inHand?.append(card!)
                }
            }

            playerStats?.gameStats?.inDeck = newInDeck
        }
        else
        {
            //HURT ACTIVE PLAYER
        }
    }
    
    func drawAICards(numToDraw: Int)
    {
        if (aiStats?.gameStats?.inDeck?.count)! > 0
        {
            var cardsDrawnIndex = viewModel.drawCards(cardCount: (aiStats?.gameStats?.inDeck?.count)!, numToDraw: numToDraw)
            var newInDeck: Array<Card> = (aiStats?.gameStats?.inDeck)!
            
            for index in 0...cardsDrawnIndex.count-1
            {
                let cardIndex = cardsDrawnIndex[index]
                let card = aiStats?.gameStats?.inDeck?[cardIndex]
                if let itemToRemoveIndex = newInDeck.index(where: { (card) -> Bool in
                    return true
                })
                {
                    newInDeck.remove(at: itemToRemoveIndex)
                }
                aiStats?.gameStats?.inHand?.append(card!)
            }
            
            aiStats?.gameStats?.inDeck = newInDeck
        }
        else
        {
            //HURT THE ACTIVE AI
        }
    }
    
    func endTurn()
    {
        if isPlayerTurn
        {
            isPlayerTurn = false
            aiTurnStart()
        }
        else
        {
            isPlayerTurn = true
            playerTurnStart()
        }
    }
    
    //Mark: Turn Logic
    func aiTurnStart()
    {
        //increment Battle Point Per Turn
        aiStats = viewModel.incrementBattlePoints(stats: aiStats!)
        
        //Draw a Card
        drawAICards(numToDraw: Defaults.NUM_OF_CARDS_TO_DRAW_EACH_TURN)
        
        tellDelegateToReloadViewData()
    }
    
    func playerTurnStart()
    {
        //increment Battle Point Per Turn
        playerStats = viewModel.incrementBattlePoints(stats: playerStats!)
        
        //Draw a Card
        drawPlayerCards(numToDraw: Defaults.NUM_OF_CARDS_TO_DRAW_EACH_TURN)
        
        tellDelegateToReloadViewData()
    }
    
    //MARK: Animations
    func playCardToGameArea(cardView : UIView, toFrame : CGRect, cardIndex: Int, forPlayer: Bool)
    {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations:
        {
                cardView.frame = toFrame
        }, completion: { (finished: Bool) in
            //Remove From InHand and Add to InPlay
            if forPlayer
            {
                self.playerStats = self.viewModel.playCard(stats: self.playerStats!, cardIndex: cardIndex)
            }
            else
            {
                self.aiStats = self.viewModel.playCard(stats: self.aiStats!, cardIndex: cardIndex)
            }
        })
    }
    
    //MARK: Delegates
    //Pass the message to ViewController to display required Data
    func tellDelegateToReloadViewData()
    {
        delegate?.reloadAllViews()
    }
    
    //Pass the message to ViewController - To check if initialization was a success or failure
    func tellDelegateToCheckForInitialization(success: Bool)
    {
        delegate?.initializationStatus(success: success)
    }

}

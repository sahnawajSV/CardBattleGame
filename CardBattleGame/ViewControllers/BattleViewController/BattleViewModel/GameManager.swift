//
//  GameManager.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 19/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

class GameManager: NSObject {
  //MARK: - Model Handlers
  var playerStats: Stats!
  var aiStats: Stats!
  
  //Mark: - Game Handlers
  var isPlayerTurn: Bool = true
  
  //MARK: - Game Initialization
  func initializeTheGame() -> Bool {
    let globalCardData = CardListDataSource()
    let cardList = globalCardData.fetchCardList()
    
    var pl_CardArray: [Card] = []
    var ai_CardArray: [Card]  = []
    
    //Adding Player Cards
    for i in 0...(cardList.count-1) {
      let card: Card = cardList[i]
      
      pl_CardArray.append(card)
      
      //TODO: TEMP - Create AI Card List based on Player Card Strength
      ai_CardArray.append(card)
    }
    
    let playerDeckList = Deck(name: "Deck_1", id: "1", cardList: pl_CardArray)
    let aiDeckList = Deck(name: "Deck_1", id: "1", cardList: ai_CardArray)
    
    //EMPTY - for Card Drawn or Played
    let emptyArray: [Card] = []
    
    //TODO: Change it based on deck selected for play before the game starts
    playerStats = Stats(name: "Player", id: "1", deckList: [playerDeckList], gameStats: Game(inDeck: playerDeckList.cardList, inHand: emptyArray, inPlay: emptyArray, battlePoints: String(Defaults.battle_points), health: String(Defaults.health)))
    aiStats = Stats(name: "AI", id: "2", deckList: [aiDeckList], gameStats: Game(inDeck: aiDeckList.cardList, inHand: emptyArray, inPlay: emptyArray, battlePoints: String(Defaults.battle_points), health: String(Defaults.health)))
    
    //Pass the message to ViewController - To check if initialization was a success or failure
    if (playerDeckList.cardList.count) > 5 && (aiDeckList.cardList.count) > 5 {
      return true
    } else {
      return false
    }
  }
  
  //Draw initial cards from deck
  func drawCardsFromDeck() {
    drawPlayerCards(numToDraw: Defaults.num_of_cards_to_draw_initially)
    drawAICards(numToDraw: Defaults.num_of_cards_to_draw_initially)
  }
  
  func drawPlayerCards(numToDraw: Int) {
    if (playerStats.gameStats.inDeck.count) > 0 {
      playerStats.gameStats.drawCards(numToDraw: numToDraw)
      
    } else {
      //HURT PLAYER
    }
  }
  
  func drawAICards(numToDraw: Int) {
    if (aiStats.gameStats.inDeck.count) > 0 {
      aiStats.gameStats.drawCards(numToDraw: numToDraw)
    } else {
      //HURT AI
    }
  }
  
  func endTurn() -> Bool {
    if isPlayerTurn {
      isPlayerTurn = false
      return aiTurnStart()
    } else {
      isPlayerTurn = true
      return playerTurnStart()
    }
  }
  
  //Mark: Turn Logic
  func aiTurnStart() -> Bool {
    //increment Battle Point Per Turn
    aiStats.gameStats.incrementBattlePoints()
    
    //Draw a Card
    drawAICards(numToDraw: Defaults.num_of_cards_to_draw_each_turn)
    
    return true
  }
  
  func playerTurnStart() -> Bool {
    //increment Battle Point Per Turn
    playerStats.gameStats.incrementBattlePoints()
    
    //Draw a Card
    drawPlayerCards(numToDraw: Defaults.num_of_cards_to_draw_each_turn)
    
    return true
  }
  
  //MARK: Animations
  func playCardToGameArea(cardIndex: Int, forPlayer: Bool) {
    //Remove From InHand and Add to InPlay
    if forPlayer {
      self.playerStats.gameStats.playCard(cardIndex: cardIndex)
    } else {
      self.aiStats.gameStats.playCard(cardIndex: cardIndex)
    }
  }
}

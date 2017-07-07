//
//  BattleManager.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 07/07/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

class BattleManager {
  //MARK: - Model Handlers
  var playerOneStats: Stats
  var playerTwoStats: Stats
  
  //Mark: - Game Handlers
  var isPlayerTurn: Bool = true
  
  //MARK: - Game Initialization
  init() {
    let globalCardData = CardListDataSource()
    let cardList = globalCardData.fetchCardList()
    
    let plCardArray: [Card] = randomCards(cardArray: cardList)
    let aiCardArray: [Card]  = randomCards(cardArray: cardList)
    
    let playerDeckList = Deck(name: "Deck_1", id: "1", cardList: plCardArray)
    let aiDeckList = Deck(name: "Deck_1", id: "1", cardList: aiCardArray)
    
    //TODO: Change it based on deck selected for play before the game starts
    playerOneStats = Stats(name: "Player", id: "1", deckList: [playerDeckList], gameStats: Game(inDeck: playerDeckList.cardList, inHand: [], inPlay: [], battlePoints: Game.startingBattlePoints, health: Game.health))
    playerTwoStats = Stats(name: "AI", id: "2", deckList: [aiDeckList], gameStats: Game(inDeck: aiDeckList.cardList, inHand: [], inPlay: [], battlePoints: Game.startingBattlePoints, health: Game.health))
  }
  
  //Draw initial cards from deck
  func drawCardsFromDeck() {
    drawPlayerCards(numToDraw: Game.numOfCardstoDrawInitially)
    drawAICards(numToDraw: Game.numOfCardstoDrawInitially)
  }
  
  func drawPlayerCards(numToDraw: Int) {
    if (playerOneStats.gameStats.inDeck.count) > 0 {
      playerOneStats.gameStats.drawCards(numToDraw: numToDraw)
    } else {
      //HURT PLAYER
    }
  }
  
  func drawAICards(numToDraw: Int) {
    if (playerTwoStats.gameStats.inDeck.count) > 0 {
      playerTwoStats.gameStats.drawCards(numToDraw: numToDraw)
    } else {
      //HURT AI
    }
  }

  //MARK: - ViewModel Calls
  func toggleTurn() -> Bool {
    if isPlayerTurn {
      isPlayerTurn = false
      return playerTwoTurnStart()
    } else {
      isPlayerTurn = true
      return playerOneTurnStart()
    }
  }
  
  //Mark: - ViewModel Helpers
  func playerTwoTurnStart() -> Bool {
    return true
  }
  
  func playerOneTurnStart() -> Bool {
    return true
  }
}

//
//  GameManager.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 19/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

/// Handles all Gameplay logic. Includes Player Initialization and logic for Fetching Model information
class GameManager {
  //MARK: - Model Handlers
  var playerStats: Stats
  var aiStats: Stats
  
  //Mark: - Game Handlers
  var isPlayerTurn: Bool = true
  
  //MARK: - Game Initialization
  init() {
    let globalCardData = CardListDataSource()
    let cardList = globalCardData.fetchCardList()
    
    var pl_CardArray: [Card] = []
    var ai_CardArray: [Card]  = []
    
    //Adding Player Cards
    pl_CardArray.append(contentsOf: cardList)
    //TODO: Add AI cards based on player strength
    ai_CardArray.append(contentsOf: cardList)
    
    let playerDeckList = Deck(name: "Deck_1", id: "1", cardList: pl_CardArray)
    let aiDeckList = Deck(name: "Deck_1", id: "1", cardList: ai_CardArray)
    
    //EMPTY - for Card Drawn or Played
    let emptyArray: [Card] = []
    
    //TODO: Change it based on deck selected for play before the game starts
    playerStats = Stats(name: "Player", id: "1", deckList: [playerDeckList], gameStats: Game(inDeck: playerDeckList.cardList, inHand: emptyArray, inPlay: emptyArray, battlePoints: Game.startingBattlePoints, health: Game.health))
    aiStats = Stats(name: "AI", id: "2", deckList: [aiDeckList], gameStats: Game(inDeck: aiDeckList.cardList, inHand: emptyArray, inPlay: emptyArray, battlePoints: Game.startingBattlePoints, health: Game.health))
  }
  
  //Draw initial cards from deck
  func drawCardsFromDeck() {
    drawPlayerCards(numToDraw: Game.numOfCardstoDrawInitially)
    drawAICards(numToDraw: Game.numOfCardstoDrawInitially)
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
    //Increment Turn Number
    aiStats.gameStats.incrementTurn()
    
    //increment Battle Point Per Turn
    aiStats.gameStats.incrementBattlePoints()
    
    //Draw a Card
    drawAICards(numToDraw: Game.numOfCardsToDrawEachTurn)
    
    return true
  }
  
  func playerTurnStart() -> Bool {
    //Increment Turn Number
    playerStats.gameStats.incrementTurn()
    
    //increment Battle Point Per Turn
    playerStats.gameStats.incrementBattlePoints()
    
    //Draw a Card
    drawPlayerCards(numToDraw: Game.numOfCardsToDrawEachTurn)
    
    return true
  }
  
  //MARK: Animations
  func playCardToGameArea(cardIndex: Int, forPlayer: Bool) -> Bool {
    //Remove From InHand and Add to InPlay -- TODO: Check for cardIndex exceeding the array range due to positioning issue.
    if forPlayer {
      if self.playerStats.gameStats.battlePoints >= Int(self.playerStats.gameStats.inHand[cardIndex].battlepoint) {
        self.playerStats.gameStats.playCard(cardIndex: cardIndex)
        return true
      } else {
        return false
      }
    } else {
      if self.aiStats.gameStats.battlePoints >= Int(self.aiStats.gameStats.inHand[cardIndex].battlepoint) {
        self.aiStats.gameStats.playCard(cardIndex: cardIndex)
        return true
      } else {
        return false
      }
    }
  }
}

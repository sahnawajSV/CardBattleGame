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
  
  //MARK: - AI Behaviour Logic
  let playerTwoLogic: AIBehaviourManager
  
  //Mark: - Game Handlers
  var isPlayerTurn: Bool = true
  
  //MARK: - Game Initialization
  init(plDeck: Deck) {
    let globalCardData = CardListDataSource()
    let cardList = globalCardData.fetchCardList()
    
    let aiCardArray: [Card]  = randomCards(cardArray: cardList)
    
    let playerDeckList = plDeck //Deck(name: plDeck.name, id: plDeck.id, cardList: plCardArray)
    let aiDeckList = Deck(name: "Deck_1", id: 0, cardList: aiCardArray)
    
    //TODO: Change it based on deck selected for play before the game starts
    playerStats = Stats(name: "Player", id: "1", deckList: [playerDeckList], gameStats: Game(inDeck: playerDeckList.cardList, inHand: [], inPlay: [], battlePoints: Game.startingBattlePoints, health: Game.health))
    aiStats = Stats(name: "AI", id: "2", deckList: [aiDeckList], gameStats: Game(inDeck: aiDeckList.cardList, inHand: [], inPlay: [], battlePoints: Game.startingBattlePoints, health: Game.health))
    
    playerTwoLogic = AIBehaviourManager(playerOneStats: playerStats, playerTwoStats: aiStats)
  }
  
  func initializeGame(plDeck: Deck) {
    
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
  
  func removeInPlayCards(forPlayer: Bool, cardIndex: Int) {
    if forPlayer {
      playerStats.gameStats.inPlay.remove(at: cardIndex)
    } else {
      aiStats.gameStats.inPlay.remove(at: cardIndex)
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
    
    //Perform AI Behaviour
    playerTwoLogic.performInitialChecks()
    
    return true
  }
  
  func playerTurnStart() -> Bool {
    //Allow all inPlayCards to Attack
    allowAllPlayCardsToAttack()
    
    //Increment Turn Number
    playerStats.gameStats.incrementTurn()
    
    //increment Battle Point Per Turn
    playerStats.gameStats.incrementBattlePoints()
    
    //Draw a Card
    drawPlayerCards(numToDraw: Game.numOfCardsToDrawEachTurn)
    
    return true
  }
  
  func allowAllPlayCardsToAttack() {
    for (index,element) in playerStats.gameStats.inPlay.enumerated() {
      var card: Card = element
      card.canAttack = true
      playerStats.gameStats.inPlay[index] = card
    }
  }

  
  func attackAvatar(cardIndex: Int) {
    var card: Card = playerStats.gameStats.inPlay[cardIndex]
    if card.canAttack {
      let attackValue = card.attack
      card.canAttack = false
      playerStats.gameStats.inPlay[cardIndex] = card
      aiStats.gameStats.getHurt(attackValue: Int(attackValue))
    }
  }
  
  func attackCard(atkCardIndex: Int, defCardIndex: Int) {
    var atkCard: Card = playerStats.gameStats.inPlay[atkCardIndex]
    var defCard: Card = aiStats.gameStats.inPlay[defCardIndex]
    if atkCard.canAttack {
      atkCard.canAttack = false
      defCard.health = defCard.health - atkCard.attack
      atkCard.health = atkCard.health - defCard.attack
      
      playerStats.gameStats.inPlay[atkCardIndex] = atkCard
      aiStats.gameStats.inPlay[defCardIndex] = defCard
    }
  }
  
  //MARK: Update Battle Points based on card played
  func playCardToGameArea(cardIndex: Int) -> Bool {
    //Remove From InHand and Add to InPlay
    if isPlayerTurn {
      return updateBattlePoints(playerStats: self.playerStats, cardIndex: cardIndex)
    } else {
      return updateBattlePoints(playerStats: self.aiStats, cardIndex: cardIndex)
    }
  }
  
  func updateBattlePoints(playerStats: Stats, cardIndex: Int) -> Bool
  {
    if playerStats.gameStats.battlePoints >= Int(playerStats.gameStats.inHand[cardIndex].battlepoint) {
      playerStats.gameStats.playCard(cardIndex: cardIndex)
      return true
    } else {
      return false
    }
  }
}

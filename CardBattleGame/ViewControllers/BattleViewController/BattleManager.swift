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
  
  //Player Two AI
  let playerTwoLogicReference: AIBehaviourManager!
  
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
    
    playerTwoLogicReference = AIBehaviourManager(playerOneStats: playerOneStats, playerTwoStats: playerTwoStats)
  }
  
  //Draw initial cards from deck
  func drawCardsFromDeck() {
    drawPlayerOneCards(numToDraw: Game.numOfCardstoDrawInitially)
    drawPlayerTwoCards(numToDraw: Game.numOfCardstoDrawInitially)
  }
  
  //MARK: - ViewModel Calls

  
  func endPlayerOneTurn() -> Bool {
    isPlayerTurn = false
    return isPlayerTurn
  }
  
  func endPlayerTwoTurn() -> Bool {
    isPlayerTurn = true
    return isPlayerTurn
  }
  
  //Logic Handlers
  func drawPlayerOneCards(numToDraw: Int) {
    if (playerOneStats.gameStats.inDeck.count) > 0 {
      playerOneStats.gameStats.drawCards(numToDraw: numToDraw)
    } else {
      //HURT PLAYER
    }
  }
  
  func drawPlayerTwoCards(numToDraw: Int) {
    if (playerTwoStats.gameStats.inDeck.count) > 0 {
      playerTwoStats.gameStats.drawCards(numToDraw: numToDraw)
    } else {
      //HURT AI
    }
  }
  
  func playerTwoTurnStart() {
    playerTwoStats.gameStats.incrementTurn()
    playerTwoStats.gameStats.incrementBattlePoints()
    drawPlayerTwoCards(numToDraw: 1)
    playerTwoLogicReference.allowAllPlayCardsToAttack()
  }
  
  func playerOneTurnStart() {
    playerOneStats.gameStats.incrementTurn()
    playerOneStats.gameStats.incrementBattlePoints()
    drawPlayerOneCards(numToDraw: 1)
    playerOneStats.gameStats.allowAllPlayCardsToAttack()
  }
  
  func attackAvatar() {
    
  }
  
  func attackCard(attacker: Card, defender: Card, atkIndex: Int, defIndex: Int) {
    var atkCard = attacker
    var defCard = defender
    atkCard.health = atkCard.health - defender.attack
    defCard.health = defender.health - atkCard.attack
    atkCard.canAttack = false
    
    if isPlayerTurn {
      performCardHealthCheck(forPlayer: playerTwoStats, cardIndex: atkIndex, card: atkCard)
      performCardHealthCheck(forPlayer: playerOneStats, cardIndex: defIndex, card: defCard)
    } else {
      performCardHealthCheck(forPlayer: playerOneStats, cardIndex: atkIndex, card: atkCard)
      performCardHealthCheck(forPlayer: playerTwoStats, cardIndex: defIndex, card: defCard)
    }
  }
  
  func playCardToGameArea(cardIndex: Int) -> Bool {
    if isPlayerTurn {
      return updateBattlePoints(playerStats: playerOneStats, cardIndex: cardIndex)
    } else {
      return updateBattlePoints(playerStats: playerTwoStats, cardIndex: cardIndex)
    }
  }

  //Helpers
  func performCardHealthCheck(forPlayer: Stats, cardIndex: Int, card: Card) {
    if card.health <= 0 {
      forPlayer.gameStats.inPlay.remove(at: cardIndex)
    } else {
      forPlayer.gameStats.inPlay[cardIndex] = card
    }
  }
  
  func updateBattlePoints(playerStats: Stats, cardIndex: Int) -> Bool {
    if playerStats.gameStats.inPlay.count < 5 {
      if playerStats.gameStats.battlePoints >= Int(playerStats.gameStats.inHand[cardIndex].battlepoint) {
        playerStats.gameStats.playCard(cardIndex: cardIndex)
        return true
      } else {
        return false
      }
    } else {
      return false
    }
  }
}

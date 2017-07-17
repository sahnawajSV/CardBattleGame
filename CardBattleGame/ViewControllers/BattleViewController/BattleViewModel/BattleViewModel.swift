//
//  BattleViewModel.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 07/07/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

protocol BattleDelegate: class {
  func reloadAllUIElements(_ battleViewModel: BattleViewModel)
  func createInHandCards(_ battleViewModel: BattleViewModel)
  func drawANewCard(_ battleViewModel: BattleViewModel)
  func performCardToCardAttack(_ battleViewModel: BattleViewModel, atkIndex: Int, defIndex: Int, atkCard: Card, defCard: Card)
  func performCardToAvatarAttack(_ battleViewModel: BattleViewModel, cardIndex: Int)
  func didSelectCardToPlay(_ battleViewModel: BattleViewModel, cardIndex: Int)
  func winLossConditionReached(_ battleViewModel: BattleViewModel, isVictorious: Bool)
  func playerTwoDidEndTurn(_ battleViewModel: BattleViewModel)
}

/// Used as a Formatting class to pass data from BattleManager to BattleViewController
class BattleViewModel: AIBehaviourManagerDelegate {
  //GameManager & Delegate Initialization
  private var bManager: BattleManager = BattleManager()
  weak var delegate: BattleDelegate?
  var isPlayerTurn: Bool = false
  private var playerTwoLogicReference: AIBehaviourManager!
  
  //MARK: - Used by ViewController
  //Player
  var playerOneName: String = ""
  var playerOneHealth: String = ""
  var playerOneNumOfCardsInDeckText: String = ""
  var playerOneTotalBattlePointsText: String = ""
  var playerOneNumOfCardsInDeck: Int = 0
  var playerOneTotalBattlePoints: Int = 0
  var playerOneInHandCards: [Card] = []
  var playerOneInDeckCards: [Card] = []
  var playerOneInPlayCards: [Card] = []
  
  //AI
  var playerTwoName: String = ""
  var playerTwoHealth: String = ""
  var playerTwoNumOfCardsInDeckText: String = ""
  var playerTwoTotalBattlePointsText: String = ""
  var playerTwoNumOfCardsInDeck: Int = 0
  var playerTwoTotalBattlePoints: Int = 0
  var playerTwoInHandCards: [Card] = []
  var playerTwoInDeckCards: [Card] = []
  var playerTwoInPlayCards: [Card] = []
  
  //MARK: - Actions
  //MARK: - Initalizers
  func initializeTheGame() {
    playerTwoLogicReference = bManager.playerTwoLogicReference
    playerTwoLogicReference.delegate = self
    bManager.drawCardsFromDeck()
    updateData()
    notifyDelegateToReloadViewData()
    notifyDelegateToCreateInHandCards()
  }
  
  func toggleTurn(forPlayerOne: Bool) {
    endPlayerTurn(forPlayerOne: forPlayerOne)
    
    //Update Data and call delegates
    updateData()
    
    notifyDelegateToReloadViewData()
    notifyDelegateToDrawNewCardInHand()
  }
  
  func endPlayerTurn(forPlayerOne: Bool) {
    if forPlayerOne {
      isPlayerTurn = bManager.endPlayerOneTurn()
      bManager.playerTwoTurnStart()
    } else {
      isPlayerTurn = bManager.endPlayerTwoTurn()
      bManager.playerOneTurnStart()
    }
  }
  
  func startPlayerTwoChecks() {
    updateData()
    playerTwoLogicReference.attackWithACard()
  }
  
  func playCard(cardIndex: Int) -> Bool {
    let success = bManager.playCard(cardIndex: cardIndex)
    if success {
      updateData()
      notifyDelegateToReloadViewData()
      return true
    } else {
      return false
    }
  }
  
  func performAttackOnAvatar(cardIndex: Int) {
    bManager.attackAvatar(playerStats: bManager.playerOneStats, opponentStats: bManager.playerTwoStats, cardIndex: cardIndex)
    updateData()
  }

  func performAttackOnCard(atkIndex: Int, defIndex: Int) {
    bManager.attackCard(attacker: playerOneInPlayCards[atkIndex], defender: playerTwoInPlayCards[defIndex], atkIndex: atkIndex, defIndex: defIndex)
    updateData()
  }
  
  //MARK: - Helpers
  //MARK: - Model Updates Received
  func updateData() {
    playerOneName = bManager.playerOneStats.name
    playerOneHealth = String(bManager.playerOneStats.gameStats.health)
    playerTwoName = bManager.playerTwoStats.name
    playerTwoHealth = String(bManager.playerTwoStats.gameStats.health)
    
    playerOneNumOfCardsInDeckText = "\(String(describing: bManager.playerOneStats.gameStats.inDeck.count)) / \(Game.maximumCardPerDeck)"
    playerTwoNumOfCardsInDeckText = "\(String(describing: bManager.playerTwoStats.gameStats.inDeck.count)) / \(Game.maximumCardPerDeck)"
    playerOneTotalBattlePointsText = "\(String(describing: bManager.playerOneStats.gameStats.battlePoints)) / \(Game.maximumBattlePoint)"
    playerTwoTotalBattlePointsText = "\(String(describing: bManager.playerTwoStats.gameStats.battlePoints)) / \(Game.maximumBattlePoint)"
    
    playerOneNumOfCardsInDeck = bManager.playerOneStats.gameStats.inDeck.count
    playerTwoNumOfCardsInDeck = bManager.playerTwoStats.gameStats.inDeck.count
    playerOneTotalBattlePoints = bManager.playerOneStats.gameStats.battlePoints
    playerTwoTotalBattlePoints = bManager.playerTwoStats.gameStats.battlePoints
    
    playerOneInHandCards = bManager.playerOneStats.gameStats.inHand
    playerOneInDeckCards = bManager.playerOneStats.gameStats.inDeck
    playerOneInPlayCards = bManager.playerOneStats.gameStats.inPlay
    playerTwoInHandCards = bManager.playerTwoStats.gameStats.inHand
    playerTwoInDeckCards = bManager.playerTwoStats.gameStats.inDeck
    playerTwoInPlayCards = bManager.playerTwoStats.gameStats.inPlay
    
    //Set Turn Status
    isPlayerTurn = bManager.isPlayerTurn
    
    if bManager.playerOneStats.gameStats.health <= 0 {
      delegate?.winLossConditionReached(self, isVictorious: false)
    } else if bManager.playerTwoStats.gameStats.health <= 0 {
      delegate?.winLossConditionReached(self, isVictorious: true)
    }
  }

  //MARK: - Delegates
  func notifyDelegateToReloadViewData() {
    //Pass the message to ViewController to display required Data
    delegate?.reloadAllUIElements(self)
  }
  
  func notifyDelegateToCreateInHandCards() {
    delegate?.createInHandCards(self)
  }
  
  func notifyDelegateToDrawNewCardInHand() {
    delegate?.drawANewCard(self)
  }
  
  //MARK: Player Two Logic Delegates
  func didEndTurn(_ aIBehaviourManager: AIBehaviourManager) {
    delegate?.playerTwoDidEndTurn(self)
    toggleTurn(forPlayerOne: false)
  }
  
  func attackAvatar(_ aIBehaviourManager: AIBehaviourManager, cardIndex: Int) {
    bManager.attackAvatar(playerStats: bManager.playerTwoStats, opponentStats: bManager.playerOneStats, cardIndex: cardIndex)
    updateData()
    delegate?.performCardToAvatarAttack(self, cardIndex: cardIndex)
  }
  
  func attackAnotherCard(_ aiBehaviourManager: AIBehaviourManager, attacker: Card, defender: Card, atkIndex: Int, defIndex: Int) {
    bManager.attackCard(attacker: attacker, defender: defender, atkIndex: atkIndex, defIndex: defIndex)
    updateData()
    delegate?.performCardToCardAttack(self, atkIndex: atkIndex, defIndex: defIndex, atkCard: attacker, defCard: defender)
  }
  
  func didSelectCardToPlay(_ aIBehaviourManager: AIBehaviourManager, cardIndex: Int) {
    updateData()
    delegate?.didSelectCardToPlay(self, cardIndex: cardIndex)
  }
}

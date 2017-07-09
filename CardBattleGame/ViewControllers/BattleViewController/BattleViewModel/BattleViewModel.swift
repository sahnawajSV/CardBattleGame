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
  func performCardToCardAttack(_ battleViewModel: BattleViewModel, atkIndex: Int, defIndex: Int)
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
    tellDelegateToReloadViewData()
    tellDelegateToCreateInHandCards()
  }
  
  func toggleTurn(forPlayerOne: Bool) {
    endPlayerTurn(forPlayerOne: forPlayerOne)
    
    //Update Data and call delegates
    updateData()
    
    tellDelegateToReloadViewData()
    tellDelegateToDrawNewCardInHand()
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
    playerTwoLogicReference.attackWithACard()
  }
  
  func playCardToGameArea(cardIndex: Int) -> Bool {
    let success = bManager.playCardToGameArea(cardIndex: cardIndex)
    if success {
      updateData()
      tellDelegateToReloadViewData()
      return true
    } else {
      return false
    }
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
  }

  //MARK: - Delegates
  func tellDelegateToReloadViewData() {
    //Pass the message to ViewController to display required Data
    delegate?.reloadAllUIElements(self)
  }
  
  func tellDelegateToCreateInHandCards() {
    delegate?.createInHandCards(self)
  }
  
  func tellDelegateToDrawNewCardInHand() {
    delegate?.drawANewCard(self)
  }
  
  //MARK: Player Two Logic Delegates
  func didEndTurn(_ aIBehaviourManager: AIBehaviourManager) {
    toggleTurn(forPlayerOne: false)
  }
  
  func shouldAttackAvatar(_ aIBehaviourManager: AIBehaviourManager) {
    
  }
  
  func shouldAttackAnotherCard(_ aiBehaviourManager: AIBehaviourManager, attacker: Card, defender: Card, atkIndex: Int, defIndex: Int) {
    bManager.attackCard(attacker: attacker, defender: defender, atkIndex: atkIndex, defIndex: defIndex)
    delegate?.performCardToCardAttack(self, atkIndex: atkIndex, defIndex: defIndex)
  }
}

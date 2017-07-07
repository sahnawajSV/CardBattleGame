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
}

/// Used as a Formatting class to pass data from BattleManager to BattleViewController
class BattleViewModel {
  //GameManager & Delegate Initialization
  private var bManager: BattleManager = BattleManager()
  weak var delegate: BattleDelegate?
  var isPlayerTurn: Bool = false
  
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
    //Draw inital Cards from deck
    bManager.drawCardsFromDeck()
    
    //Update the Local Data
    updateData()
    
    //Pass the message back to ViewController
    tellDelegateToReloadViewData()
    tellDelegateToCreateInHandCards()
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
}

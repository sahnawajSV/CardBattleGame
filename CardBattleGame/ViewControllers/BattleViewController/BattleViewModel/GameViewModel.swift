//
//  GameViewModel.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 20/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

protocol GameProtocol {
  weak var delegate: GameDelegate? { get set }
}

protocol GameDelegate: class {
  func reloadAllViews(_ gameProtocol: GameProtocol)
  func createInHandViews(_ gameProtocol: GameProtocol)
}

/// This is a viewModel and a Formatting class. Fetches the required information from the GameManager class to provide easy to use variables to the ViewController to update the UI. Also handles all Delegate calls for the ViewController
class GameViewModel: GameProtocol {
  
  weak var delegate: GameDelegate?
  
  private var gManager: GameManager = GameManager()
  
  //MARK: - Used by View
  //Player
  var playerName: String = ""
  var playerHealth: String = ""
  var playerNumOfCardsInDeckText: String = ""
  var playerTotalBattlePointsText: String = ""
  var playerNumOfCardsInDeck: Int = 0
  var playerTotalBattlePoints: Int = 0
  var playerInHandCards: [Card] = []
  var playerInDeckCards: [Card] = []
  var playerInPlayCards: [Card] = []
  
  //AI
  var aiName: String = ""
  var aiHealth: String = ""
  var aiNumOfCardsInDeckText: String = ""
  var aiTotalBattlePointsText: String = ""
  var aiNumOfCardsInDeck: Int = 0
  var aiTotalBattlePoints: Int = 0
  var aiInHandCards: [Card] = []
  var aiInDeckCards: [Card] = []
  var aiInPlayCards: [Card] = []
  var AILogicReference: AIBehaviourManager!
  
  var isPlayerTurn = false
  
  //MARK: - Initalizers
  func initializeTheGame() {
    
    //Draw inital Cards from deck
    gManager.drawCardsFromDeck()
    
    //Update the Local Data
    updateData()
    
    //Reload the UI
    tellDelegateToReloadViewData()
    
    //Create InHandCards
    tellDelegateToRecreateInHandCards()
    
    //Set Turn Status
    isPlayerTurn = gManager.isPlayerTurn
  }
  
  func toggleTurn() {
    let turnFinished: Bool = gManager.endTurn()
    
    if turnFinished {
      //Set Turn Status
      isPlayerTurn = gManager.isPlayerTurn
      //Update Data and call delegates
      updateData()
      tellDelegateToReloadViewData()
      tellDelegateToRecreateInHandCards()
    }
  }
  
  func playCardToGameArea(cardIndex: Int) -> Bool {
    let success = gManager.playCardToGameArea(cardIndex: cardIndex)
    if success {
      updateData()
      tellDelegateToReloadViewData()
      return true
    } else {
      return false
    }
  }
  
  func attackAvatar(cardIndex: Int) {
    gManager.attackAvatar(cardIndex: cardIndex)
  }
  
  func attackCard(atkCardIndex: Int, defCardIndex: Int) {
    gManager.attackCard(atkCardIndex: atkCardIndex, defCardIndex: defCardIndex)
  }
  
  func removeInPlayCards(forPlayer: Bool, cardIndex: Int) {
    gManager.removeInPlayCards(forPlayer: forPlayer, cardIndex: cardIndex)
  }
  
  //MARK: - Model Updates Received
  func updateData() {
    playerName = gManager.playerStats.name
    playerHealth = String(gManager.playerStats.gameStats.health)
    aiName = gManager.aiStats.name
    aiHealth = String(gManager.aiStats.gameStats.health)
    
    playerNumOfCardsInDeckText = "\(String(describing: gManager.playerStats.gameStats.inDeck.count)) / \(Game.maximumCardPerDeck) Cards"
    aiNumOfCardsInDeckText = "\(String(describing: gManager.aiStats.gameStats.inDeck.count)) / \(Game.maximumCardPerDeck) Cards"
    playerTotalBattlePointsText = "\(String(describing: gManager.playerStats.gameStats.battlePoints)) / \(Game.maximumBattlePoint) BP"
    aiTotalBattlePointsText = "\(String(describing: gManager.aiStats.gameStats.battlePoints)) / \(Game.maximumBattlePoint) BP"
    
    playerNumOfCardsInDeck = gManager.playerStats.gameStats.inDeck.count
    aiNumOfCardsInDeck = gManager.aiStats.gameStats.inDeck.count
    playerTotalBattlePoints = gManager.playerStats.gameStats.battlePoints
    aiTotalBattlePoints = gManager.aiStats.gameStats.battlePoints
    
    playerInHandCards = gManager.playerStats.gameStats.inHand
    playerInDeckCards = gManager.playerStats.gameStats.inDeck
    playerInPlayCards = gManager.playerStats.gameStats.inPlay
    aiInHandCards = gManager.aiStats.gameStats.inHand
    aiInDeckCards = gManager.aiStats.gameStats.inDeck
    aiInPlayCards = gManager.aiStats.gameStats.inPlay
    
    AILogicReference = gManager.playerTwoLogic
  }
  
  
  //MARK: - Delegates
  func tellDelegateToReloadViewData() {
    //Pass the message to ViewController to display required Data
    delegate?.reloadAllViews(self)
  }
  
  func tellDelegateToRecreateInHandCards() {
    delegate?.createInHandViews(self)
  }
}

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
  func reloadAllViews(_ gameDelegate: GameDelegate)
  func createInHandViews(_ gameDelegate: GameDelegate)
}

class GameViewModel: GameProtocol {
  
  weak var delegate: GameDelegate?
  
  var gManager: GameManager = GameManager()
  
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
  
  //MARK: - Initalizers
  func initializeTheGame() {
    let success: Bool = gManager.initializeTheGame()
    
    if success {
      //Draw inital Cards from deck
      gManager.drawCardsFromDeck()
      
      //Update the Local Data
      updateData()
      
      //Reload the UI
      tellDelegateToReloadViewData()
    }
  }
  
  func toggleTurn() {
    let turnFinished: Bool = gManager.endTurn()
    
    if turnFinished {
      updateData()
      tellDelegateToReloadViewData()
    }
  }
  
  func playCardToGameArea(cardIndex: Int, forPlayer: Bool) {
    gManager.playCardToGameArea(cardIndex: cardIndex, forPlayer: forPlayer)
    updateData()
  }
  
  //MARK: - Model Updates Received
  func updateData() {
    playerName = gManager.playerStats.name
    playerHealth = gManager.playerStats.gameStats.health
    aiName = gManager.aiStats.name
    aiHealth = gManager.aiStats.gameStats.health
    
    playerNumOfCardsInDeckText = "\(String(describing: gManager.playerStats.gameStats.inDeck.count)) / \(Defaults.maximum_card_per_deck) Cards"
    aiNumOfCardsInDeckText = "\(String(describing: gManager.aiStats.gameStats.inDeck.count)) / \(Defaults.maximum_card_per_deck) Cards"
    playerTotalBattlePointsText = "\(String(describing: gManager.playerStats.gameStats.battlePoints)) / \(Defaults.maximum_battle_point) BP"
    aiTotalBattlePointsText = "\(String(describing: gManager.aiStats.gameStats.battlePoints)) / \(Defaults.maximum_battle_point) BP"
    
    playerNumOfCardsInDeck = gManager.playerStats.gameStats.inDeck.count
    aiNumOfCardsInDeck = gManager.aiStats.gameStats.inDeck.count
    playerTotalBattlePoints = Int(gManager.playerStats.gameStats.battlePoints)!
    aiTotalBattlePoints = Int(gManager.aiStats.gameStats.battlePoints)!
    
    playerInHandCards = gManager.playerStats.gameStats.inHand
    playerInDeckCards = gManager.playerStats.gameStats.inDeck
    playerInPlayCards = gManager.playerStats.gameStats.inPlay
    aiInHandCards = gManager.aiStats.gameStats.inHand
    aiInDeckCards = gManager.aiStats.gameStats.inDeck
    aiInPlayCards = gManager.aiStats.gameStats.inPlay
  }
  
  
  //MARK: - Delegates
  func tellDelegateToReloadViewData() {
    //Pass the message to ViewController to display required Data
    delegate?.reloadAllViews(delegate!)
    delegate?.createInHandViews(delegate!)
  }
}

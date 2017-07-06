//
//  BattleSystemViewController.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 19/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

/// Handles the BattleSystemViewController implementation. Used to update the Views and Labels. Handle Card Play and Toggle Turn interactions / actions.
class BattleSystemViewController: UIViewController, GameDelegate, InPlayViewControllerDelegate {
  //MARK: - Internal Variables
  private var gViewModel: GameViewModel = GameViewModel()
  
  var deck: Deck!
  
  //MARK: - View Collection
  var allPlayerHandCards: [CardView] = []
  var allAIHandCards: [CardView] = []
  var allPlayerPlayCards: [CardView] = []
  var allAIPlayCards: [CardView] = []
  
  //MARK: - Storyboard Connections
  @IBOutlet private weak var playerInDeckText: UILabel!
  @IBOutlet private weak var playerBattlePointText: UILabel!
  @IBOutlet private weak var playerNameText: UILabel!
  @IBOutlet private weak var playerHealthText: UILabel!
  
  @IBOutlet private weak var aiInDeckText: UILabel!
  @IBOutlet private weak var aiBattlePointText: UILabel!
  @IBOutlet private weak var aiNameText: UILabel!
  @IBOutlet private weak var aiHealthText: UILabel!
  
  @IBOutlet private weak var playerView: UIView!
  @IBOutlet private weak var playerDeckView: UIView!
  
  @IBOutlet private weak var aiView: UIView!
  @IBOutlet private weak var aiDeckView: UIView!
  
  @IBOutlet private weak var endTurnButton: UIButton!
  
  var playerOneInHandController : InHandViewController!
  var playerOnePlayController : InPlayViewController!
  var playerTwoInHandController : InHandViewController!
  var playerTwoPlayController : InPlayViewController!
  
  //MARK: - Gameplay Variables
  var originalFrameBeforePlay: CGRect = CGRect()
  var previousTimestamp: TimeInterval = TimeInterval()
  
  //To be used during attack phase
  
  //MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    //Assign View Model and Call Initializers
    gViewModel.delegate = self
    playerOnePlayController.delegate = self
    playerTwoPlayController.delegate = self
    playerOneInHandController.delegate = playerOnePlayController
    playerTwoInHandController.delegate = playerTwoPlayController
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    gViewModel.initializeTheGame(deck: deck)
  }
  
  override func viewDidLayoutSubviews() {
    self.view.translatesAutoresizingMaskIntoConstraints = true
  }
  
  //MARK: - Creation and Reload
  func createInHandCards() {
    if (allPlayerHandCards.count) > 0 {
      for (_,element) in (allPlayerHandCards.enumerated()) {
        element.removeFromSuperview()
      }
    }
    
    if (allAIHandCards.count) > 0 {
      for (_,element) in (allAIHandCards.enumerated()) {
        element.removeFromSuperview()
      }
    }
    
    allPlayerHandCards.removeAll()
    allAIHandCards.removeAll()
    
    allPlayerHandCards = playerOneInHandController.createCard(playerInHandCards: gViewModel.playerInHandCards)
    allAIHandCards = playerTwoInHandController.createCard(playerInHandCards: gViewModel.aiInHandCards)
  }
  
  func createInPlayerCardsForPlayerTwo() {
    if (allAIPlayCards.count) > 0 {
      for (_,element) in (allAIPlayCards.enumerated()) {
        element.removeFromSuperview()
      }
      allAIPlayCards.removeAll()
      gViewModel.updateData()
      for (index,card) in gViewModel.aiInPlayCards.enumerated() {
        let cardView: CardView = CardView(frame: playerTwoPlayController.cardOne.frame)
        cardView.bpText.text = String(card.battlepoint)
        cardView.attackText.text = String(card.attack)
        cardView.healthText.text = String(card.health)
        cardView.nameText.text = card.name
        cardView.cardIndex = index
        playerTwoPlayController.selectedTargetPosition = index
        let _ = playerTwoPlayController.updateInHandData(cardView: cardView)
        allAIPlayCards.append(cardView)
        reloadAllViews()
      }
    }
  }
  
  func reloadAllViews() {
    playerInDeckText.text = gViewModel.playerNumOfCardsInDeckText
    aiInDeckText.text = gViewModel.aiNumOfCardsInDeckText
    
    playerBattlePointText.text = gViewModel.playerTotalBattlePointsText
    aiBattlePointText.text = gViewModel.aiTotalBattlePointsText
    
    playerNameText.text = gViewModel.playerName
    aiNameText.text = gViewModel.aiName
    
    playerHealthText.text = gViewModel.playerHealth
    aiHealthText.text = gViewModel.aiHealth
    
    if gViewModel.isPlayerTurn {
      //Enable EndTurn Button if it is Player One Turn
      endTurnButton.isEnabled = true
    }
  }
  
  //MARK: Container View Preparation Segue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else {
      return
    }
    
    switch identifier {
    case "PlayerOneInHand":
      if let handController = segue.destination as? InHandViewController {
        self.playerOneInHandController = handController
        self.playerOneInHandController.isPlayer = true
      }
      break
    case "PlayerOneInPlay":
      if let playController = segue.destination as? InPlayViewController {
        self.playerOnePlayController = playController
      }
      break
    case "PlayerTwoInHand":
      if let handController = segue.destination as? InHandViewController {
        self.playerTwoInHandController = handController
        self.playerTwoInHandController.isPlayer = false
      }
      break
    case "PlayerTwoInPlay":
      if let playController = segue.destination as? InPlayViewController {
        self.playerTwoPlayController = playController
      }
      break
    default:
      break
    }
  }
  
  
  //MARK: - Action Methods
  @IBAction private func endTurnPressed(sender: UIButton) {
    if gViewModel.isPlayerTurn {
      //Disable EndTurn Button if it is Player Two / AI Turn
      endTurnButton.isEnabled = false
    }
    resetInPlayIndex(allCardViews: &allPlayerPlayCards)
    resetInPlayIndex(allCardViews: &allAIPlayCards)
    gViewModel.toggleTurn()
  }
  
  @IBAction private func aiViewButtonPressed(sender: UIButton) {
    if let selectedCardPosition: Int = playerOnePlayController.selectedTargetPosition {
      gViewModel.attackAvatar(cardIndex: selectedCardPosition)
      playerOnePlayController.selectedTargetPosition = nil
      gViewModel.updateData()
      reloadAllViews()
    }
  }
  
  
  //MARK: - Delegates - Create an Extension for the Delegate Methods
  func reloadAllViews(_ gameProtocol: GameProtocol) {
    reloadAllViews()
  }
  
  func createInHandViews(_ gameProtocol: GameProtocol) {
    createInHandCards()
  }
  
  func createInPlayViewForPlayerTwo(_ gameProtocol: GameProtocol) {
    createInPlayerCardsForPlayerTwo()
  }
  
  //MARK: GamePlay Delegates
  func gameViewModelDidSelectCardToPlay(_ gameProtocol: GameProtocol, cardIndex: Int) {
    let cardView: CardView = allAIHandCards[cardIndex]
    allAIHandCards.remove(at: cardIndex)
    gViewModel.updateData()
    cardView.cardIndex = gViewModel.aiInPlayCards.count
    playerTwoPlayController.selectedTargetPosition = gViewModel.aiInPlayCards.count - 1
    let _ = playerTwoPlayController.updateInHandData(cardView: cardView)
    allAIPlayCards.append(cardView)
  }
  
  func gameViewModelDidEndTurn(_ gameProtocol: GameProtocol) {
    gViewModel.updateData()
    createInPlayerCardsForPlayerTwo()
    resetInPlayIndex(allCardViews: &allPlayerPlayCards)
    resetInPlayIndex(allCardViews: &allAIPlayCards)
    gViewModel.toggleTurn()
  }
  
  func gameViewModelDidAttackCard(_ gameProtocol: GameProtocol, atkUpdatedHealth: Int, defUpdatedHealth: Int, atkIndex: Int, defIndex: Int) {
    performCardHealthCheck(playerCards: &allAIPlayCards, cardIndex: atkIndex, updatedHealth: atkUpdatedHealth)
    performCardHealthCheck(playerCards: &allPlayerPlayCards, cardIndex: defIndex, updatedHealth: defUpdatedHealth)
  }
  
  func gameViewModelDidAttackAvatar(_ gameProtocol: GameProtocol, attacker: Card, atkIndex: Int) {
    gViewModel.updateData()
    reloadAllViews()
  }
  
  //MARK: - Helpers
  func performCardHealthCheck(playerCards: inout [CardView], cardIndex: Int, updatedHealth: Int) {
    let cardView: CardView = playerCards[cardIndex]
    if updatedHealth <= 0 {
      cardView.removeFromSuperview()
      playerCards.remove(at: cardIndex)
      resetInPlayIndex(allCardViews: &allPlayerPlayCards)
      resetInPlayIndex(allCardViews: &allAIPlayCards)
    } else {
      cardView.healthText.text = String(updatedHealth)
      playerCards[cardIndex] = cardView
    }
  }
  
  func resetInPlayIndex(allCardViews: inout [CardView]) {
    allCardViews.enumerated().forEach { (index, cardView) in
      cardView.cardButton.tag = index
      cardView.cardIndex = index
    }
  }
  
  //MARK: - PlayerViewController Delegates
  func inPlayViewControllerDidChangeSelectedTargetPosition(_ inPlayViewController: InPlayViewController, cardIndex: Int) {
    if gViewModel.isPlayerTurn {
        let canPlay = gViewModel.playCardToGameArea(cardIndex: cardIndex)
        if canPlay {
          let success: Bool = updateDataForInHandCards(cardIndex: cardIndex, inPlayViewController: inPlayViewController)
          if success {
            updateAllPlayerCardData(cardIndex: cardIndex)
          }
        //Reset
        playerOneInHandController.selectedCardIndex = nil
        playerTwoInHandController.selectedCardIndex = nil
        createInHandCards()
      }
    } else {
      //Reset
      playerOneInHandController.selectedCardIndex = nil
      playerTwoInHandController.selectedCardIndex = nil
    }
  }
  
  func inPlayViewControllerDidSelectCardForAttack(_ inPlayViewController: InPlayViewController) {
    if let playerOneCardPosition: Int = playerOnePlayController.selectedTargetPosition {
      if let playerTwoCardPosition: Int = playerTwoPlayController.selectedTargetPosition {
        gViewModel.attackCard(atkCardIndex: playerOneCardPosition, defCardIndex: playerTwoCardPosition)
        gViewModel.updateData()
        let attackerHealth: Int = Int(gViewModel.playerInPlayCards[playerOneCardPosition].health)
        let defenderHealth: Int = Int(gViewModel.aiInPlayCards[playerTwoCardPosition].health)
        
        performCardHealthCheck(playerCards: &allPlayerPlayCards, cardIndex: playerOneCardPosition, updatedHealth: attackerHealth)
        performCardHealthCheck(playerCards: &allAIPlayCards, cardIndex: playerTwoCardPosition, updatedHealth: defenderHealth)
        
        if attackerHealth <= 0 {
          gViewModel.removeInPlayCards(forPlayer: true, cardIndex: playerOneCardPosition)
        }
        
        if defenderHealth <= 0 {
          gViewModel.removeInPlayCards(forPlayer: false, cardIndex: playerTwoCardPosition)
        }
        
        playerOnePlayController.selectedTargetPosition = nil
        playerTwoPlayController.selectedTargetPosition = nil
        gViewModel.updateData()
        reloadAllViews()
      }
    }
  }
  
  
  //MARK: - PlayViewController Delegate Helpers
  func updateDataForInHandCards(cardIndex: Int, inPlayViewController: InPlayViewController) -> Bool
  {
    if gViewModel.isPlayerTurn {
      return inPlayViewController.updateInHandData(cardView: setCardViewIndexForSelectedPlayer(allCardsInHand: allPlayerHandCards, totalInPlayCards: gViewModel.playerInPlayCards.count, cardIndex: cardIndex))
    } else {
      return inPlayViewController.updateInHandData(cardView: setCardViewIndexForSelectedPlayer(allCardsInHand: allAIHandCards, totalInPlayCards: gViewModel.aiInPlayCards.count, cardIndex: cardIndex))
    }
  }
  
  func setCardViewIndexForSelectedPlayer(allCardsInHand: [CardView], totalInPlayCards: Int, cardIndex: Int) -> CardView {
    let cardView: CardView = allCardsInHand[cardIndex]
    cardView.cardIndex = totalInPlayCards-1
    return cardView
  }
  
  func updateAllPlayerCardData(cardIndex: Int)
  {
    if gViewModel.isPlayerTurn {
      updateCardArrays(allPlayerPlayCards: &allPlayerPlayCards, allPlayerHandCards: &allPlayerHandCards, cardIndex: cardIndex)
    } else {
      updateCardArrays(allPlayerPlayCards: &allAIPlayCards, allPlayerHandCards: &allAIHandCards, cardIndex: cardIndex)
    }
  }
  
  func updateCardArrays(allPlayerPlayCards: inout [CardView], allPlayerHandCards: inout [CardView], cardIndex: Int) {
    allPlayerPlayCards.append(allPlayerHandCards[cardIndex])
    allPlayerHandCards.remove(at: cardIndex)
  }
}

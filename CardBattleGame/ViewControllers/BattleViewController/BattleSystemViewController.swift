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
  
  var playerOneInHandController : InHandViewController!
  var playerOnePlayController : InPlayViewController!
  var playerTwoInHandController : InHandViewController!
  var playerTwoPlayController : InPlayViewController!
  
  //MARK: - Gameplay Variables
  //To be used to find the card in the hand that is currently held down by Touch Began and Moved
  var selectedIndexToPlay = 99
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
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    gViewModel.initializeTheGame()
  }
  
  override func viewDidLayoutSubviews() {
    self.view.translatesAutoresizingMaskIntoConstraints = true
  }
  
  //MARK: - Create In Hand Cards
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
  
  //MARK: - Create In Hand Cards
  func createInPlayCardsForPlayerOne(_ inPlayProtocol: InPlayProtocol) {
    if playerOneInHandController.selectedCardIndex != 99 {
      let success: Bool = playerOnePlayController.updateInHandData(cardView: allPlayerHandCards[playerOneInHandController.selectedCardIndex])
      
      if success {
        gViewModel.playCardToGameArea(cardIndex: playerOneInHandController.selectedCardIndex, forPlayer: true)
        allPlayerPlayCards.append(allPlayerHandCards[playerOneInHandController.selectedCardIndex])
        allPlayerHandCards.remove(at: playerOneInHandController.selectedCardIndex)
      }
      
      //Reset
      playerOneInHandController.selectedCardIndex = 99
    }
  }
  
  
  //MARK: - Action Methods
  @IBAction private func endTurnPressed(sender: UIButton) {
    gViewModel.toggleTurn()
  }

  
  //MARK: - Delegates
  func reloadAllViews(_ gameProtocol: GameProtocol) {
    playerInDeckText.text = gViewModel.playerNumOfCardsInDeckText
    aiInDeckText.text = gViewModel.aiNumOfCardsInDeckText
    
    playerBattlePointText.text = gViewModel.playerTotalBattlePointsText
    aiBattlePointText.text = gViewModel.aiTotalBattlePointsText
    
    playerNameText.text = gViewModel.playerName
    aiNameText.text = gViewModel.aiName
    
    playerHealthText.text = gViewModel.playerHealth
    aiHealthText.text = gViewModel.aiHealth
  }
  
  func createInHandViews(_ gameProtocol: GameProtocol) {
    createInHandCards()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else {
      return
    }
    
    switch identifier {
    case "PlayerOneInHand":
      if let handController = segue.destination as? InHandViewController {
        self.playerOneInHandController = handController
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
}

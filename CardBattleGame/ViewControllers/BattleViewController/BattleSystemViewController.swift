//
//  BattleSystemViewController.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 19/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

/// Handles the BattleSystemViewController implementation. Used to update the Views and Labels. Handle Card Play and Toggle Turn interactions / actions.
class BattleSystemViewController: UIViewController, GameDelegate, InPlayViewControllerDelegate, AIBehaviourManagerDelegate {
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
  
  @IBOutlet private weak var endTurnButton: UIButton!
  
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
    playerOneInHandController.delegate = playerOnePlayController
    playerTwoInHandController.delegate = playerTwoPlayController
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    gViewModel.initializeTheGame()
    gViewModel.AILogicReference.delegate = self
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
      for (index,element) in gViewModel.aiInPlayCards.enumerated() {
        let cardView: CardView = CardView(frame: playerTwoPlayController.cardOne.frame)
        let card: Card = element
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
    gViewModel.toggleTurn()
  }
  
  @IBAction private func aiViewButtonPressed(sender: UIButton) {
    let selectedCardPosition: Int = playerOnePlayController.selectedTargetPosition
    if selectedCardPosition != 99 {
      gViewModel.attackAvatar(cardIndex: selectedCardPosition)
      playerOnePlayController.selectedTargetPosition = 99
      gViewModel.updateData()
      reloadAllViews()
//        Use for Animations
//      let cardView: CardView = allPlayerPlayCards[selectedCardPosition]
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
  
  //MARK: AIBehaviourManager Delegates
  func AIBehaviourManagerDidSelectCardToPlay(_ aiBehaviourManager: AIBehaviourManager, cardInfo: [String : AnyObject]) {
    let cardIndex: Int = cardInfo["cardIndex"] as! Int
    let cardView: CardView = allAIHandCards[cardIndex]
    allAIHandCards.remove(at: cardIndex)
    gViewModel.updateData()
    cardView.cardIndex = gViewModel.aiInPlayCards.count
    playerTwoPlayController.selectedTargetPosition = gViewModel.aiInPlayCards.count - 1
    let _ = playerTwoPlayController.updateInHandData(cardView: cardView)
    allAIPlayCards.append(cardView)
  }
  
  func AIBehaviourManagerDidEndTurn(_ aiBehaviourManager: AIBehaviourManager) {
    gViewModel.updateData()
    createInPlayerCardsForPlayerTwo()
    gViewModel.toggleTurn()
  }
  
  func AIBehaviourManagerDidAttackCard(atkUpdatedHealth: Int, defUpdatedHealth: Int, atkIndex: Int, defIndex: Int) {
    if atkUpdatedHealth <= 0 {
      //DESTROY ATTACKER
      let cardView: CardView = allAIPlayCards[atkIndex]
      cardView.removeFromSuperview()
      allAIPlayCards.remove(at: atkIndex)
    } else {
      let cardView: CardView = allAIPlayCards[atkIndex]
      cardView.healthText.text = String(atkUpdatedHealth)
      allAIPlayCards[atkIndex] = cardView
    }
    
    if defUpdatedHealth <= 0 {
      //DESTROY DEFENDER
      let cardView: CardView = allPlayerPlayCards[defIndex]
      cardView.removeFromSuperview()
      allPlayerPlayCards.remove(at: defIndex)
    } else {
      let cardView: CardView = allPlayerPlayCards[defIndex]
      cardView.healthText.text = String(defUpdatedHealth)
      allPlayerPlayCards[defIndex] = cardView
    }
  }
  
  func AIBehaviourManagerDidAttackAvatar(attacker: Card, atkIndex: Int) {
    gViewModel.updateData()
    reloadAllViews()
  }
  
  //MARK: - PlayerViewController Delegates
  func inPlayViewControllerDidChangeSelectedTargetPosition(_ inPlayViewController: InPlayViewController, inHandViewController: InHandViewController) {
    if gViewModel.isPlayerTurn {
      if inHandViewController.selectedCardIndex != 99 {
        let canPlay = gViewModel.playCardToGameArea(cardIndex: inHandViewController.selectedCardIndex)
        if canPlay {
          let success: Bool = updateDataForInHandCards(inHandViewController: inHandViewController, inPlayViewController: inPlayViewController)
          if success {
            updateAllPlayerCardData(cardIndex: inHandViewController.selectedCardIndex)
          }
        }
        //Reset
        inHandViewController.selectedCardIndex = 99
        createInHandCards()
      }
    } else {
      //Reset
      inHandViewController.selectedCardIndex = 99
    }
  }
  
  func inPlayViewControllerDidSelectCardForAttack(_ inPlayViewController: InPlayViewController) {
    let playerOneCardPosition: Int = playerOnePlayController.selectedTargetPosition
    if playerOneCardPosition != 99 {
      let playerTwoCardPosition: Int = playerTwoPlayController.selectedTargetPosition
      if playerTwoCardPosition != 99 {
         gViewModel.attackCard(atkCardIndex: playerOneCardPosition, defCardIndex: playerTwoCardPosition)
        gViewModel.updateData()
        let attackerHealth: Int = Int(gViewModel.playerInPlayCards[playerOneCardPosition].health)
        let defenderHealth: Int = Int(gViewModel.aiInPlayCards[playerTwoCardPosition].health)
        
        let atkCardView: CardView = allPlayerPlayCards[playerOneCardPosition]
        let defCardView: CardView = allAIPlayCards[playerTwoCardPosition]
        
        if attackerHealth <= 0 {
          atkCardView.removeFromSuperview()
          allPlayerPlayCards.remove(at: playerOneCardPosition)
          gViewModel.removeInPlayCards(forPlayer: true, cardIndex: playerOneCardPosition)
        } else {
          atkCardView.healthText.text = String(attackerHealth)
        }
        
        if defenderHealth <= 0 {
          defCardView.removeFromSuperview()
          allAIPlayCards.remove(at: playerTwoCardPosition)
          gViewModel.removeInPlayCards(forPlayer: false, cardIndex: playerTwoCardPosition)
        } else {
          defCardView.healthText.text = String(defenderHealth)
        }
        
        for i in 0..<allPlayerPlayCards.count {
          let cardView: CardView = allPlayerPlayCards[i]
          cardView.cardButton.tag = i
          cardView.cardIndex = i
        }
        
        for i in 0..<allAIPlayCards.count {
          let cardView: CardView = allAIPlayCards[i]
          cardView.cardButton.tag = i
          cardView.cardIndex = i
        }
        
        playerOnePlayController.selectedTargetPosition = 99
        playerTwoPlayController.selectedTargetPosition = 99
        gViewModel.updateData()
        reloadAllViews()
      }
    }
  }
  
  
  //MARK: - PlayViewController Delegate Helpers
  func updateDataForInHandCards(inHandViewController: InHandViewController, inPlayViewController: InPlayViewController) -> Bool
  {
    if gViewModel.isPlayerTurn {
      let cardView: CardView = allPlayerHandCards[inHandViewController.selectedCardIndex]
      cardView.cardIndex = gViewModel.playerInPlayCards.count-1
      return inPlayViewController.updateInHandData(cardView: cardView)
    } else {
      let cardView: CardView = allAIHandCards[inHandViewController.selectedCardIndex]
      cardView.cardIndex = gViewModel.aiInPlayCards.count-1
      return inPlayViewController.updateInHandData(cardView: allAIHandCards[inHandViewController.selectedCardIndex])
    }
  }
  
  func updateAllPlayerCardData(cardIndex: Int)
  {
    if gViewModel.isPlayerTurn {
      allPlayerPlayCards.append(allPlayerHandCards[cardIndex])
      allPlayerHandCards.remove(at: cardIndex)
    } else {
      allAIPlayCards.append(allAIHandCards[cardIndex])
      allAIHandCards.remove(at: cardIndex)
    }
  }
}

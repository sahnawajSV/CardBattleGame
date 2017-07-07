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
  
  @IBOutlet private weak var aiHandContainer: UIView!
  @IBOutlet private weak var aiPlayContainer: UIView!
  @IBOutlet private weak var playerHandContainer: UIView!
  @IBOutlet private weak var playerPlayContainer: UIView!
  
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
    gViewModel.initializeTheGame()
  }
  
  override func viewDidLayoutSubviews() {
    self.view.translatesAutoresizingMaskIntoConstraints = true
  }
  
  //MARK: - Creation and Reload
  func createInHandCards() {
    handleInhandCards(allCards: gViewModel.playerInHandCards, cardViews: &allPlayerHandCards, inHandViewController: playerOneInHandController)
    handleInhandCards(allCards: gViewModel.aiInHandCards, cardViews: &allAIHandCards, inHandViewController: playerTwoInHandController)
  }
  
  func createInPlayerCardsForPlayerTwo() {
    handleInPlayCards(allCards: allPlayerPlayCards, inPlayViewController: playerTwoPlayController)
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
      playerView.isHidden = true
    } else {
      playerView.isHidden = false
    }
    
    resetInPlayBorder(allInPlayCardViews: &allPlayerPlayCards, allInPlayCards: gViewModel.playerInPlayCards)
    resetInPlayBorder(allInPlayCardViews: &allAIPlayCards, allInPlayCards: gViewModel.aiInPlayCards)
  }
  
  //MARK: - Container View Preparation Segue
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
      let frame = playerOnePlayController.view.convert(aiView.frame, from:self.view)
      changeSubviewPositioningForPlayerOne()
      playerOnePlayController.performCardAttackAnimation(cardView: allPlayerPlayCards[selectedCardPosition], toFrame: frame)
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
  
  
  //MARK: - Player Two GamePlay Delegates
  func gameViewModelDidSelectCardToPlay(_ gameProtocol: GameProtocol, cardIndex: Int) {
    let cardView: CardView = allAIHandCards[cardIndex]
    playerTwoInHandController.cardsAdded.remove(at: cardIndex)
    allAIHandCards.remove(at: cardIndex)
    gViewModel.updateData()
    cardView.cardIndex = gViewModel.aiInPlayCards.count
    playerTwoPlayController.selectedTargetPosition = gViewModel.aiInPlayCards.count - 1
    let frame = playerTwoPlayController.view.convert(cardView.frame, from:playerTwoInHandController.view)
    changeSubviewPositioningForPlayerTwo()
    let _ = playerTwoPlayController.updateInHandData(cardView: cardView, olderFrame: frame)
    allAIPlayCards.append(cardView)
    gViewModel.tellAIToContinue()
  }
  
  func gameViewModelDidEndTurn(_ gameProtocol: GameProtocol) {
    gViewModel.updateData()
    createInPlayerCardsForPlayerTwo()
    resetInPlayIndex(allCardViews: &allPlayerPlayCards)
    resetInPlayIndex(allCardViews: &allAIPlayCards)
    gViewModel.toggleTurn()
  }
  
  func gameViewModelDidAttackCard(_ gameProtocol: GameProtocol, atkUpdatedHealth: Int, defUpdatedHealth: Int, atkIndex: Int, defIndex: Int) {
    let frame = playerTwoPlayController.view.convert(allPlayerPlayCards[defIndex].frame, from:playerOnePlayController.view)
    changeSubviewPositioningForPlayerTwo()
    playerTwoPlayController.performCardAttackAnimationForPlayerTwo(cardView: allAIPlayCards[atkIndex], toFrame: frame)
    self.performCardHealthCheck(playerCards: &self.allAIPlayCards, cardIndex: atkIndex, updatedHealth: atkUpdatedHealth)
    self.performCardHealthCheck(playerCards: &self.allPlayerPlayCards, cardIndex: defIndex, updatedHealth: defUpdatedHealth)
  }
  
  func gameViewModelDidAttackAvatar(_ gameProtocol: GameProtocol, attacker: Card, atkIndex: Int) {
    let frame = playerTwoPlayController.view.convert(playerView.frame, from:self.view)
    changeSubviewPositioningForPlayerTwo()
    playerTwoPlayController.performCardAttackAnimationForPlayerTwo(cardView: allAIPlayCards[atkIndex], toFrame: frame)
    self.gViewModel.updateData()
    self.reloadAllViews()
  }
  
  func gameViewModelReloadPlayView(_ gameProtocol: GameProtocol) {
    handleInPlayCards(allCards: allAIPlayCards, inPlayViewController: playerTwoPlayController)
  }
  
  func changeSubviewPositioningForPlayerTwo() {
    playerView.isHidden = false
    self.view.sendSubview(toBack: playerPlayContainer)
    self.view.sendSubview(toBack: playerHandContainer)
    self.view.bringSubview(toFront: aiPlayContainer)
  }
  
  //MARK: - Helpers
  func performCardHealthCheck(playerCards: inout [CardView], cardIndex: Int, updatedHealth: Int) {
    let cardView: CardView = playerCards[cardIndex]
    if updatedHealth <= 0 {
      cardView.removeFromSuperview()
      playerCards.remove(at: cardIndex)
      resetInPlayIndex(allCardViews: &allPlayerPlayCards)
      resetInPlayIndex(allCardViews: &allAIPlayCards)
      handleInPlayCards(allCards: allAIPlayCards, inPlayViewController: playerTwoPlayController)
    } else {
      cardView.healthText.text = String(updatedHealth)
      playerCards[cardIndex] = cardView
    }
  }
  
  func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
      deadline: .now() + delay, execute: closure)
  }
  
  func resetInPlayBorder(allInPlayCardViews: inout [CardView], allInPlayCards: [Card]) {
    allInPlayCardViews.enumerated().forEach { (index, cardView) in
      let card = allInPlayCards[index]
      if card.canAttack {
        cardView.layer.borderColor = UIColor.green.cgColor
        cardView.layer.borderWidth = 5.0
      } else {
        cardView.layer.borderColor = UIColor.red.cgColor
        cardView.layer.borderWidth = 5.0
      }
    }
  }
  
  func resetInPlayIndex(allCardViews: inout [CardView]) {
    allCardViews.enumerated().forEach { (index, cardView) in
      cardView.cardButton.tag = index
      cardView.cardIndex = index
    }
  }
  
  func handleInhandCards(allCards: [Card], cardViews: inout [CardView], inHandViewController: InHandViewController) {
    allCards.enumerated().forEach { (index, card) in
      if index >= cardViews.count {
        cardViews.append(inHandViewController.createACard(card: card, cardIndex: index))
      } else {
        cardViews[index].cardIndex = index
        cardViews[index].cardButton.tag = index
        inHandViewController.performCardAnimation(cardView: cardViews[index], forIndex: index)
      }
    }
  }
  
  func handleInPlayCards(allCards: [CardView], inPlayViewController: InPlayViewController) {
    allCards.enumerated().forEach { (index, cardView) in
      inPlayViewController.performCardToIndexAnimation(cardView: cardView, forIndex: index)
    }
  }
  
  //MARK: - Player One Delegates
  func inPlayViewControllerDidChangeSelectedTargetPosition(_ inPlayViewController: InPlayViewController, cardIndex: Int) {
    let canPlay = gViewModel.playCardToGameArea(cardIndex: cardIndex)
    if canPlay {
      changeSubviewPositioningForPlayerOne()
      let newCard: CardView = updateDataForInHandCards(cardIndex: cardIndex, inPlayViewController: inPlayViewController)
      updateAllPlayerCardData(cardIndex: cardIndex, cardView: newCard)
      
      //Reset
      playerOneInHandController.selectedCardIndex = nil
      playerTwoInHandController.selectedCardIndex = nil
      createInHandCards()
    }
  }
  
  func inPlayViewControllerDidSelectCardForAttack(_ inPlayViewController: InPlayViewController) {
    if let playerOneCardPosition: Int = playerOnePlayController.selectedTargetPosition {
      if let playerTwoCardPosition: Int = playerTwoPlayController.selectedTargetPosition {
        let canAttack = gViewModel.attackCard(atkCardIndex: playerOneCardPosition, defCardIndex: playerTwoCardPosition)
        if canAttack {
          let frame = playerOnePlayController.view.convert(allAIPlayCards[playerTwoCardPosition].frame, from:playerTwoPlayController.view)
          changeSubviewPositioningForPlayerOne()
          playerOnePlayController.performCardAttackAnimation(cardView: allPlayerPlayCards[playerOneCardPosition], toFrame: frame)
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
        }
        playerOnePlayController.selectedTargetPosition = nil
        playerTwoPlayController.selectedTargetPosition = nil
        gViewModel.updateData()
        reloadAllViews()
      }
    }
  }
  
  
  //MARK: Player One Delegate Helpers
  func updateDataForInHandCards(cardIndex: Int, inPlayViewController: InPlayViewController) -> CardView
  {
    let cardView = setCardViewIndexForSelectedPlayer(allCardsInHand: allPlayerHandCards, totalInPlayCards: gViewModel.playerInPlayCards.count, cardIndex: cardIndex)
    let frame = playerOnePlayController.view.convert(cardView.frame, from:playerOneInHandController.view)
    return inPlayViewController.updateInHandData(cardView: cardView, olderFrame: frame)
  }
  
  func setCardViewIndexForSelectedPlayer(allCardsInHand: [CardView], totalInPlayCards: Int, cardIndex: Int) -> CardView {
    let cardView: CardView = allCardsInHand[cardIndex]
    let newCard: CardView = CardView(frame: cardView.frame)
    newCard.bpText.text = cardView.bpText.text
    newCard.nameText.text = cardView.nameText.text
    newCard.attackText.text = cardView.attackText.text
    newCard.healthText.text = cardView.healthText.text
    newCard.cardIndex = totalInPlayCards-1
    cardView.removeFromSuperview()
    return cardView
  }
  
  func updateAllPlayerCardData(cardIndex: Int, cardView: CardView)
  {
    allPlayerPlayCards.append(cardView)
    playerOneInHandController.cardsAdded.remove(at: cardIndex)
    allPlayerHandCards.remove(at: cardIndex)
    resetInPlayIndex(allCardViews: &allPlayerPlayCards)
  }
  
  func changeSubviewPositioningForPlayerOne() {
    playerView.isHidden = true
    self.view.sendSubview(toBack: aiPlayContainer)
    self.view.sendSubview(toBack: aiHandContainer)
    self.view.bringSubview(toFront: playerPlayContainer)
  }
  
  //Animation Helper
  func performCardAnimation(cardView: CardView, toFrame: CGRect) {
    UIView.animate(withDuration: Game.cardMoveAnimationSpeed,
                   delay: 0,
                   options: UIViewAnimationOptions.curveEaseIn,
                   animations: { () -> Void in
                    cardView.frame = toFrame
    }, completion: { (finished) -> Void in
      
    })
  }
}

//
//  BattleViewController.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 07/07/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

class BattleViewController: UIViewController, BattleDelegate, InHandViewControllerDelegate, InPlayViewControllerDelegate {
  private var bViewModel: BattleViewModel = BattleViewModel()
  
  //Action Is finished Check
  var isPerformingAnAction: Bool = false
  
  //MARK: - CardView Collection
  var allPlayerOneInHandCards: [CardView] = []
  var allPlayerTwoInHandCards: [CardView] = []
  var allPlayerOneInPlayCards: [CardView] = []
  var allPlayerTwoInPlayCards: [CardView] = []
  
  //MARK: - Storyboard Connections
  @IBOutlet private weak var playerOneInDeckText: UILabel!
  @IBOutlet private weak var playerOneBattlePointText: UILabel!
  @IBOutlet private weak var playerOneNameText: UILabel!
  @IBOutlet private weak var playerOneHealthText: UILabel!
  
  @IBOutlet private weak var playerTwoInDeckText: UILabel!
  @IBOutlet private weak var playerTwoBattlePointText: UILabel!
  @IBOutlet private weak var playerTwoNameText: UILabel!
  @IBOutlet private weak var playerTwoHealthText: UILabel!
  
  @IBOutlet private weak var playerOneView: UIView!
  @IBOutlet var playerOneDeckView: UIView!
  
  @IBOutlet private weak var playerTwoView: UIView!
  @IBOutlet weak var playerTwoDeckView: UIView!
  
  @IBOutlet private weak var playerTwoHandContainer: UIView!
  @IBOutlet private weak var playerTwoPlayContainer: UIView!
  @IBOutlet private weak var playerOneHandContainer: UIView!
  @IBOutlet private weak var playerOnePlayContainer: UIView!
  
  @IBOutlet private weak var viewBG: UIImageView!
  
  @IBOutlet private weak var endTurnButton: UIButton!
  
  private var playerOneInHandController: InHandViewController!
  private var playerOnePlayController: InPlayViewController!
  private var playerTwoInHandController: InHandViewController!
  private var playerTwoPlayController: InPlayViewController!
  
  private var attackCardIndex: Int?
  private var winLossReached: Bool = false
  private var timer: Timer?
  private var count = Game.turnTimer
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bViewModel.delegate = self
    playerOneInHandController.delegate = self
    playerTwoInHandController.delegate = self
    playerOnePlayController.delegate = self
    playerTwoPlayController.delegate = self
    bViewModel.initializeTheGame()
  }
  
  //MARK: Class Helpers
  private func reloadAllUIElements() {
    playerOneInDeckText.text = bViewModel.playerOneNumOfCardsInDeckText
    playerTwoInDeckText.text = bViewModel.playerTwoNumOfCardsInDeckText
    
    playerOneBattlePointText.text = bViewModel.playerOneTotalBattlePointsText
    playerTwoBattlePointText.text = bViewModel.playerTwoTotalBattlePointsText
    
    playerOneNameText.text = bViewModel.playerOneName
    playerTwoNameText.text = bViewModel.playerTwoName
    
    playerOneHealthText.text = bViewModel.playerOneHealth
    playerTwoHealthText.text = bViewModel.playerTwoHealth
  }
  
  private func handleInhandCards(allCards: [Card], inHandViewController: InHandViewController, allCardViews: inout [CardView]) {
    allCardViews.removeAll()
    isPerformingAnAction = true
    let frame = getPlayerDeckViewFrame(inHandViewController: inHandViewController, forDeckView: playerOneDeckView)
    allCardViews = inHandViewController.createCards(allCards: allCards, fromFrame: frame)
  }
  
  private func handleDrawingOfNewCard(allCards: [Card], inHandViewController: InHandViewController, allCardViews: inout [CardView]) {
    if allCardViews.count < 5 {
      isPerformingAnAction = true
      var frame: CGRect = CGRect.zero
      if bViewModel.isPlayerTurn {
        frame = getPlayerDeckViewFrame(inHandViewController: inHandViewController, forDeckView: playerOneDeckView)
      } else {
        frame = getPlayerDeckViewFrame(inHandViewController: inHandViewController, forDeckView: playerTwoDeckView)
      }
      if let newCard = allCards.last {
        allCardViews = inHandViewController.createACard(card: newCard, fromFrame: frame, cardIndex: allCards.count-1)
      }
    } else {
      if !bViewModel.isPlayerTurn {
        bViewModel.startPlayerTwoChecks()
      }
    }
  }
  
  private func handleCardToCardAttack(atkIndex: Int, defIndex: Int, atkCard: Card, defCard: Card) {
    isPerformingAnAction = true
    let updatedAttackerHealth: Int16 = atkCard.health - defCard.attack
    let updatedDefenderHealth: Int16 = defCard.health - atkCard.attack
    if bViewModel.isPlayerTurn {
      let atkCardView: CardView = allPlayerOneInPlayCards[atkIndex]
      let defCardView: CardView = allPlayerTwoInPlayCards[defIndex]
      atkCardView.changeCardState(cardState: .cannotAttack)
      bViewModel.performAttackOnCard(atkIndex: atkIndex, defIndex: defIndex)
      performCardToCardAttack(atkView: atkCardView, defView: defCardView, attackerPlayViewController: playerOnePlayController, defenderPlayViewController: playerTwoPlayController, atkIndex: atkIndex, defIndex: defIndex, atkHealth: updatedAttackerHealth, defHealth: updatedDefenderHealth)
    } else {
      let atkCardView: CardView = allPlayerTwoInPlayCards[atkIndex]
      let defCardView: CardView = allPlayerOneInPlayCards[defIndex]
      atkCardView.changeCardState(cardState: .cannotAttack)
      performCardToCardAttack(atkView: atkCardView, defView: defCardView, attackerPlayViewController: playerTwoPlayController, defenderPlayViewController: playerOnePlayController, atkIndex: atkIndex, defIndex: defIndex, atkHealth: updatedAttackerHealth, defHealth: updatedDefenderHealth)
    }
  }
  
  private func handleCardToAvatarAttack(atkIndex: Int) {
    if bViewModel.isPlayerTurn {
      if allPlayerOneInPlayCards.count >= atkIndex+1 {
        isPerformingAnAction = true
        let atkCardView: CardView = allPlayerOneInPlayCards[atkIndex]
        atkCardView.changeCardState(cardState: .cannotAttack)
        performCardToAvatarAttack(atkView: atkCardView, defView: playerTwoView, inPlayViewController: playerOnePlayController, cardIndex: atkIndex)
      }
    } else {
      if allPlayerTwoInPlayCards.count >= atkIndex+1 {
        isPerformingAnAction = true
        let atkCardView: CardView = allPlayerTwoInPlayCards[atkIndex]
        atkCardView.changeCardState(cardState: .cannotAttack)
        performCardToAvatarAttack(atkView: atkCardView, defView: playerOneView, inPlayViewController: playerTwoPlayController, cardIndex: atkIndex)
      }
    }
  }
  
  func handleCardPlay(cardIndex: Int, allInHandCards: inout [CardView]) {
    if allInHandCards.count >= cardIndex+1 {
      isPerformingAnAction = true
      if bViewModel.isPlayerTurn {
        playCardForPlayer(allInHandCards: &allInHandCards, allInPlayCards: &allPlayerOneInPlayCards, cardView: allInHandCards[cardIndex], inHandIndex: cardIndex, inHandViewController: playerOneInHandController, inPlayViewController: playerOnePlayController, inPlayIndex: bViewModel.playerOneInPlayCards.count-1)
      } else {
          playCardForPlayer(allInHandCards: &allInHandCards, allInPlayCards: &allPlayerTwoInPlayCards, cardView: allInHandCards[cardIndex], inHandIndex: cardIndex, inHandViewController: playerTwoInHandController, inPlayViewController: playerTwoPlayController, inPlayIndex: bViewModel.playerTwoInPlayCards.count-1)
      }
    }
  }
  
  func handlePlayerOneTurnStart() {
    allPlayerOneInPlayCards.forEach { (cardView) in
      cardView.changeCardState(cardState: .canAttack)
    }
  }
  
  func handlePlayerTwoTurnStart() {
    allPlayerTwoInPlayCards.forEach { (cardView) in
      cardView.changeCardState(cardState: .canAttack)
    }
  }
  
  //MARK: - Actions
  @IBAction private func endTurnPressed(sender: UIButton) {
    if !isPerformingAnAction {
      view.bringSubview(toFront: playerOneHandContainer)
      view.bringSubview(toFront: playerTwoHandContainer)
      if bViewModel.isPlayerTurn {
        bViewModel.toggleTurn(forPlayerOne: true)
        timer?.invalidate()
        count = Game.turnTimer
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
      }
    }
  }
  
  @IBAction private func avatarClicked(sender: UIButton) {
    guard let cardIndex = attackCardIndex else {
      return
    }
    if sender.tag == 1 {
      if bViewModel.isPlayerTurn {
        bViewModel.performAttackOnAvatar(cardIndex: cardIndex)
        allPlayerOneInPlayCards[cardIndex].changeCardState(cardState: .cannotAttack)
        performCardToAvatarAttack(atkView: allPlayerOneInPlayCards[cardIndex], defView: playerTwoView, inPlayViewController: playerOnePlayController, cardIndex: cardIndex)
      }
    }
  }
  
  //MARK: - Function Helpers
  func getPlayerDeckViewFrame(inHandViewController: InHandViewController, forDeckView: UIView) -> CGRect {
    return inHandViewController.view.convert(forDeckView.frame, from:view)
  }
  
  func completedAllAnimations() {
    isPerformingAnAction = false
    attackCardIndex = nil
    view.sendSubview(toBack: playerOneHandContainer)
    view.sendSubview(toBack: playerTwoHandContainer)
    view.sendSubview(toBack: viewBG)
    view.bringSubview(toFront: playerTwoHandContainer)
    view.bringSubview(toFront: playerOneHandContainer)
    if !bViewModel.isPlayerTurn {
      resetInHandOrPlayIndex(allCardViews: &allPlayerOneInPlayCards)
      resetInHandOrPlayIndex(allCardViews: &allPlayerTwoInPlayCards)
      bViewModel.startPlayerTwoChecks()
    }
  }
  
  func update() {
    if(count > 0){
      let minutes = String(count / 60)
      let seconds = String(count % 60)
      endTurnButton.setTitle(minutes + ":" + seconds, for: .normal)
      count -= 1
    } else {
      endTurnButton.setTitle("End Turn", for: .normal)
      timer?.invalidate()
      if bViewModel.isPlayerTurn {
        bViewModel.toggleTurn(forPlayerOne: true)
      } else {
        bViewModel.toggleTurn(forPlayerOne: false)
      }
    }
  }
  
  
  func performCardToCardAttack(atkView: CardView, defView: UIView, attackerPlayViewController: InPlayViewController, defenderPlayViewController: InPlayViewController, atkIndex: Int, defIndex: Int, atkHealth: Int16, defHealth: Int16) {
    let frame = view.convert(atkView.frame, from:attackerPlayViewController.view)
    let swordImage: UIImageView = UIImageView(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: 80, height: 160))
    swordImage.image = #imageLiteral(resourceName: "sword")
    view.addSubview(swordImage)
    let angle = degreesToRotateObjectWithPosition(objPos: defView.center, andTouchPoint: swordImage.center)
    swordImage.transform = CGAffineTransform(rotationAngle: (angle * CGFloat(Double.pi)) / 180.0)
    let defFrame = view.convert(defView.frame, from:defenderPlayViewController.view)
    UIView.animate(withDuration: Game.cardAttackAnimationSpeed,
                   delay: 0,
                   options: UIViewAnimationOptions.curveEaseIn,
                   animations: { () -> Void in
                    swordImage.frame = CGRect(x: defFrame.origin.x, y: defFrame.origin.y, width: swordImage.frame.size.width, height: swordImage.frame.size.height)
    }, completion: { (finished) -> Void in
      swordImage.removeFromSuperview()
      if self.bViewModel.isPlayerTurn {
        self.performCardHealthCheck(playerCards: &self.allPlayerOneInPlayCards, cardIndex: atkIndex, updatedHealth: atkHealth, inPlayerController: self.playerOnePlayController)
        self.performCardHealthCheck(playerCards: &self.allPlayerTwoInPlayCards, cardIndex: defIndex, updatedHealth: defHealth, inPlayerController: self.playerTwoPlayController)
      } else {
        self.performCardHealthCheck(playerCards: &self.allPlayerTwoInPlayCards, cardIndex: atkIndex, updatedHealth: atkHealth, inPlayerController: self.playerTwoPlayController)
        self.performCardHealthCheck(playerCards: &self.allPlayerOneInPlayCards, cardIndex: defIndex, updatedHealth: defHealth, inPlayerController: self.playerOnePlayController)
      }
      self.completedAllAnimations()
    })
  }
  
  
  func performCardToAvatarAttack(atkView: CardView, defView: UIView, inPlayViewController: InPlayViewController, cardIndex: Int) {
    let frame = view.convert(atkView.frame, from:inPlayViewController.view)
    let swordImage: UIImageView = UIImageView(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: 80, height: 160))
    swordImage.image = #imageLiteral(resourceName: "sword")
    view.addSubview(swordImage)
    let angle = degreesToRotateObjectWithPosition(objPos: defView.center, andTouchPoint: swordImage.center)
    swordImage.transform = CGAffineTransform(rotationAngle: (angle * CGFloat(Double.pi)) / 180.0)
    performAttackAnimation(swordView: swordImage, toFrame: defView.frame)
  }
  
  func performAttackAnimation(swordView: UIImageView, toFrame: CGRect) {
    UIView.animate(withDuration: Game.cardAttackAnimationSpeed,
                   delay: 0,
                   options: UIViewAnimationOptions.curveLinear,
                   animations: { () -> Void in
                    swordView.frame = CGRect(x: toFrame.origin.x, y: toFrame.origin.y, width: swordView.frame.size.width, height: swordView.frame.size.height)
    }, completion: { (finished) -> Void in
      swordView.removeFromSuperview()
      self.reloadAllUIElements()
      self.completedAllAnimations()
    })
  }
  
  func resetInHandOrPlayIndex(allCardViews: inout [CardView]) {
    allCardViews.enumerated().forEach { (index, cardView) in
      cardView.cardButton.tag = index
    }
  }
  
  func playCardForPlayer(allInHandCards: inout [CardView], allInPlayCards: inout [CardView], cardView: CardView, inHandIndex: Int, inHandViewController: InHandViewController, inPlayViewController: InPlayViewController, inPlayIndex: Int) {
    let frame = inPlayViewController.view.convert(cardView.frame, from:inHandViewController.view)
    let newCard = createNewCardFromOldCard(oldCardView: cardView)
    inPlayViewController.playACard(cardView: newCard, currentFrame: frame, cardIndex: inPlayIndex)
    allInPlayCards.append(newCard)
    allInHandCards.remove(at: inHandIndex)
    inHandViewController.removeCard(cardIndex: inHandIndex)
    resetInHandOrPlayIndex(allCardViews: &allInHandCards)
    bViewModel.updateData()
  }
  
  func createNewCardFromOldCard(oldCardView: CardView) -> CardView {
    let newCard: CardView = CardView(frame: playerOnePlayController.cardOne.frame)
    newCard.bpText.text = oldCardView.bpText.text
    newCard.nameText.text = oldCardView.nameText.text
    newCard.attackText.text = oldCardView.attackText.text
    newCard.healthText.text = oldCardView.healthText.text
    newCard.cardImage.image = oldCardView.cardImage.image
    oldCardView.removeFromSuperview()
    return newCard
  }
  
  func performCardHealthCheck(playerCards: inout [CardView], cardIndex: Int, updatedHealth: Int16, inPlayerController: InPlayViewController) {
    let cardView: CardView = playerCards[cardIndex]
    if updatedHealth <= 0 {
      cardView.removeFromSuperview()
      playerCards.remove(at: cardIndex)
      inPlayerController.removeCard(cardIndex: cardIndex)
    } else {
      cardView.healthText.text = String(updatedHealth)
      playerCards[cardIndex] = cardView
    }
    resetInHandOrPlayIndex(allCardViews: &allPlayerOneInPlayCards)
    resetInHandOrPlayIndex(allCardViews: &allPlayerTwoInPlayCards)
  }
  
  func degreesToRotateObjectWithPosition(objPos: CGPoint, andTouchPoint: CGPoint) -> CGFloat {
    let dX = andTouchPoint.x - objPos.x
    let dY = andTouchPoint.y - objPos.y
    let bearingRadians = atan2f(Float(dX), Float(dY))
    
    var bearingDegrees = CGFloat(bearingRadians).degrees
    if bearingDegrees < 0 {
      bearingDegrees = abs(bearingDegrees)
    } else {
      bearingDegrees = -bearingDegrees
    }
    
    let degrees: CGFloat = bearingDegrees
    
    return degrees
  }
  
  //MARK: - ViewModel Delegates
  func reloadAllUIElements(_ battleViewModel: BattleViewModel) {
    reloadAllUIElements()
  }
  
  func createInHandCards(_ battleViewModel: BattleViewModel) {
    createInitialInHandCards()
  }
  
  func drawANewCard(_ battleViewModel: BattleViewModel) {
    drawNewCardFromDeck()
  }
  
  //MARK: - Container View Preparation Segue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else {
      return
    }
    
    switch identifier {
    case "PlayerOneInHand":
      if let handController = segue.destination as? InHandViewController {
        playerOneInHandController = handController
        playerOneInHandController.isPlayer = true
      }
      break
    case "PlayerOneInPlay":
      if let playController = segue.destination as? InPlayViewController {
        playerOnePlayController = playController
      }
      break
    case "PlayerTwoInHand":
      if let handController = segue.destination as? InHandViewController {
        playerTwoInHandController = handController
        playerTwoInHandController.isPlayer = false
      }
      break
    case "PlayerTwoInPlay":
      if let playController = segue.destination as? InPlayViewController {
        playerTwoPlayController = playController
      }
      break
    default:
      break
    }
  }
  
  //MARK: - InHandViewController Delegate
  func didCompleteInHandAction(_ inHandViewController: InHandViewController) {
    completedAllAnimations()
  }
  
  func cardSelectedInHandToPlay(_ inHandViewController: InHandViewController, cardIndex: Int) {
    if !isPerformingAnAction {
      let success = bViewModel.playCardToGameArea(cardIndex: cardIndex)
      if success {
        if bViewModel.isPlayerTurn {
          handleCardPlay(cardIndex: cardIndex, allInHandCards: &allPlayerOneInHandCards)
        } else {
          handleCardPlay(cardIndex: cardIndex, allInHandCards: &allPlayerTwoInHandCards)
        }
      }
    }
  }
  
  //MARK: - InPlayViewController Delegate
  func didCompleteInPlayAction(_ inPlayViewController: InPlayViewController) {
    completedAllAnimations()
  }
  
  func cardSelectedInPlayToAttack(_ inPlayViewController: InPlayViewController, cardIndex: Int) {
    if bViewModel.isPlayerTurn {
      if let index = attackCardIndex {
        if inPlayViewController == playerTwoPlayController {
          handleCardToCardAttack(atkIndex: index, defIndex: cardIndex, atkCard: bViewModel.playerOneInPlayCards[index], defCard: bViewModel.playerTwoInPlayCards[cardIndex])
          return
        }
      }
    }
    attackCardIndex = cardIndex
  }
  
  //MARK: - BattleViewModel Delegate Helpers
  private func createInitialInHandCards() {
    handleInhandCards(allCards: bViewModel.playerOneInHandCards, inHandViewController: playerOneInHandController, allCardViews: &allPlayerOneInHandCards)
    handleInhandCards(allCards: bViewModel.playerTwoInHandCards, inHandViewController: playerTwoInHandController, allCardViews: &allPlayerTwoInHandCards)
  }
  
  func didSelectCardToPlay(_ battleViewModel: BattleViewModel, cardIndex: Int) {
    handleCardPlay(cardIndex: cardIndex, allInHandCards: &allPlayerTwoInHandCards)
  }
  
  private func drawNewCardFromDeck() {
    if bViewModel.isPlayerTurn {
      if bViewModel.playerOneInDeckCards.count > 0 {
        view.bringSubview(toFront: playerOneHandContainer)
       handleDrawingOfNewCard(allCards: bViewModel.playerOneInHandCards, inHandViewController: playerOneInHandController, allCardViews: &allPlayerOneInHandCards)
      }
      handlePlayerOneTurnStart()
    } else {
      if bViewModel.playerTwoInDeckCards.count > 0 {
        view.bringSubview(toFront: playerTwoHandContainer)
       handleDrawingOfNewCard(allCards: bViewModel.playerTwoInHandCards, inHandViewController: playerTwoInHandController, allCardViews: &allPlayerTwoInHandCards)
        handlePlayerTwoTurnStart()
      } else {
        handlePlayerTwoTurnStart()
        completedAllAnimations()
      }
    }
  }
  
  func performCardToCardAttack(_ battleViewModel: BattleViewModel, atkIndex: Int, defIndex: Int, atkCard: Card, defCard: Card) {
    handleCardToCardAttack(atkIndex: atkIndex, defIndex: defIndex, atkCard: atkCard, defCard: defCard)
  }
  
  func performCardToAvatarAttack(_ battleViewModel: BattleViewModel, cardIndex: Int) {
    handleCardToAvatarAttack(atkIndex: cardIndex)
  }
  
  func winLossConditionReached(_ battleViewModel: BattleViewModel, isVictorious: Bool) {
    if !winLossReached {
      winLossReached = true
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let winLossViewController = storyboard.instantiateViewController(withIdentifier: "WinLoss") as! WinLossViewController
      winLossViewController.isVictorious = isVictorious
      navigationController?.pushViewController(winLossViewController, animated: true)
    }
  }
  
  func playerTwoDidEndTurn(_ battleViewModel: BattleViewModel) {
    isPerformingAnAction = false
    attackCardIndex = nil
    timer?.invalidate()
    count = Game.turnTimer
    timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
  }
}

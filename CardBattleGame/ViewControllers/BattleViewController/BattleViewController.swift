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
  
  @IBOutlet private weak var endTurnButton: UIButton!
  
  private var playerOneInHandController: InHandViewController!
  private var playerOnePlayController: InPlayViewController!
  private var playerTwoInHandController: InHandViewController!
  private var playerTwoPlayController: InPlayViewController!
  
  private var attackCardIndex: Int?
  
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
      let frame = getPlayerDeckViewFrame(inHandViewController: inHandViewController, forDeckView: playerOneDeckView)
      if let newCard = allCards.last {
        allCardViews = inHandViewController.createACard(card: newCard, fromFrame: frame, cardIndex: allCards.count-1)
      }
    } else {
      //Since Drawing a Card Animation cannot trigger the same
      if !bViewModel.isPlayerTurn {
        bViewModel.startPlayerTwoChecks()
      }
    }
  }
  
  private func handleCardToCardAttack(atkIndex: Int, defIndex: Int) {
    isPerformingAnAction = true
    if bViewModel.isPlayerTurn {
      let atkCardView: CardView = allPlayerOneInPlayCards[atkIndex]
      let defCardView: CardView = allPlayerTwoInPlayCards[defIndex]
      performCardattack(atkView: atkCardView, defView: defCardView, inPlayViewController: playerOnePlayController, cardIndex: atkIndex)
    } else {
      let atkCardView: CardView = allPlayerOneInPlayCards[atkIndex]
      let defCardView: CardView = allPlayerTwoInPlayCards[defIndex]
      performCardattack(atkView: atkCardView, defView: defCardView, inPlayViewController: playerOnePlayController, cardIndex: atkIndex)
    }
  }
  
  func handleCardPlay(cardIndex: Int, allInHandCards: inout [CardView]) {
    isPerformingAnAction = true
    if bViewModel.isPlayerTurn {
      playCardForPlayer(allInHandCards: &allInHandCards, allInPlayCards: &allPlayerOneInPlayCards, cardView: allInHandCards[cardIndex], inHandIndex: cardIndex, inHandViewController: playerOneInHandController, inPlayViewController: playerOnePlayController, inPlayIndex: bViewModel.playerOneInPlayCards.count-1)
    } else {
      playCardForPlayer(allInHandCards: &allInHandCards, allInPlayCards: &allPlayerTwoInPlayCards, cardView: allInHandCards[cardIndex], inHandIndex: cardIndex, inHandViewController: playerTwoInHandController, inPlayViewController: playerTwoPlayController, inPlayIndex: bViewModel.playerTwoInPlayCards.count-1)
    }
  }
  
  func handlePlayerOneTurnStart() {
    allPlayerOneInPlayCards.forEach { (cardView) in
      cardView.changeCardState(cardState: .canAttack)
    }
  }
  
  //MARK: - Actions
  @IBAction private func endTurnPressed(sender: UIButton) {
    if !isPerformingAnAction {
      bViewModel.toggleTurn(forPlayerOne: true)
    }
  }
  
  @IBAction private func avatarClicked(sender: UIButton) {
    guard let cardIndex = attackCardIndex else {
      return
    }
    if sender.tag == 1 {
      if bViewModel.isPlayerTurn {
        performCardattack(atkView: allPlayerOneInPlayCards[cardIndex], defView: playerTwoView, inPlayViewController: playerOnePlayController, cardIndex: cardIndex)
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
    if !bViewModel.isPlayerTurn {
      bViewModel.startPlayerTwoChecks()
    }
  }
  
  //TODO: - REDO THIS THING!!
  func performCardattack(atkView: CardView, defView: UIView, inPlayViewController: InPlayViewController, cardIndex: Int) {
    let frame = view.convert(atkView.frame, from:inPlayViewController.view)
    let swordImage: UIImageView = UIImageView(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: 80, height: 160))
    swordImage.image = #imageLiteral(resourceName: "sword")
    view.addSubview(swordImage)
    if bViewModel.isPlayerTurn {
      var angle: CGFloat = 0
      switch cardIndex {
      case 0:
        angle = 135
        break
      case 1:
        angle = 135
        break
      case 2:
        angle = 135
        break
      case 3:
        angle = 135
        break
      case 4:
        angle = 135
        break
      default:
        break
      }
      swordImage.transform = CGAffineTransform(rotationAngle: (angle * CGFloat(Double.pi)) / 180.0)
      performAttackAnimation(swordView: swordImage, toPoint: defView.center)
    }
  }
  
  func performAttackAnimation(swordView: UIImageView, toPoint: CGPoint) {
    UIView.animate(withDuration: Game.cardAttackAnimationSpeed,
                   delay: 0,
                   options: UIViewAnimationOptions.curveEaseIn,
                   animations: { () -> Void in
                    swordView.frame = CGRect(x: toPoint.x, y: toPoint.y, width: swordView.frame.size.width, height: swordView.frame.size.height)
    }, completion: { (finished) -> Void in
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
    
  }
  
  func cardSelectedInPlayToAttack(_ inPlayViewController: InPlayViewController, cardIndex: Int) {
    attackCardIndex = cardIndex
  }
  
  //MARK: - BattleViewModel Delegate Helpers
  private func createInitialInHandCards() {
    handleInhandCards(allCards: bViewModel.playerOneInHandCards, inHandViewController: playerOneInHandController, allCardViews: &allPlayerOneInHandCards)
    handleInhandCards(allCards: bViewModel.playerTwoInHandCards, inHandViewController: playerTwoInHandController, allCardViews: &allPlayerTwoInHandCards)
  }
  
  private func drawNewCardFromDeck() {
    if bViewModel.isPlayerTurn {
      handleDrawingOfNewCard(allCards: bViewModel.playerOneInHandCards, inHandViewController: playerOneInHandController, allCardViews: &allPlayerOneInHandCards)
      handlePlayerOneTurnStart()
    } else {
      handleDrawingOfNewCard(allCards: bViewModel.playerTwoInHandCards, inHandViewController: playerTwoInHandController, allCardViews: &allPlayerTwoInHandCards)
    }
  }
  
  func performCardToCardAttack(_ battleViewModel: BattleViewModel, atkIndex: Int, defIndex: Int) {
    handleCardToCardAttack(atkIndex: atkIndex, defIndex: defIndex)
  }
}

//
//  BattleSystemViewController.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 19/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

class BattleSystemViewController: UIViewController, GameDelegate {
  //MARK: - Internal Variables
  var gViewModel: GameViewModel = GameViewModel()
  
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
  
  //InHand Player Cards
  @IBOutlet private weak var ih_player_cardOne: UIView!
  @IBOutlet private weak var ih_player_cardTwo: UIView!
  @IBOutlet private weak var ih_player_cardThree: UIView!
  @IBOutlet private weak var ih_player_cardFour: UIView!
  @IBOutlet private weak var ih_player_cardFive: UIView!
  
  //InHand AI Cards
  @IBOutlet private weak var ih_ai_cardOne: UIView!
  @IBOutlet private weak var ih_ai_cardTwo: UIView!
  @IBOutlet private weak var ih_ai_cardThree: UIView!
  @IBOutlet private weak var ih_ai_cardFour: UIView!
  @IBOutlet private weak var ih_ai_cardFive: UIView!
  
  //InPlay Player Cards
  @IBOutlet private weak var ip_player_cardOne: UIView!
  @IBOutlet private weak var ip_player_cardTwo: UIView!
  @IBOutlet private weak var ip_player_cardThree: UIView!
  @IBOutlet private weak var ip_player_cardFour: UIView!
  @IBOutlet private weak var ip_player_cardFive: UIView!
  
  //InPlay AI Cards
  @IBOutlet private weak var ip_ai_cardOne: UIView!
  @IBOutlet private weak var ip_ai_cardTwo: UIView!
  @IBOutlet private weak var ip_ai_cardThree: UIView!
  @IBOutlet private weak var ip_ai_cardFour: UIView!
  @IBOutlet private weak var ip_ai_cardFive: UIView!
  
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
    gViewModel.delegate = self;
    gViewModel.initializeTheGame()
    
    setupCardBackground()
  }
  
  
  //MARK: - Card BG Creator
  func setupCardBackground() {
    ih_player_cardOne.dropShadow(scale: true)
    ih_player_cardTwo.dropShadow(scale: true)
    ih_player_cardThree.dropShadow(scale: true)
    ih_player_cardFour.dropShadow(scale: true)
    ih_player_cardFive.dropShadow(scale: true)
    
    ih_ai_cardOne.dropShadow(scale: true)
    ih_ai_cardTwo.dropShadow(scale: true)
    ih_ai_cardThree.dropShadow(scale: true)
    ih_ai_cardFour.dropShadow(scale: true)
    ih_ai_cardFive.dropShadow(scale: true)
    
    ip_player_cardOne.dropShadow(scale: true)
    ip_player_cardTwo.dropShadow(scale: true)
    ip_player_cardThree.dropShadow(scale: true)
    ip_player_cardFour.dropShadow(scale: true)
    ip_player_cardFive.dropShadow(scale: true)
    
    ip_ai_cardOne.dropShadow(scale: true)
    ip_ai_cardTwo.dropShadow(scale: true)
    ip_ai_cardThree.dropShadow(scale: true)
    ip_ai_cardFour.dropShadow(scale: true)
    ip_ai_cardFive.dropShadow(scale: true)
  }
  
  //MARK: - Create In Hand Cards
  func createInHandCardForPlayerView() {
    if (allPlayerHandCards.count) > 0 {
      for (index,_) in (allPlayerHandCards.enumerated()) {
        let cardView = allPlayerHandCards[index]
        cardView.removeFromSuperview()
      }
    }
    
    allPlayerHandCards.removeAll()
    
    for (index,_) in (gViewModel.playerInHandCards.enumerated()) {
      let card = gViewModel.playerInHandCards[index]
      
      var cardFrame: CGRect
      
      switch index {
      case 0:
        cardFrame = ih_player_cardOne.frame
      case 1:
        cardFrame = ih_player_cardTwo.frame
      case 2:
        cardFrame = ih_player_cardThree.frame
      case 3:
        cardFrame = ih_player_cardFour.frame
      case 4:
        cardFrame = ih_player_cardFive.frame
      default:
        cardFrame = ih_player_cardOne.frame
      }
      
      let cardView: CardView = CardView(frame: cardFrame)
      
      cardView.bpText.text = String(card.battlepoint)
      cardView.attackText.text = String(card.attack)
      cardView.healthText.text = String(card.health)
      cardView.nameText.text = card.name
      
      self.view.addSubview(cardView)
      allPlayerHandCards.append(cardView)
      self.view.bringSubview(toFront: playerView)
    }
  }
  
  func createInHandCardForAIView() {
    if (allAIHandCards.count) > 0 {
      for (index,_) in (allAIHandCards.enumerated()) {
        let cardView = allAIHandCards[index]
        cardView.removeFromSuperview()
      }
    }
    
    allAIHandCards.removeAll()
    
    for (index,_) in (gViewModel.aiInHandCards.enumerated()) {
      let card = gViewModel.aiInHandCards[index]
      
      var cardFrame: CGRect
      
      switch index {
      case 0:
        cardFrame = ih_ai_cardOne.frame
      case 1:
        cardFrame = ih_ai_cardTwo.frame
      case 2:
        cardFrame = ih_ai_cardThree.frame
      case 3:
        cardFrame = ih_ai_cardFour.frame
      case 4:
        cardFrame = ih_ai_cardFive.frame
      default:
        cardFrame = ih_ai_cardOne.frame
      }
      
      let cardView: CardView = CardView(frame: cardFrame)
      
      cardView.bpText.text = String(card.battlepoint)
      cardView.attackText.text = String(card.attack)
      cardView.healthText.text = String(card.health)
      cardView.nameText.text = card.name
      
      self.view.addSubview(cardView)
      allAIHandCards.append(cardView)
      self.view.bringSubview(toFront: aiView)
    }
  }
  
  
  //MARK: - Action Methods
  @IBAction private func endTurnPressed(sender: UIButton) {
    gViewModel.toggleTurn()
  }
  
  //MARK: - Delegates
  func reloadAllViews(_ gameDelegate: GameDelegate) {
    playerInDeckText.text = gViewModel.playerNumOfCardsInDeckText
    aiInDeckText.text = gViewModel.aiNumOfCardsInDeckText
    
    playerBattlePointText.text = gViewModel.playerTotalBattlePointsText
    aiBattlePointText.text = gViewModel.aiTotalBattlePointsText
    
    playerNameText.text = gViewModel.playerName
    aiNameText.text = gViewModel.aiName
    
    playerHealthText.text = gViewModel.playerHealth
    aiHealthText.text = gViewModel.aiHealth
  }
  
  func createInHandViews(_ gameDelegate: GameDelegate) {
    createInHandCardForPlayerView()
    createInHandCardForAIView()
  }
  
  //MARK: - TOUCH Actions
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    previousTimestamp = (event?.timestamp)!;
    
    //Reset Index
    selectedIndexToPlay = 99
    
    let touch = touches.first
    let location = touch?.location(in: self.view)
    
    //Check if touch is on a card held in HAND
    for (index,_) in (allPlayerHandCards.enumerated()) {
      let card: CardView = allPlayerHandCards[index]
      if (card.frame.contains(location!)) {
        selectedIndexToPlay = index
        originalFrameBeforePlay = card.frame
        card.frame = CGRect(x: card.frame.origin.x, y: UIScreen.main.bounds.height - card.frame.size.height, width: card.frame.size.width, height: card.frame.size.height)
        self.view.bringSubview(toFront: card)
        break
      }
    }
    
    //Check if the touch is on a card held in Play area
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    //Capturing the Speed of MOVEMENT - To make sure that the user can preview the cards before play
    let timeSincePrevious: TimeInterval = event!.timestamp - previousTimestamp
    if selectedIndexToPlay <= 5 && timeSincePrevious > 0.2 {
      let touch = touches.first
      let location = touch?.location(in: self.view)
      
      let cardView: CardView  = allPlayerHandCards[selectedIndexToPlay]
      cardView.frame = CGRect(x: (location?.x)! - (cardView.frame.size.width / 2), y: (location?.y)!, width: (cardView.frame.size.width), height: (cardView.frame.size.height))
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if selectedIndexToPlay <= 5
    {
      let touch = touches.first
      let location = touch?.location(in: self.view)
      
      playCardToGameArea(location: location!)
    }
  }
  
  //Animated and Move the Card to the Play Area
  func playCardToGameArea(location: CGPoint) {
    let cardView: CardView  = allPlayerHandCards[selectedIndexToPlay]
    
    let totalBattlePoints: Int = Int(gViewModel.playerTotalBattlePoints)
    let cardBattlePoints: Int = Int((cardView.bpText.text)!)!
    
    if gViewModel.playerInPlayCards.count < 5 && totalBattlePoints >= cardBattlePoints {
      var playAreaCardFrame: CGRect = CGRect()
      var hasExistingCard: Bool = false
      
      if allPlayerPlayCards.count > 0 {
        //Checking if the new position already has a card on it or not
        for index in 0...allPlayerPlayCards.count-1 {
          let cardView: CardView  = allPlayerPlayCards[index]
          if (cardView.frame.contains(location)) {
            hasExistingCard = true
          }
        }
      }
      
      if !hasExistingCard {
        var didIntersect: Bool = false
        
        for index in 0...4 {
          switch index {
          case 0:
            if (ip_player_cardOne.frame.contains(location)) {
              playAreaCardFrame = ip_player_cardOne.frame
              didIntersect = true
            }
            break
          case 1:
            if (ip_player_cardTwo.frame.contains(location)) {
              playAreaCardFrame = ip_player_cardTwo.frame
              didIntersect = true
            }
            break
          case 2:
            if (ip_player_cardThree.frame.contains(location)) {
              playAreaCardFrame = ip_player_cardThree.frame
              didIntersect = true
            }
            break
          case 3:
            if (ip_player_cardFour.frame.contains(location)) {
              playAreaCardFrame = ip_player_cardFour.frame
              didIntersect = true
            }
            break
          case 4:
            if (ip_player_cardFive.frame.contains(location)) {
              playAreaCardFrame = ip_player_cardFive.frame
              didIntersect = true
            }
            break
          default:
            break
          }
        }
        
        if didIntersect {
          UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
            cardView.frame = playAreaCardFrame
          }, completion: { (finished: Bool) in
            self.allPlayerPlayCards.append(self.allPlayerHandCards[self.selectedIndexToPlay])
            self.allPlayerHandCards.remove(at: self.selectedIndexToPlay)
            self.gViewModel.playCardToGameArea(cardIndex: self.selectedIndexToPlay, forPlayer: true)
            self.reloadAllViews(self.gViewModel.delegate!)
          })
        } else {
          moveCardToOriginalFrame(cardView: cardView)
        }
      } else {
        moveCardToOriginalFrame(cardView: cardView)
      }
    } else {
      moveCardToOriginalFrame(cardView: cardView)
    }
  }
  
  func moveCardToOriginalFrame(cardView: CardView) {
    UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
      cardView.frame = self.originalFrameBeforePlay
    }, completion: { (finished: Bool) in
      self.view.bringSubview(toFront: self.playerView)
    })
  }
}

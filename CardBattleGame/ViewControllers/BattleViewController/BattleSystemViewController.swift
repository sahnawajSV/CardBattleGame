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
  }
  
  //MARK: - Create In Hand Cards
  //TODO: Write better logic
  func createInHandCards()
  {
    if (allPlayerHandCards.count) > 0 {
      for (index,_) in (allPlayerHandCards.enumerated()) {
        let cardView = allPlayerHandCards[index]
        cardView.removeFromSuperview()
      }
    }
    
    if (allAIHandCards.count) > 0 {
      for (index,_) in (allAIHandCards.enumerated()) {
        let cardView = allAIHandCards[index]
        cardView.removeFromSuperview()
      }
    }
    
    allPlayerHandCards.removeAll()
    allAIHandCards.removeAll()
    
    let playerCards = [ih_player_cardOne, ih_player_cardTwo, ih_player_cardThree, ih_player_cardFour, ih_player_cardFive]
    let aiCards = [ih_ai_cardOne, ih_ai_cardTwo, ih_ai_cardThree, ih_ai_cardFour, ih_ai_cardFive]
    
    for (index,element) in playerCards.enumerated() {
      
      guard let element = element else {
        continue
      }
      
      var frame: CGRect = CGRect()
      var card: Card?
      var cardView: CardView = CardView(frame: frame)
      
      if gViewModel.playerInHandCards.count > index {
        frame = element.frame
        card = gViewModel.playerInHandCards[index]
        cardView = CardView(frame: frame)
        
        guard let card = card else {
          continue
        }
        
        addCard(cardView: cardView, card: card)
      }
      
      if gViewModel.aiInHandCards.count > index {
        frame = (aiCards[index]?.frame)!
        card = gViewModel.aiInHandCards[index]
        cardView = CardView(frame: frame)
        
        guard let card = card else {
          continue
        }
        
        addCard(cardView: cardView, card: card)
      }
    }

  }
  
  func addCard(cardView: CardView, card: Card)
  {
    cardView.bpText.text = String(card.battlepoint)
    cardView.attackText.text = String(card.attack)
    cardView.healthText.text = String(card.health)
    cardView.nameText.text = card.name
    
    self.view.addSubview(cardView)
    allPlayerHandCards.append(cardView)
    self.view.bringSubview(toFront: playerView)
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
    createInHandCards()
  }
}

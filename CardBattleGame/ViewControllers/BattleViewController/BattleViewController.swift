//
//  BattleViewController.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 07/07/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

class BattleViewController: UIViewController {
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
  
  var playerOneInHandController : InHandViewController!
  var playerOnePlayController : InPlayViewController!
  var playerTwoInHandController : InHandViewController!
  var playerTwoPlayController : InPlayViewController!

  override func viewDidLoad() {
    super.viewDidLoad()
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
    allCardViews = inHandViewController.createCards(allCards: allCards)
  }
  
  //Delegate Helpers
  func createInitialInHandCards() {
    handleInhandCards(allCards: bViewModel.playerOneInHandCards, inHandViewController: playerOneInHandController, allCardViews: &allPlayerOneInHandCards)
    handleInhandCards(allCards: bViewModel.playerTwoInHandCards, inHandViewController: playerTwoInHandController, allCardViews: &allPlayerTwoInHandCards)
  }

  //MARK: - Delegates - Create an Extension for the Delegate Methods
  func reloadAllUIElements(_ battleViewModel: BattleViewModel) {
    reloadAllUIElements()
  }
  
  func createInHandCards(_ battleViewModel: BattleViewModel) {
    createInitialInHandCards()
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
}

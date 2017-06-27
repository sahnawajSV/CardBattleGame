//
//  PlayerOneInHandViewController.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 22/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

class InHandViewController: UIViewController {
  
  @IBOutlet private weak var cardOne: UIView!
  @IBOutlet private weak var cardTwo: UIView!
  @IBOutlet private weak var cardThree: UIView!
  @IBOutlet private weak var cardFour: UIView!
  @IBOutlet private weak var cardFive: UIView!
  
  var createdCards: [CardView] = []
  
  //Default value when no card is selected
  var selectedCardIndex: Int = 99
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func createCard(playerInHandCards: [Card]) -> [CardView] {
    var cardsAdded: [CardView] = []
    for (index,element) in playerInHandCards.enumerated() {
      var frame = CGRect.zero
      switch index {
      case 0:
        frame = cardOne.frame
      case 1:
        frame = cardTwo.frame
      case 2:
        frame = cardThree.frame
      case 3:
        frame = cardFour.frame
      case 4:
        frame = cardFive.frame
      default:
        break
      }
      let cardView: CardView = CardView(frame: frame)
      let card: Card = element
      cardView.bpText.text = String(card.battlepoint)
      cardView.attackText.text = String(card.attack)
      cardView.healthText.text = String(card.health)
      cardView.nameText.text = card.name
      cardView.cardButton.tag = index
      cardView.cardButton.addTarget(self, action: #selector(selectInHandCard(button:)), for: .touchUpInside)
      self.view.addSubview(cardView)
      self.view.layoutIfNeeded()
      
      cardsAdded.append(cardView)
    }
    createdCards = cardsAdded
    return cardsAdded
  }
  
  //Action Methods
  func selectInHandCard(button: UIButton) {
    selectedCardIndex = button.tag
  }
}

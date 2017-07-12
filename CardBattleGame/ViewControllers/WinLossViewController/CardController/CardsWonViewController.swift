//
//  CardsWonViewController.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 12/07/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

class CardsWonViewController: UIViewController {
  @IBOutlet weak var cardOne: UIView!
  @IBOutlet weak var cardTwo: UIView!
  @IBOutlet weak var cardThree: UIView!
  
  private var allCardViews: [CardView] = []
  
  func createCards(allCards: [Card]) -> [CardView] {
    allCardViews.removeAll()
    allCards.enumerated().forEach { (index, card) in
      let cardView = createACard(card: card, cardIndex: index)
      allCardViews.append(cardView)
    }
    return allCardViews
  }
  
  private func createACard(card: Card, cardIndex: Int) -> CardView {
    let frame = getCardFrame(forIndex: cardIndex)
    let cardView: CardView = CardView(frame: frame)
    cardView.bpText.text = String(card.battlepoint)
    cardView.attackText.text = String(card.attack)
    cardView.healthText.text = String(card.health)
    cardView.nameText.text = card.name
    cardView.cardButton.tag = cardIndex
    cardView.cardImage.image = UIImage.init(named: card.imageName)
    cardView.changeCardState(cardState: .neutral)
    self.view.addSubview(cardView)
    self.view.layoutIfNeeded()
    return cardView
  }
  
  func getCardFrame(forIndex: Int) -> CGRect {
    var frame = CGRect.zero
    switch forIndex {
    case 0:
      frame = cardOne.frame
    case 1:
      frame = cardTwo.frame
    case 2:
      frame = cardThree.frame
    default:
      break
    }
    return frame
  }
}

//
//  InHandViewController.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 07/07/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

protocol InHandViewControllerDelegate: class {
  func didCompleteCardCreation(_ inHandViewController: InHandViewController)
}

class InHandViewController: BattleViewController {
  
  @IBOutlet private weak var cardOne: UIView!
  @IBOutlet private weak var cardTwo: UIView!
  @IBOutlet private weak var cardThree: UIView!
  @IBOutlet private weak var cardFour: UIView!
  @IBOutlet private weak var cardFive: UIView!
  
  //Assigned on Prepare Seague as a way to check if the class is working for Player One or for Player Two
  var isPlayer: Bool!
  
  //MARK: - ViewController Calls
  func createCards(allCards: [Card]) -> [CardView] {
    var cardViews: [CardView] = []
    allCards.enumerated().forEach { (index, card) in
      let cardView = createACard(card: card, cardIndex: index)
      cardViews.append(cardView)
      let bsViewController: BattleViewController = parent as! BattleViewController
      let frame = view.convert(bsViewController.playerOneDeckView.frame, from:self.view)
      performCardMoveAnimation(cardView: cardView, fromFrame: frame, forIndex: index)
    }
    return cardViews
  }
  
  //MARK: - Animation Helpers
  func performCardMoveAnimation(cardView: CardView, fromFrame: CGRect, forIndex: Int) {
    let frame = getCardFrame(forIndex: forIndex)
    UIView.animate(withDuration: Game.cardMoveAnimationSpeed,
                   delay: 0,
                   options: UIViewAnimationOptions.curveEaseIn,
                   animations: { () -> Void in
                    cardView.frame = frame
    }, completion: { (finished) -> Void in
      
    })
  }

  //MARK: - Action Methods
  //Action Methods
  func selectInHandCard(button: UIButton) {
    
  }

  
  //Helpers
  func getCardFrame(forIndex: Int) -> CGRect {
    var frame = CGRect.zero
    switch forIndex {
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
    return frame
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
    if isPlayer {
      cardView.cardButton.addTarget(self, action: #selector(selectInHandCard(button:)), for: .touchUpInside)
      toggleHidingOfLabelsOnCard(hideStatus: false, cardView: cardView)
    } else {
      toggleHidingOfLabelsOnCard(hideStatus: true, cardView: cardView)
    }
    self.view.addSubview(cardView)
    self.view.layoutIfNeeded()
    return cardView
  }

  
  func toggleHidingOfLabelsOnCard(hideStatus: Bool, cardView: CardView) {
    cardView.bpView.isHidden = hideStatus
    cardView.healthView.isHidden = hideStatus
    cardView.attackView.isHidden = hideStatus
    cardView.nameView.isHidden = hideStatus
  }
}

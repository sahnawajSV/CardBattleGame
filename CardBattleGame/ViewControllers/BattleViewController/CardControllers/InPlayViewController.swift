//
//  InPlayViewController.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 07/07/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

protocol InPlayViewControllerDelegate: class {
  func didCompleteInPlayAction(_ inPlayViewController: InPlayViewController)
  func cardSelectedInPlayToAttack(_ inPlayViewController: InPlayViewController, cardIndex: Int)
}

class InPlayViewController: UIViewController {
  
  weak var delegate: InPlayViewControllerDelegate?
  
  @IBOutlet weak var cardOne: UIView!
  @IBOutlet private weak var cardTwo: UIView!
  @IBOutlet private weak var cardThree: UIView!
  @IBOutlet private weak var cardFour: UIView!
  @IBOutlet private weak var cardFive: UIView!
  
  var allCards: [CardView] = []
  private var animActionToPerform: Int = 0
  private var animActionsCompleted: Int = 0

  func playACard(cardView: CardView, currentFrame: CGRect, cardIndex: Int) {
    cardView.cardButton.removeTarget(nil, action: nil, for: .touchUpInside)
    cardView.cardButton.tag = allCards.count
    cardView.cardButton.addTarget(self, action: #selector(selectInPlayCard(sender:)), for: .touchUpInside)
    toggleHidingOfLabelsOnCard(hideStatus: false, cardView: cardView)
    view.addSubview(cardView)
    allCards.append(cardView)
    cardView.changeCardState(cardState: .cannotAttack)
    performCardMoveAnimation(cardView: cardView, fromFrame: currentFrame, forIndex: cardIndex)
  }
  
  func removeCard(cardIndex: Int) {
    allCards.remove(at: cardIndex)
    resetCardPositions()
  }
  
  func resetCardPositions() {
    animActionToPerform = allCards.count
    animActionsCompleted = 0
    allCards.enumerated().forEach { (index, cardView) in
      cardView.cardButton.tag = index
      performCardMoveAnimation(cardView: cardView, fromFrame: cardView.frame, forIndex: index)
    }
  }
  
  //Action Methods
  func selectInPlayCard(sender: UIButton) {
    delegate?.cardSelectedInPlayToAttack(self, cardIndex: sender.tag)
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
  
  //MARK: - Animation Helpers
  func performCardMoveAnimation(cardView: CardView, fromFrame: CGRect, forIndex: Int) {
    cardView.frame = fromFrame
    let frame = getCardFrame(forIndex: forIndex)
    UIView.animate(withDuration: Game.cardMoveAnimationSpeed,
                   delay: 0,
                   options: UIViewAnimationOptions.curveEaseIn,
                   animations: { () -> Void in
                    cardView.frame = frame
    }, completion: { (finished) -> Void in
      self.delegate?.didCompleteInPlayAction(self)
    })
  }

  func toggleHidingOfLabelsOnCard(hideStatus: Bool, cardView: CardView) {
    cardView.bpView.isHidden = hideStatus
    cardView.healthView.isHidden = hideStatus
    cardView.attackView.isHidden = hideStatus
    cardView.nameView.isHidden = hideStatus
    cardView.cardImage.isHidden = hideStatus
  }
}

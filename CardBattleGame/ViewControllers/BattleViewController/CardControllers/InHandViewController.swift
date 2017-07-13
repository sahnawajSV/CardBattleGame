//
//  InHandViewController.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 07/07/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

protocol InHandViewControllerDelegate: class {
  func didCompleteInHandAction(_ inHandViewController: InHandViewController)
  func cardSelectedInHandToPlay(_ inHandViewController: InHandViewController, cardIndex: Int)
}

class InHandViewController: UIViewController {
  
  weak var delegate: InHandViewControllerDelegate?
  
  @IBOutlet private weak var cardOne: UIView!
  @IBOutlet private weak var cardTwo: UIView!
  @IBOutlet private weak var cardThree: UIView!
  @IBOutlet private weak var cardFour: UIView!
  @IBOutlet private weak var cardFive: UIView!
  
  private var selectedCardIndex: Int?
  
  private var animActionToPerform: Int = 0
  private var animActionsCompleted: Int = 0
  
  private var allCardViews: [CardView] = []
  
  //Assigned on Prepare Seague as a way to check if the class is working for Player One or for Player Two
  var isPlayer: Bool!
  
  //MARK: - ViewController Calls
  func createCards(allCards: [Card], fromFrame: CGRect) -> [CardView] {
    allCardViews.removeAll()
    animActionToPerform = allCards.count
    animActionsCompleted = 0
    allCards.enumerated().forEach { (index, card) in
      let cardView = createACard(card: card, cardIndex: index)
      allCardViews.append(cardView)
      performCardMoveAnimation(cardView: cardView, fromFrame: fromFrame, forIndex: index)
    }
    return allCardViews
  }
  
  func createACard(card: Card, fromFrame: CGRect, cardIndex: Int) -> [CardView] {
    animActionToPerform = 1
    animActionsCompleted = 0
    let cardView = createACard(card: card, cardIndex: cardIndex)
    allCardViews.append(cardView)
    performCardMoveAnimation(cardView: cardView, fromFrame: fromFrame, forIndex: cardIndex)
    return allCardViews
  }
  
  func removeCard(cardIndex: Int) {
    allCardViews.remove(at: cardIndex)
    resetCardPositions()
  }
  
  func resetCardPositions() {
    animActionToPerform = allCardViews.count
    animActionsCompleted = 0
    allCardViews.enumerated().forEach { (index, cardView) in
      cardView.cardButton.tag = index
      cardView.changeCardState(cardState: .neutral)
      performCardMoveAnimation(cardView: cardView, fromFrame: cardView.frame, forIndex: index)
    }
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
      self.animActionsCompleted += 1
      if self.animActionsCompleted == self.animActionToPerform {
        self.animActionsCompleted = 0
        self.animActionToPerform = 0
        self.delegate?.didCompleteInHandAction(self)
      }
    })
  }

  //MARK: - Action Methods
  //Action Methods
  func selectInHandCard(button: UIButton) {
    let cardClickedIndex: Int = button.tag
    allCardViews.enumerated().forEach { (index, cardView) in
      if index == cardClickedIndex {
        cardView.changeCardState(cardState: .isSelected)
      } else {
        cardView.changeCardState(cardState: .neutral)
      }
    }
    if cardClickedIndex == selectedCardIndex {
      let cardView: CardView = allCardViews[cardClickedIndex]
      cardView.changeCardState(cardState: .neutral)
      delegate?.cardSelectedInHandToPlay(self, cardIndex: cardClickedIndex)
      selectedCardIndex = nil
    } else {
      selectedCardIndex = cardClickedIndex
    }
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
    cardView.changeCardState(cardState: .neutral)
    self.view.addSubview(cardView)
    self.view.layoutIfNeeded()
    return cardView
  }
  
  func toggleHidingOfLabelsOnCard(hideStatus: Bool, cardView: CardView) {
    cardView.bpView.isHidden = hideStatus
    cardView.healthView.isHidden = hideStatus
    cardView.attackView.isHidden = hideStatus
    cardView.nameView.isHidden = hideStatus
    cardView.cardImage.isHidden = hideStatus
    cardView.cardBack.isHidden = !hideStatus
  }
}

//
//  PlayerOneInHandViewController.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 22/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

///Passes the required message to InPlayViewController once card is selected from Hand. This is required to pass the selected Index and later reset the same on card play completion
protocol InHandViewControllerDelegate: class {
  func inHandViewControllerDidSelectCardToPlay(_ inHandViewController: InHandViewController)
}

//Common class to handle all Cards in either PlayerOne or PlayerTwo Hand area
class InHandViewController: UIViewController {
  
  weak var delegate: InHandViewControllerDelegate?
  
  @IBOutlet private weak var cardOne: UIView!
  @IBOutlet private weak var cardTwo: UIView!
  @IBOutlet private weak var cardThree: UIView!
  @IBOutlet private weak var cardFour: UIView!
  @IBOutlet private weak var cardFive: UIView!
  
  //Default value when no card is selected
  var selectedCardIndex: Int?
  var isPlayer: Bool!
  var cardsAdded: [CardView] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  //  func createCard(playerInHandCards: [Card]) -> [CardView] {
  //    cardsAdded.removeAll()
  //    for (index,card) in playerInHandCards.enumerated() {
  //      let frame = getCardFrame(forIndex: index)
  //      let cardView: CardView = CardView(frame: frame)
  //      cardView.bpText.text = String(card.battlepoint)
  //      cardView.attackText.text = String(card.attack)
  //      cardView.healthText.text = String(card.health)
  //      cardView.nameText.text = card.name
  //      cardView.cardButton.tag = index
  //      if isPlayer {
  //        cardView.cardButton.addTarget(self, action: #selector(selectInHandCard(button:)), for: .touchUpInside)
  //        toggleHidingOfLabelsOnCard(hideStatus: false, cardView: cardView)
  //      } else {
  //        toggleHidingOfLabelsOnCard(hideStatus: true, cardView: cardView)
  //      }
  //      self.view.addSubview(cardView)
  //      self.view.layoutIfNeeded()
  //
  //      cardsAdded.append(cardView)
  //    }
  //
  //    return cardsAdded
  //  }
  
  func createACard(card: Card, cardIndex: Int) -> CardView {
    let frame = getCardFrame(forIndex: cardIndex)
    let cardView: CardView = CardView(frame: frame)
    cardView.bpText.text = String(card.battlepoint)
    cardView.attackText.text = String(card.attack)
    cardView.healthText.text = String(card.health)
    cardView.nameText.text = card.name
    cardView.cardButton.tag = cardIndex
    if isPlayer {
      cardView.cardButton.addTarget(self, action: #selector(selectInHandCard(button:)), for: .touchUpInside)
      toggleHidingOfLabelsOnCard(hideStatus: false, cardView: cardView)
    } else {
      toggleHidingOfLabelsOnCard(hideStatus: true, cardView: cardView)
    }
    self.view.addSubview(cardView)
    self.view.layoutIfNeeded()
    
    cardsAdded.append(cardView)
    
    return cardView
  }
  
  //Action Methods
  func selectInHandCard(button: UIButton) {
    if let olderCardIndex = selectedCardIndex {
      let cardView = cardsAdded[olderCardIndex]
      cardView.frame = CGRect(x: cardView.frame.origin.x, y: cardView.frame.origin.y + 75, width: cardView.frame.size.width, height: cardView.frame.size.height)
    }
    selectedCardIndex = button.tag
    let cardView = cardsAdded[button.tag]
    toggleHidingOfLabelsOnCard(hideStatus: false, cardView: cardView)
    cardView.frame = CGRect(x: cardView.frame.origin.x, y: cardView.frame.origin.y - 75, width: cardView.frame.size.width, height: cardView.frame.size.height)
    delegate?.inHandViewControllerDidSelectCardToPlay(self)
  }
  
  //Helpers
  func toggleHidingOfLabelsOnCard(hideStatus: Bool, cardView: CardView) {
    cardView.bpView.isHidden = hideStatus
    cardView.healthView.isHidden = hideStatus
    cardView.attackView.isHidden = hideStatus
    cardView.nameView.isHidden = hideStatus
  }
  
  //Helper
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
  
  func performCardAnimation(cardView: CardView, forIndex: Int) {
    let frame = getCardFrame(forIndex: forIndex)
    UIView.animate(withDuration: Game.cardMoveAnimationSpeed,
                   delay: 0,
                   options: UIViewAnimationOptions.curveEaseIn,
                   animations: { () -> Void in
                    cardView.frame = frame
    }, completion: { (finished) -> Void in
      
    })
  }
}

//
//  PlayerOneInPlayViewController.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 22/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit


protocol InPlayViewControllerDelegate: class {
  func createInPlayCardsForPlayerOne()
}


class InPlayViewController: UIViewController {
  
  weak var delegate: InPlayViewControllerDelegate?

  @IBOutlet private weak var cardOne: UIView!
  @IBOutlet private weak var cardTwo: UIView!
  @IBOutlet private weak var cardThree: UIView!
  @IBOutlet private weak var cardFour: UIView!
  @IBOutlet private weak var cardFive: UIView!
  
  private var cardToPlay: CardView?
  private var inHandController: InHandViewController?
  private var selectedTargetPosition: Int = 99
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
  func updateInHandData(cardView: CardView) -> Bool {
    cardToPlay = cardView
    return createCard()
  }
  
  func createCard() -> Bool {
    guard let cardView = cardToPlay else {
      return false
    }
    var cardsAdded: [CardView] = []
    var frame = CGRect.zero
    switch selectedTargetPosition {
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
    cardView.frame = frame
    cardView.cardButton.tag = selectedTargetPosition
    cardView.cardButton.removeTarget(nil, action: nil, for: .touchUpInside)
    cardView.cardButton.addTarget(self, action: #selector(selectInPlayCard(button:)), for: .touchUpInside)
    self.view.addSubview(cardView)

    cardsAdded.append(cardView)
    selectedTargetPosition = 99
    
    return true
  }
  
  //Action Methods
  @IBAction private func moveCardToTarget(sender: UIButton) {
    selectedTargetPosition = sender.tag
    tellDelegateToMoveCard()
  }
  
  func selectInPlayCard(button: UIButton) {
    
  }
  
  //Delegate Notifications
  func tellDelegateToMoveCard() {
    delegate?.createInPlayCardsForPlayerOne()
  }
}

//
//  PlayerOneInPlayViewController.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 22/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

///Passes the required message to BattleSystemViewController once card is selected either from the HAND to Play area or from Play area to perform an attack
protocol InPlayViewControllerDelegate: class {
  func inPlayViewControllerDidChangeSelectedTargetPosition(_ inPlayViewController: InPlayViewController, cardIndex: Int)
  func inPlayViewControllerDidSelectCardForAttack(_ inPlayViewController: InPlayViewController)
}

//Common class to handle all Cards in either PlayerOne or PlayerTwo Play area
class InPlayViewController: UIViewController, InHandViewControllerDelegate {
  
  weak var delegate: InPlayViewControllerDelegate?

  @IBOutlet weak var cardOne: UIView!
  @IBOutlet weak var cardTwo: UIView!
  @IBOutlet weak var cardThree: UIView!
  @IBOutlet weak var cardFour: UIView!
  @IBOutlet weak var cardFive: UIView!
  
  private var cardToPlay: CardView?
  var selectedInHandCardIndex: Int?
  var selectedTargetPosition: Int?
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
  func updateInHandData(cardView: CardView) -> Bool {
    cardToPlay = cardView
    return createCard()
  }
  
  func createCard() -> Bool {
    guard let cardView = cardToPlay, let targetPosition = selectedTargetPosition else {
      return false
    }
    var frame = CGRect.zero
    switch targetPosition {
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
    cardView.cardButton.tag = cardView.cardIndex
    cardView.cardButton.removeTarget(nil, action: nil, for: .touchUpInside)
    cardView.cardButton.addTarget(self, action: #selector(selectInPlayCard(sender:)), for: .touchUpInside)
    self.view.addSubview(cardView)
    self.view.bringSubview(toFront: cardView)
    self.view.layoutIfNeeded()
    selectedTargetPosition = nil
    
    return true
  }
  
  //Action Methods
  @IBAction private func moveCardToTarget(sender: UIButton) {
    selectedTargetPosition = sender.tag
    tellDelegateToMoveCard()
  }
  
  func selectInPlayCard(sender: UIButton) {
    selectedTargetPosition = sender.tag
    didSelectCardForAttack()
  }
  
  //Delegate Notifications
  func tellDelegateToMoveCard() {
    guard let targetPosition = selectedInHandCardIndex else {
      return
    }
    delegate?.inPlayViewControllerDidChangeSelectedTargetPosition(self, cardIndex: targetPosition)
  }
  
  func didSelectCardForAttack() {
    delegate?.inPlayViewControllerDidSelectCardForAttack(self)
  }
  
  //Delegate Methods
  func inHandViewControllerDidSelectCardToPlay(_ inHandViewController: InHandViewController)
  {
    selectedInHandCardIndex = inHandViewController.selectedCardIndex
  }
}

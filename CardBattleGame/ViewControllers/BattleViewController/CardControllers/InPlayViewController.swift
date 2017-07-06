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
  
  func updateInHandData(cardView: CardView, olderFrame: CGRect) -> CardView {
    cardToPlay = cardView
    return createCard(olderFrame: olderFrame)
  }
  
  func createCard(olderFrame: CGRect) -> CardView {
    guard let cardView = cardToPlay, let targetPosition = selectedTargetPosition else {
      return CardView()
    }
    let frame = getCardFrame(forIndex: targetPosition)
    cardView.frame = olderFrame
    cardView.cardButton.tag = cardView.cardIndex
    cardView.cardButton.removeTarget(nil, action: nil, for: .touchUpInside)
    cardView.cardButton.addTarget(self, action: #selector(selectInPlayCard(sender:)), for: .touchUpInside)
    self.view.addSubview(cardView)
    self.view.bringSubview(toFront: cardView)
    self.view.layoutIfNeeded()
    selectedTargetPosition = nil
    performCardMoveAnimation(cardView: cardView, toFrame: frame)
    toggleHidingOfLabelsOnCard(hideStatus: false, cardView: cardView)
    return cardView
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
  
  //Helpers
  func performCardMoveAnimation(cardView: CardView, toFrame: CGRect) {
    UIView.animate(withDuration: Game.cardMoveAnimationSpeed,
                   delay: 0,
                   options: UIViewAnimationOptions.curveEaseIn,
                   animations: { () -> Void in
                    cardView.frame = toFrame
    }, completion: { (finished) -> Void in
      
    })
  }
  
  func performCardToIndexAnimation(cardView: CardView, forIndex: Int) {
    let frame = getCardFrame(forIndex: forIndex)
    UIView.animate(withDuration: Game.cardMoveAnimationSpeed,
                   delay: 0,
                   options: UIViewAnimationOptions.curveEaseIn,
                   animations: { () -> Void in
                    cardView.frame = frame
    }, completion: { (finished) -> Void in
      
    })
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
    case 3:
      frame = cardFour.frame
    case 4:
      frame = cardFive.frame
    default:
      break
    }
    
    return frame
  }
  
  func performCardAttackAnimation(cardView: CardView, toFrame: CGRect) {
    let originalFrame = cardView.frame
    let moveAnimYValue: CGFloat = 100
    let attackAnimYValue = CGFloat(toFrame.size.height / 2.0)
    UIView.animate(withDuration: Game.cardMoveToAttackPosAnimationSpeed,
                   delay: 0,
                   options: UIViewAnimationOptions.curveEaseIn,
                   animations: { () -> Void in
                    cardView.frame = CGRect(x: toFrame.origin.x, y: toFrame.origin.y + moveAnimYValue, width: cardView.frame.size.width, height: cardView.frame.size.height)
    }, completion: { (finished) -> Void in
      UIView.animate(withDuration: Game.cardAttackAnimationSpeed,
                     delay: 0,
                     options: UIViewAnimationOptions.curveEaseIn,
                     animations: { () -> Void in
                      cardView.frame = CGRect(x: toFrame.origin.x, y: toFrame.origin.y + attackAnimYValue, width: cardView.frame.size.width, height: cardView.frame.size.height)
      }, completion: { (finished) -> Void in
        UIView.animate(withDuration: Game.cardAttackAnimationSpeed,
                       delay: 0,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        cardView.frame = CGRect(x: toFrame.origin.x, y: toFrame.origin.y + moveAnimYValue, width: cardView.frame.size.width, height: cardView.frame.size.height)
        }, completion: { (finished) -> Void in
          UIView.animate(withDuration: Game.cardMoveToAttackPosAnimationSpeed,
                         delay: 0.25,
                         options: UIViewAnimationOptions.curveEaseIn,
                         animations: { () -> Void in
                          cardView.frame = originalFrame
          }, completion: { (finished) -> Void in
            
          })
        })
      })
    })
  }
  
  func performCardAttackAnimationForPlayerTwo(cardView: CardView, toFrame: CGRect) {
    let originalFrame = cardView.frame
    let moveAnimYValue: CGFloat = -100
    let attackAnimYValue = CGFloat(toFrame.size.height / 2.0)
    UIView.animate(withDuration: Game.cardMoveToAttackPosAnimationSpeed,
                   delay: 0,
                   options: UIViewAnimationOptions.curveEaseIn,
                   animations: { () -> Void in
                    cardView.frame = CGRect(x: toFrame.origin.x, y: toFrame.origin.y + moveAnimYValue, width: cardView.frame.size.width, height: cardView.frame.size.height)
    }, completion: { (finished) -> Void in
      UIView.animate(withDuration: Game.cardAttackAnimationSpeed,
                     delay: 0,
                     options: UIViewAnimationOptions.curveEaseIn,
                     animations: { () -> Void in
                      cardView.frame = CGRect(x: toFrame.origin.x, y: toFrame.origin.y + attackAnimYValue, width: cardView.frame.size.width, height: cardView.frame.size.height)
      }, completion: { (finished) -> Void in
        UIView.animate(withDuration: Game.cardAttackAnimationSpeed,
                       delay: 0,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        cardView.frame = CGRect(x: toFrame.origin.x, y: toFrame.origin.y + moveAnimYValue, width: cardView.frame.size.width, height: cardView.frame.size.height)
        }, completion: { (finished) -> Void in
          UIView.animate(withDuration: Game.cardMoveToAttackPosAnimationSpeed,
                         delay: 0.25,
                         options: UIViewAnimationOptions.curveEaseIn,
                         animations: { () -> Void in
                          cardView.frame = originalFrame
          }, completion: { (finished) -> Void in
            
          })
        })
      })
    })
  }
  
  
  //Helpers
  func toggleHidingOfLabelsOnCard(hideStatus: Bool, cardView: CardView) {
    cardView.bpView.isHidden = hideStatus
    cardView.healthView.isHidden = hideStatus
    cardView.attackView.isHidden = hideStatus
    cardView.nameView.isHidden = hideStatus
  }
}

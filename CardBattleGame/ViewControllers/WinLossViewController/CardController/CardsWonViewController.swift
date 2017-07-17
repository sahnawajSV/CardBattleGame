//
//  CardsWonViewController.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 12/07/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

extension CardsWonViewController {
  static let cardWidth: CGFloat = 206
  static let cardHeight: CGFloat = 270
  static let gapOffset: CGFloat = 20
}


class CardsWonViewController: UIViewController, UIScrollViewDelegate {
  @IBOutlet weak var scrollView: UIScrollView!
  
  private var allCardViews: [CardView] = []
  
  override func viewDidLoad() {
    scrollView.delegate = self
  }
  
  func createWinningCardsView(allCards: [Card]) -> [CardView] {
    allCardViews.removeAll()
    allCards.enumerated().forEach { (index, card) in
      let cardView = createACard(card: card, cardIndex: index)
      allCardViews.append(cardView)
    }
    let contentWidth = (CardsWonViewController.cardWidth + CardsWonViewController.gapOffset) * CGFloat(allCards.count)
    scrollView.contentSize = CGSize(width: contentWidth, height: CardsWonViewController.cardHeight)
    if contentWidth < scrollView.bounds.size.width {
      let newContentOffsetX: CGFloat = (scrollView.contentSize.width/2) - (scrollView.bounds.size.width/2)
      scrollView.contentOffset = CGPoint(x: newContentOffsetX, y: 0);
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
    scrollView.addSubview(cardView)
    self.view.layoutIfNeeded()
    return cardView
  }

  
  //Helpers
  func getCardFrame(forIndex: Int) -> CGRect {
    var frame = CGRect.zero
    if forIndex == 0 {
      frame = CGRect(x: 0, y: 0, width: CardsWonViewController.cardWidth, height: CardsWonViewController.cardHeight)
    } else {
      frame = CGRect(x: allCardViews[forIndex-1].frame.origin.x + allCardViews[forIndex-1].frame.size.width + CardsWonViewController.gapOffset, y: 0, width: CardsWonViewController.cardWidth, height: CardsWonViewController.cardHeight)
    }
    return frame
  }
}

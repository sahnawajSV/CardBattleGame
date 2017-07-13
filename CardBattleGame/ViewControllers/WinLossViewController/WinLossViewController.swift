//
//  WinLossViewController.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 10/07/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit

class WinLossViewController: UIViewController {
  
  @IBOutlet weak var winStatusText: UILabel!
  private var winningsViewController: CardsWonViewController!
  var isVictorious: Bool!
  private var plWinnings: [Card]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let globalCardData = CardListDataSource()
    let cardList = globalCardData.fetchCardList()
    
    if isVictorious {
      winStatusText.text = "WINNER!!!"
      plWinnings = randomCards(cardArray: cardList, num: Game.cardsAwardedOnWin)
    } else {
      winStatusText.text = "DEFEAT!!!"
      plWinnings = randomCards(cardArray: cardList, num: Game.cardsAwardedOnLoss)
    }
    displayWinnings()
  }
  
  func displayWinnings() {
    let _ = winningsViewController.createCards(allCards: plWinnings)
  }
  
  //MARK: - Action Methods
  @IBAction private func backToMainMenu(sender: UIButton) {
    navigationController?.popToRootViewController(animated: true)
  }
  
  //MARK: - Container View Preparation Segue
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else {
      return
    }
    
    switch identifier {
    case "Winnings":
      if let winnings = segue.destination as? CardsWonViewController {
        winningsViewController = winnings
      }
      break
    default:
      break
    }
  }

}

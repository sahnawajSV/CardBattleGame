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
  private var winnings: [Card]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let globalCardData = CardListDataSource()
    let cardList = globalCardData.fetchCardList()
    isVictorious = true
    if isVictorious {
      winStatusText.text = "WINNER!!!"
      winnings = cardList.subArray(size: Game.cardsAwardedOnWin)
    } else {
      winStatusText.text = "DEFEAT!!!"
      winnings = cardList.subArray(size: Game.cardsAwardedOnLoss)
    }
    displayWinnings()
  }
  
  func displayWinnings() {
    let _ = winningsViewController.createWinningCardsView(allCards: winnings)
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
    default:
      break
    }
  }

}

//
//  EditDeckViewController.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 14/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit
import CoreData


/// EditDeckViewController : Create Deck, Edit or Delete Existing Deck
class EditDeckViewController: UIViewController {
  fileprivate let height: CGFloat = 328
  fileprivate let margin: CGFloat = 15
  
  fileprivate var editDeckViewModel = EditDeckViewModel()
  
  @IBOutlet weak var deckNameTextField: UITextField!
  @IBOutlet weak var selectedDeckTableView: UITableView!
  @IBOutlet weak var deckCollectionView: UICollectionView!
  
  @IBOutlet weak var selectedDeckLabel: UILabel!
  
  fileprivate let tableViewCellReuseIdentifier = "tableViewCellReuseIdentifier"
  fileprivate let cellReuseIdentifier = "CellIdentifier"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Set EditDeck Model View Delegate
    deckCollectionView.delegate = self
    deckCollectionView.dataSource = self
    
    updateSelectedCardLabel()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //  Mark :  Helper Method
  //
  fileprivate func updateSelectedCardLabel() {
    selectedDeckLabel.text = String(format: "\(numberOfAddedCards()) - \(Game.maximumCardPerDeck)")
  }
  
  
  /// Fetch the cad count selected for a deck
  ///
  /// - Returns: Total Number of cards
  fileprivate func numberOfAddedCards() -> Int {
    return editDeckViewModel.numberOfAddedCards()
  }
  
  /// Update Card Collection View
  fileprivate func updateView() {
    deckCollectionView.reloadData()
    selectedDeckTableView.reloadData()
    updateSelectedCardLabel()
  }
  
  // MARK : Action
  //
  @IBAction func saveDeckAction(_ sender: Any) {
    if let name = deckNameTextField.text, !name.isEmpty {
      //create deck with name
      editDeckViewModel.saveCardsToDeck(with: name)
      navigationController?.popViewController(animated: true)
    } else {
      cbg_presentErrorAlert(withTitle: "Error", message: "Please Enter the Deck Name.")
    }
  }
  
  @IBAction func addButtonTapped(_ sender: UIButton) {
    let cardList: [Card] = editDeckViewModel.fetchCards()
    let card = cardList[sender.tag]
    editDeckViewModel.addCardToDeckList(card)
    updateView()
  }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension EditDeckViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return numberOfAddedCards()
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellReuseIdentifier, for: indexPath) as! EditDeckCardTableViewCell
    if let newItem: Card = editDeckViewModel.card(at: indexPath.row) {
      cell.cardNameLabel?.text = newItem.name
      cell.tag = Int(newItem.id)
    }
    return cell
  }
  
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    guard editingStyle == .delete else {
      return
    }
    
    if let cell : EditDeckCardTableViewCell = tableView.cellForRow(at: indexPath) as? EditDeckCardTableViewCell {
      let cardList: [Card] = editDeckViewModel.fetchCards()
      for card in cardList {
        if card.id == Int16(cell.tag) {
          editDeckViewModel.removeCardFromDeckList(at: indexPath.row)
          break
        }
      }
      updateView()
    }
  }
  
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
extension EditDeckViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
  
  // Collection View - Number Of Items In Section
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return editDeckViewModel.numberOfCards()
  }
  
  
  // Collection View - Cell For Row At Index Path
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! EditDeckCollectionViewCell
    
    
    let cardList: [Card] = editDeckViewModel.fetchCards()
    let card = cardList[indexPath.row]
    
    cell.attackLbl.text = String(describing: card.attack)
    cell.healthLbl.text = String(describing: card.health)
    cell.battlePointLbl.text = String(describing: card.battlepoint)
    cell.nameLbl.text = String(describing: card.name)
    
    if editDeckViewModel.isCardSelected(card) {
      cell.addDeckButton.isHidden = true
    } else {
      cell.addDeckButton.isHidden = false
    }
    
    cell.addDeckButton.addTarget(self, action: #selector(addButtonTapped), for: UIControlEvents.touchUpInside)
    cell.addDeckButton.tag = indexPath.row
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: CGFloat((collectionView.frame.size.width / 3) - margin), height: height)
  }
  
}

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
   
  fileprivate var editDeckViewModel = EditDeckViewModel()
  
  @IBOutlet weak var deckNameTextField: UITextField!
  @IBOutlet weak var selectedDeckTableView: UITableView!
  @IBOutlet weak var deckCollectionView: UICollectionView!
  @IBOutlet weak var saveDeckButton: UIButton!
  
  @IBOutlet weak var selectedDeckLabel: UILabel!
  
  fileprivate let tableViewCellReuseIdentifier = "tableViewCellReuseIdentifier"
  fileprivate let cellReuseIdentifier = "CellIdentifier"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Set EditDeck Model View Delegate
    deckCollectionView.delegate = self
    deckCollectionView.dataSource = self
    
    selectedDeckLabel.roundBorder(cornerRadius: 4.0, borderWidth: 2.0, borderColor: UIColor.white.cgColor)
    saveDeckButton.roundBorder(cornerRadius: 4.0, borderWidth: 2.0, borderColor: UIColor.white.cgColor)

    updateSelectedCardLabel()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    deckCollectionView.reloadData()
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
    guard let name = deckNameTextField.text, !name.isEmpty else {
      cbg_presentErrorAlert(withTitle: "Error", message: "Please Enter the Deck Name.")
      return
    }
    guard numberOfAddedCards() > EditDeckViewModel.minimumCardLimit else {
      cbg_presentErrorAlert(withTitle: "Error", message: "Minimum 5 cards required to create a Deck.")
      return
    }
    editDeckViewModel.saveCardsToDeck(with: name)
    navigationController?.popViewController(animated: true)
  }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension EditDeckViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return numberOfAddedCards()
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellReuseIdentifier, for: indexPath) as? EditDeckCardTableViewCell {
      if let newItem: Card = editDeckViewModel.card(at: indexPath.row) {
        cell.cardNameLabel?.text = newItem.name
        cell.cardNameLabel.roundBorder(cornerRadius: 4.0, borderWidth: 2.0, borderColor: UIColor.white.cgColor)
        cell.tag = Int(newItem.id)
      }
      return cell
    }
    fatalError("Unresolved Error")
  }
  
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    guard editingStyle == .delete else {
      return
    }
    
    if let cell = tableView.cellForRow(at: indexPath) as? EditDeckCardTableViewCell {
      let cardList: [Card] = editDeckViewModel.playerOwnedCards
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
extension EditDeckViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, EditDeckCollectionViewCellDelegate {
  
  // Collection View - Number Of Items In Section
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return editDeckViewModel.numberOfCards()
  }
  
  
  // Collection View - Cell For Row At Index Path
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? EditDeckCollectionViewCell {
    
      let cardList: [Card] = editDeckViewModel.playerOwnedCards
      let card = cardList[indexPath.row]
      
      cell.attackLbl.text = String(describing: card.attack)
      cell.healthLbl.text = String(describing: card.health)
      cell.battlePointLbl.text = String(describing: card.battlepoint)
      cell.nameLbl.text = String(describing: card.name)
      
      if card.quantity > 0 {
        cell.addDeckButton.isHidden = false
        cell.cardQuantityLbl.isHidden = false
        cell.cardQuantityLbl.text = String(describing: card.quantity)
      } else {
        cell.addDeckButton.isHidden = true
        cell.cardQuantityLbl.isHidden = true
      }
      
      cell.cellDelegate = self
      cell.addDeckButton.roundBorder(cornerRadius: 8.0, borderWidth: 2.0, borderColor: UIColor.white.cgColor)
      
      cell.cardView.roundBorder(cornerRadius: 8.0, borderWidth: 2.0, borderColor: UIColor.white.cgColor)
      cell.cardView.clipsToBounds = true
      
      return cell
    }
    fatalError("Unresolved Error")
  }
  
  func didPressAddButton(_ sender: UICollectionViewCell) {
    guard numberOfAddedCards() < EditDeckViewModel.maximumCardLimit else {
      cbg_presentErrorAlert(withTitle: "Error", message: "You can not add more than 20 cards.")
      return
    }
    if let indexPath = deckCollectionView.indexPath(for: sender) {
      editDeckViewModel.addCardToDeck(from: indexPath)
      updateView()
    }
  }
}

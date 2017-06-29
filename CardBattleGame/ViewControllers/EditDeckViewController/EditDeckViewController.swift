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
  
  var editDeckViewModel = EditDeckViewModel()
  
  @IBOutlet weak var selectedDeckTableView: UITableView!
  @IBOutlet weak var deckCollectionView: UICollectionView!
  
  @IBOutlet weak var selectedDeckLabel: UILabel!
  
  
  fileprivate let identifier = "CellIdentifier"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    self.deckCollectionView.delegate = self
    self.deckCollectionView.dataSource = self
    
    // Set EditDeck Model View Delegate
    editDeckViewModel.delegate = self
    editDeckViewModel.performDeckCardFetchRequest()
    
    updateSelectedCardLabel()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  //  Mark :  Helper Method
  //
  fileprivate func updateSelectedCardLabel() {
    self.selectedDeckLabel.text = String(format: "\(numberOfCardAdded()) - \(Game.maximumCardPerDeck)")
  }
  
  /// Number of cards available in the storage
  ///
  /// - Returns: Total Number of cards
  fileprivate func numberOfCardAdded() -> Int {
    return editDeckViewModel.numberOfCardAdded()
  }
  
  /// Update Card Collection View
  fileprivate func reloadCollectionView() {
    deckCollectionView.reloadData()
  }
  
  // MARK : Action
  //
  @IBAction func saveDeckAction(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func addButtonTapped(_ sender: UIButton) {
    
    let cardList: [Card] = editDeckViewModel.fetchCardFromPlist()
    let card = cardList[sender.tag]
    editDeckViewModel.addCardToDeckCardEntity(card)
    
    reloadCollectionView()
  }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension EditDeckViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return numberOfCardAdded()
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell:UITableViewCell = UITableViewCell.init(style: .default,
                                                    reuseIdentifier: nil)as UITableViewCell!
    
    if let newItem: DeckCard = editDeckViewModel.fetchDeckCard(at: indexPath) {
      cell.textLabel?.text = newItem.name
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
    
    let cell : UITableViewCell = tableView.cellForRow(at: indexPath)!
    let cardList: [Card] = editDeckViewModel.fetchCardFromPlist()
    
    for card in cardList {
      if card.id == Int16(cell.tag) {
        editDeckViewModel.deleteCardFromDeckCardEntity(card)
        break
      }
    }
    reloadCollectionView()
  }
  
}


// MARK: - EditDeckViewModelDelegate
extension EditDeckViewController: EditDeckViewModelDelegate {
  func deckCardEntityWillChangeContent() {
    selectedDeckTableView.beginUpdates()
  }
  
  func deckCardEntity(didChangeObjectAt indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .insert:
      if let index = newIndexPath {
        selectedDeckTableView.insertRows(at: [IndexPath(row: index.row, section: 0)], with: .fade)
      }
    case .delete:
      if let index = indexPath {
        selectedDeckTableView.deleteRows(at: [IndexPath(row: index.row, section: 0)], with: .fade)
      }
    default:
      break
    }
  }
  
  func deckCardEntityDidChangeContent() {
    selectedDeckTableView.endUpdates()
    updateSelectedCardLabel()
  }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
extension EditDeckViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
  
  // Collection View - Number Of Items In Section
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return editDeckViewModel.numberOfCardInPlist()
  }
  
  
  // Collection View - Cell For Row At Index Path
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! EditDeckCollectionViewCell
    
    
    let cardList: [Card] = editDeckViewModel.fetchCardFromPlist()
    let card = cardList[indexPath.row]
    
    cell.attackLbl.text = String(describing: card.attack)
    cell.healthLbl.text = String(describing: card.health)
    cell.battlePointLbl.text = String(describing: card.battlepoint)
    cell.nameLbl.text = String(describing: card.name)
    
    if editDeckViewModel.isCardAvailableInDeckCardStorage(card) {
      cell.addDeckButton.isHidden = true
    } else {
      cell.addDeckButton.isHidden = false
    }
    
    cell.addDeckButton.addTarget(self, action: #selector(addButtonTapped), for: UIControlEvents.touchUpInside)
    cell.addDeckButton.tag = indexPath.row
    
    
    return cell
  }
  
  // MARK:- UICollectionViewDelegate Methods
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: CGFloat((collectionView.frame.size.width / 3) - 15), height: CGFloat(328))
  }
  
}

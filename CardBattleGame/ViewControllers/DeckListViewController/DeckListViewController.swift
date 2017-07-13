//
//  DeckListViewController.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 14/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit
import CoreData

/// Deck List View Controller : Display list of Decks created by the user.
class DeckListViewController: UIViewController {
  var deckListViewModel = DeckListViewModel()
  
  fileprivate let tableViewCellReuseIdentifier = "tableViewCellReuseIdentifier"
  fileprivate let cellReuseIdentifier = "CellIdentifier"
  private let battleSegueIdentifier = "battleIndentifier"
  
  @IBOutlet weak var deckCollectionView: UICollectionView!
  @IBOutlet weak var deckCardsTableView: UITableView!
  @IBOutlet weak var deckNameLabel: UILabel!
  @IBOutlet weak var battleButton: UIButton!
  @IBOutlet weak var backButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    deckCollectionView.delegate = self
    deckCollectionView.dataSource = self
    
    deckCardsTableView.delegate = self
    deckCardsTableView.dataSource = self
    
    battleButton.roundBorder(cornerRadius: 4.0, borderWidth: 2.0, borderColor: UIColor.white.cgColor)
    backButton.roundBorder(cornerRadius: 4.0, borderWidth: 2.0, borderColor: UIColor.white.cgColor)
    
    deckListViewModel.performDeckCardFetchRequest()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Navigation
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    if segue.identifier == battleSegueIdentifier, let battleSystemVC = segue.destination as? BattleSystemViewController, let indexpath = sender as? IndexPath {
      battleSystemVC.deck = deckListViewModel.fetchDeck(at: indexpath)
    }
  }
  
  func updateView() {
    deckCardsTableView.reloadData()
    deckNameLabel.text = deckListViewModel.deckNameText
  }
  
  /// Back Action
  @IBAction func backAction(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  /// Battle Action
  @IBAction func battleAction(_ sender: Any) {
    if let index = deckListViewModel.selectedDeckIndex {
      performSegue(withIdentifier: battleSegueIdentifier, sender: index)
    } else {
      cbg_presentErrorAlert(withTitle: "Error", message: "Please select the Deck.")
    }
  }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
extension DeckListViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
  
  // Collection View - Number Of Items In Section
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return deckListViewModel.numberOfDecks()
  }
  
  
  // Collection View - Cell For Row At Index Path
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? DeckCollectionViewCell {
      if let newItem: Deck = deckListViewModel.fetchDeck(at: indexPath) {
        cell.nameLbl.text = newItem.name
      }
      cell.cardView.roundBorder(cornerRadius: 8.0, borderWidth: 2.0, borderColor: UIColor.white.cgColor)
      cell.cardView.clipsToBounds = true
      return cell
    }
    fatalError("Unresolved error")
  }
  
  // MARK:- UICollectionViewDelegate Methods
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    deckListViewModel.selectDeck(at: indexPath)
    updateView()
  }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension DeckListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return deckListViewModel.numberOfCards()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellReuseIdentifier, for: indexPath) as? DeckCardTableViewCell {
      let newItem: DeckCard = deckListViewModel.fetchCardFromSelectedDeck(at: indexPath)
      cell.cardNameLabel?.text = newItem.name
      cell.cardNameLabel.roundBorder(cornerRadius: 4.0, borderWidth: 2.0, borderColor: UIColor.white.cgColor)
      return cell
    }
    fatalError("Unresolved error")
  }
  
}



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
  
  fileprivate let identifier = "CellIdentifier"
  
  @IBOutlet weak var deckCollectionView: UICollectionView!
  @IBOutlet weak var deckCardsTableView: UITableView!
  @IBOutlet weak var deckNameLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.deckCollectionView.delegate = self
    self.deckCollectionView.dataSource = self
    
    self.deckCardsTableView.delegate = self
    self.deckCardsTableView.dataSource = self
    
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
    if segue.identifier == "battleIndentifier", let battleSystemVC = segue.destination as? BattleSystemViewController {
      if let indexpath = sender as? IndexPath {
        battleSystemVC.deck = deckListViewModel.fetchDeck(at: indexpath)
      }
    }
  }
  
  func updateView() {
    self.deckCardsTableView .reloadData()
    deckNameLabel.text = deckListViewModel.deckNameText
  }
  
  /// Back Action
  @IBAction func backAction(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
  }
  /// Battle Action
  @IBAction func battleAction(_ sender: Any) {
    if let index = deckListViewModel.selectedDeckIndex {
      performSegue(withIdentifier: "battleIndentifier", sender: index)
    } else {
      errorAlert(errorTitle: "Error", errorMsg: "Please select the Deck.")
    }
  }
  
  /// Show Alert
  ///
  /// - Parameters:
  ///   - errorTitle: errorTitle description
  ///   - errorMsg: errorMsg description
  private func errorAlert(errorTitle: String, errorMsg: String){
    let alertController =  UIAlertController(title: errorTitle, message: errorMsg, preferredStyle: UIAlertControllerStyle.alert)
    let okAction  = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) in
    }
    alertController.addAction(okAction)
    self.navigationController?.present(alertController, animated: true, completion: nil)
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
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! DeckCollectionViewCell
    
    
    if let newItem: Deck = deckListViewModel.fetchDeck(at: indexPath) {
      cell.nameLbl.text = newItem.name
    }
    return cell
  }
  
  
  
  // MARK:- UICollectionViewDelegate Methods
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: CGFloat((collectionView.frame.size.width / 3) - 15), height: CGFloat(328))
  }
  
  // MARK:- UICollectionViewDelegate Methods
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    deckListViewModel.selectedDeck(at: indexPath)
    highlightCell(indexPath, flag: true)
    updateView()
  }
  
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    highlightCell(indexPath, flag: false)
  }
  
  // MARK:- Highlight
  func highlightCell(_ indexPath : IndexPath, flag: Bool) {
    
    let cell = deckCollectionView.cellForItem(at: indexPath)
    
    if flag {
      cell?.contentView.backgroundColor = UIColor.orange
    } else {
      cell?.contentView.backgroundColor = nil
    }
  }
  
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension DeckListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return deckListViewModel.numberOfCards()
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell:UITableViewCell = UITableViewCell.init(style: .default,
                                                    reuseIdentifier: nil)as UITableViewCell!
    let newItem: DeckCard = deckListViewModel.fetchCardFromSelectedDeck(at: indexPath)
    cell.textLabel?.text = newItem.name
    return cell
  }
  
}


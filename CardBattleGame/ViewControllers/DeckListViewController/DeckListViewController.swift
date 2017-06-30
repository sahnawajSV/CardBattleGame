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
  
  // NSFetchedResultsController to updated uitableview if there is any changes in the Coredata storage
  var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
  
  
  fileprivate let identifier = "CellIdentifier"
  
  @IBOutlet weak var deckCollectionView: UICollectionView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  // MARK: - Navigation
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

  }
}

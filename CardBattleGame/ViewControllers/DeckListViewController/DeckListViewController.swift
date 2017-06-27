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
    
    initializeFetchedResultsController()
    
    self.deckCollectionView.delegate = self
    self.deckCollectionView.dataSource = self
    
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
    
  }
  
  //Creating a Fetched Results Controller
  private func initializeFetchedResultsController() {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cards")
    let departmentSort = NSSortDescriptor(key: "id", ascending: true)
    request.sortDescriptors = [departmentSort]
    let moc = CoreDataStackManager.sharedInstance.managedObjContext()
    fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
    
    do {
      
      try fetchedResultsController.performFetch()
      
    } catch {
      
      fatalError("Failed to initialize FetchedResultsController: \(error)")
    }
  }
  
  /// Back Action
  @IBAction func backAction(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
extension DeckListViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
  
  // Collection View - Number Of Items In Section
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let sections = fetchedResultsController.sections else {
      fatalError("No sections in fetchedResultsController")
    }
    let sectionInfo = sections[0]
    return sectionInfo.numberOfObjects
  }
  
  
  // Collection View - Cell For Row At Index Path
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! DeckCollectionViewCell
    
    
    let newItem: Cards = fetchedResultsController.object(at: IndexPath(row: indexPath.row, section: 0)) as! Cards

    cell.attackLbl.text = String(describing: newItem.attack)
    cell.healthLbl.text = String(describing: newItem.health)
    cell.battlePointLbl.text = String(describing: newItem.battlepoint)
    cell.nameLbl.text = String(describing: newItem.name)
    
    return cell
  }
  
  // MARK:- UICollectionViewDelegate Methods
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: CGFloat((collectionView.frame.size.width / 3) - 15), height: CGFloat(328))
  }
  
}

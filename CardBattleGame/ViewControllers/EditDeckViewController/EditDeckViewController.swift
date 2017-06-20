//
//  EditDeckViewController.swift
//  CardBattleGame
//
//  Created by Vishal Aggarwal on 14/06/17.
//  Copyright © 2017 SAHNAWAJ BISWAS. All rights reserved.
//

import UIKit
import CoreData

class EditDeckViewController: UIViewController {
  
  // NSFetchedResultsController to updated uitableview if there is any changes in the Coredata storage
  var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
  
  
  var editDeckViewModel = EditDeckViewModel()
  
  @IBOutlet weak var selectedDeckTableView: UITableView!
  @IBOutlet weak var deckCollectionView: UICollectionView!
  
  @IBOutlet weak var selectedDeckLabel: UILabel!
  
  
  fileprivate let identifier = "CellIdentifier"
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    
    self.deckCollectionView.delegate = self
    self.deckCollectionView.dataSource = self
    
    self.selectedDeckTableView.delegate = self
    self.selectedDeckTableView.dataSource = self
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  //#pragma mark - Creating a Fetched Results Controller
  func initializeFetchedResultsController() {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Cards")
    let departmentSort = NSSortDescriptor(key: "id", ascending: true)
    request.sortDescriptors = [departmentSort]
    let moc = CoreDataStackManager.sharedInstance.managedObjContext()
    fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
    fetchedResultsController.delegate = self
    
    do {
      
      try fetchedResultsController.performFetch()
      
    } catch {
      
      fatalError("Failed to initialize FetchedResultsController: \(error)")
    }
  }
  
  
  
  @IBAction func saveDeckAction(_ sender: Any) {
    
  }
  
  // Add Deck Button Action
  @IBAction func addButtonTapped(_ sender: UIButton) {
    
    let cardList: [Card] = CardListDataSource.sharedInstance.fetchCardList()
    let card = cardList[sender.tag]
    editDeckViewModel.add(card: card)
  }
  
}



extension EditDeckViewController: UITableViewDelegate, UITableViewDataSource {
  // MARK : Table View Delegates
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let sections = fetchedResultsController.sections else {
      fatalError("No sections in fetchedResultsController")
    }
    
    let sectionInfo = sections[0]
    print("==>\(sectionInfo.numberOfObjects)")
    return sectionInfo.numberOfObjects
    //return 3//self.animals.count
  }
  
  
  // create a cell for each table view row
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell:UITableViewCell = UITableViewCell.init(style: .default,
                                                    reuseIdentifier: nil)as UITableViewCell!
    
    let newItem: Card = fetchedResultsController.object(at: IndexPath(row: indexPath.row, section: 0)) as! Card
    cell.textLabel?.text = newItem.name
    return cell
    
  }
  
  
  // method to run when table view cell is tapped
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("You tapped cell number \(indexPath.row).")
  }
  
}


extension EditDeckViewController: NSFetchedResultsControllerDelegate {
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    selectedDeckTableView.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    switch type {
    case .insert:
      
      selectedDeckTableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
    case .delete:
      selectedDeckTableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
    case .move:
      break
    case .update:
      break
    }
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .insert:
      selectedDeckTableView.insertRows(at: [IndexPath(row: newIndexPath!.row, section: 0)], with: .fade)
    case .delete:
      selectedDeckTableView.deleteRows(at: [IndexPath(row: indexPath!.row, section: 0)], with: .fade)
    case .update:
      selectedDeckTableView.reloadRows(at: [IndexPath(row: indexPath!.row, section: 0)], with: .fade)
    case .move:
      selectedDeckTableView.moveRow(at: IndexPath(row: indexPath!.row, section: 0), to: IndexPath(row: newIndexPath!.row, section: 0))
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    selectedDeckTableView.endUpdates()
  }
  
}



extension EditDeckViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
  
  
  
  // MARK:- UICollectionView DataSource
  
  // Collection View - Number Of Items In Section
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return CardListDataSource.sharedInstance.numbeOfCards()
  }
  
  
  /// Collection View - Cell For Row At Index Path
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! EditDeckCollectionViewCell
    
    
    let cardList: [Card] = CardListDataSource.sharedInstance.fetchCardList()
    let card = cardList[indexPath.row]
    
    cell.attackLbl.text = "\(String(describing: card.attack))"
    cell.healthLbl.text = String(describing: card.health)
    cell.battlePointLbl.text = String(describing: card.battlepoint)
    cell.nameLbl.text = String(describing: card.name)
    
    
    cell.addDeckButton.addTarget(self, action: #selector(addButtonTapped), for: UIControlEvents.touchUpInside)
    cell.addDeckButton.tag = indexPath.row
    
    
    return cell
  }
  
  
  
  
  // MARK:- UICollectionViewDelegate Methods
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    highlightCell(indexPath, flag: true)
  }
  
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    highlightCell(indexPath, flag: false)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: CGFloat((collectionView.frame.size.width / 3) - 15), height: CGFloat(328))
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

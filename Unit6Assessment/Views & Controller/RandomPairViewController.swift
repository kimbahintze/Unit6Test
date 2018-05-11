//
//  RandomPairViewController.swift
//  Unit6Assessment
//
//  Created by Kimba Hintze on 5/11/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import UIKit
import CoreData
import GameplayKit

class RandomPairViewController: UIViewController, UITableViewDataSource, UITabBarDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var randomizerTableView: UITableView!
    @IBOutlet weak var randomizerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PersonController.shared.loadFromPersistentStore()
        PersonController.shared.fetchedResultsController.delegate = self
        randomizerTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        randomizerTableView.reloadData()
       randomizeButtonTapped(self)
    }
    
    // MARK: - Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Add person", message: nil, preferredStyle: .alert)
        let _ = alertController.addTextField { (textfield) in
            textfield.placeholder = "Enter name..."
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let personName = alertController.textFields?[0].text else { return }
            PersonController.shared.addPerson(name: personName)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func randomizeButtonTapped(_ sender: Any) {
        
        var randomPair = [[PersonController.shared.fetchedResultsController.fetchRequest], [PersonController.shared.fetchedResultsController.fetchRequest]]
        
        let randomPairGen = Int(arc4random_uniform(UInt32(randomPair.count)))
        var whichPersonToChoose = 0
        
        // make these funcs
      //  randomizeTwoInGroup(array: PersonController.shared.fetchedResultsController.fetchedObjects!)
    }
    
//    func randomizeTwoInGroup(array: [Person]) {
//      //  whichPersonToChoose = Int(arc4random_uniform(2))
//        guard let array = PersonController.shared.fetchedResultsController.fetchedObjects else { return }
//        let randomGenerator = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: array)
//        let splitSize = 2
//        let _ = stride(from: 0, to: randomGenerator.count, by: splitSize).map {
//            randomGenerator[$0..<min($0 + splitSize, randomGenerator.count)]
//        }
//    }
    
    // MARK: - Table view data source functions
    
    func tableView(_ randomizerTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = PersonController.shared.fetchedResultsController.sections else { return 2 }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ randomizerTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = randomizerTableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)
        let person = PersonController.shared.fetchedResultsController.fetchedObjects?[indexPath.row]
        cell.textLabel?.text = person?.name
        return cell
    }
    
    func numberOfSections(in randomizerTableView: UITableView) -> Int {
        guard let sections = PersonController.shared.fetchedResultsController.sections else { return 0 }
        return sections.count
    }
    
    func tableView(_ randomizerTableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = "Group \(numberOfSections(in: randomizerTableView))"
        return title
    }
    
    func tableView(_ randomizerTableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let person = PersonController.shared.fetchedResultsController.fetchedObjects?[indexPath.row] else { return }
            PersonController.shared.deletePerson(person: person)
        }
    }

    
}

//extension RandomPairViewController {
//     func shuffle() {
//        for _ in PersonController.shared.fetchedResultsController.fetchedObjects! {
//            sort { (_,_) in arc4random() < arc4random() }
//        }
//    }
//}

extension RandomPairViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        randomizerTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        randomizerTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            randomizerTableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            randomizerTableView.deleteRows(at: [indexPath!], with: .automatic)
        case .move:
            randomizerTableView.moveRow(at: indexPath!, to: newIndexPath!)
        case .update:
            randomizerTableView.reloadRows(at: [indexPath!], with: .automatic)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert:
            randomizerTableView.insertSections(indexSet, with: .automatic)
        case .delete:
            randomizerTableView.deleteSections(indexSet, with: .automatic)
        default:
            return
        }
    }
}

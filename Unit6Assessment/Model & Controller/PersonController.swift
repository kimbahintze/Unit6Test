//
//  PersonController.swift
//  Unit6Assessment
//
//  Created by Kimba Hintze on 5/11/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import Foundation
import CoreData

class PersonController {
    
    static var shared = PersonController()
    
    let fetchedResultsController: NSFetchedResultsController<Person> = {
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "name", ascending: false)
        request.sortDescriptors = [sortDescriptors]
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
      
    }()
    
    init() {
        loadFromPersistentStore()
    }
    
    // MARK: - CRUD
    // create
    func addPerson(name: String) {
        let _ = Person(name: name)
        saveToPersistentStore()
    }
    
    func deletePerson(person: Person) {
        CoreDataStack.context.delete(person)
        saveToPersistentStore()
    }
    
    // MARK: - Save/Load
    // save
    func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch let error {
            print("Error saving data to persistent store: \(error)")
        }
    }
    
    // load
    func loadFromPersistentStore() {
        do {
            try fetchedResultsController.performFetch()
        } catch let error {
            print("Error fetching request: \(error.localizedDescription)")
        }
    }
}



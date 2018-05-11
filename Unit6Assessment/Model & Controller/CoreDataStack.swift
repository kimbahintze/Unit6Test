//
//  CoreDataStack.swift
//  Unit6Assessment
//
//  Created by Kimba Hintze on 5/11/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name:  "Unit6Assessment")
        container.loadPersistentStores(completionHandler: { (description, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                fatalError()
            }
        })
        return container
    }()
    
    static var context: NSManagedObjectContext {
        return container.viewContext
    }
}

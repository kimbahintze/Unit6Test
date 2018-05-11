//
//  Person&Convenience.swift
//  Unit6Assessment
//
//  Created by Kimba Hintze on 5/11/18.
//  Copyright © 2018 Kim Lundquist. All rights reserved.
//

import Foundation
import CoreData

extension Person {
    convenience init(name: String, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.name = name
    }
}

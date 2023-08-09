//
//  PointRepository.swift
//  Dialoque
//
//  Created by Jevin Laudo on 2023-08-08.
//

import CoreData

class PointRepository {
    let managedObjectContext: NSManagedObjectContext

    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }

    func createPoint(timestamp: Date) {
        let newPoint = Point(context: managedObjectContext)
        newPoint.timestamp = timestamp

        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Failed to save new point: \(error)")
        }
    }
}

//
//  PointsCountManager.swift
//  Dialoque
//
//  Created by Jevin Laudo on 2023-08-10.
//

import CoreData

class PointsCountManager: ObservableObject {
    private var context: NSManagedObjectContext
    @Published var pointsCount: Int = 0
    
    init(context: NSManagedObjectContext) {
        self.context = context
        updatePointsCount()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(contextDidChange),
                                               name: .NSManagedObjectContextObjectsDidChange,
                                               object: context)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func contextDidChange(_ notification: Notification) {
        updatePointsCount()
    }
    
    private func updatePointsCount() {
        let fetchRequest: NSFetchRequest<Point> = Point.fetchRequest()
        do {
            let count = try context.count(for: fetchRequest)
            pointsCount = count
        } catch {
            print("Error fetching count: \(error)")
            pointsCount = 0
        }
    }
}

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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contextDidChange),
            name: .NSManagedObjectContextObjectsDidChange,
            object: context
        )
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
    
    func isPointScoredToday() -> Bool {
        let fetchRequest: NSFetchRequest<Point> = Point.fetchRequest()
        let currentDate = Date().startOfDay
        let predicate = NSPredicate(format: "timestamp == %@", currentDate as NSDate)
        fetchRequest.predicate = predicate
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error fetching point count: \(error)")
            return false
        }
    }
    
    func createPoint(timestamp: Date) {
        let newPoint = Point(context: context)
        newPoint.timestamp = timestamp.startOfDay
        
        do {
            try context.save()
        } catch {
            fatalError("Failed to save new point: \(error)")
        }
    }
    
    func resetPoint() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Point.fetchRequest()
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        _ = try? context.execute(batchDeleteRequest)
    }
}

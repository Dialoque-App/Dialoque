//
//  CalculateStreak.swift
//  Dialoque
//
//  Created by Jevin Laudo on 2023-08-16.
//

import CoreData

func updateStreaksCount(context: NSManagedObjectContext) -> Int {
    let fetchRequest: NSFetchRequest<Point> = Point.fetchRequest()
    let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
    fetchRequest.sortDescriptors = [sortDescriptor]

    let currentDate = Date().startOfDay // Get the current date
    let predicate = NSPredicate(format: "timestamp <= %@", currentDate as NSDate)
    fetchRequest.predicate = predicate
    
    do {
        let points = try context.fetch(fetchRequest)
        if points.isEmpty {
            return 0
        }
        
        let firstPointDate = points.first?.timestamp
        var lastStreakDate: Date
        var currentStreak: Int
        if firstPointDate != nil {
            lastStreakDate = firstPointDate!
            let isTodayOrYesterday = Calendar.current.isDateInToday(lastStreakDate) || Calendar.current.isDateInYesterday(lastStreakDate)
            if !isTodayOrYesterday {
                return 0
            }
            currentStreak = 1
        } else {
            lastStreakDate = currentDate
            currentStreak = 0
        }
        
        for i in 1..<points.count {
            guard let pointDate = points[i].timestamp else {
                continue // Skip points with no valid timestamp
            }
            let dayDifference = Calendar.current.dateComponents([.day], from: pointDate, to: lastStreakDate).day
            
            if dayDifference == 1 {
                currentStreak += 1
            } else if dayDifference == 0 {
                // Skip the iteration if the point's date is the same as the previous point's date
                continue
            } else {
                // Break the streak if the gap is greater than 1 day
                break
            }
            lastStreakDate = pointDate
        }

        return currentStreak
    } catch {
        print("Error fetching points: \(error)")
        return 0
    }
}

import Foundation
import CoreData


class Achievement: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    class func achievementForDate(date:NSDate, context:NSManagedObjectContext) -> Bool {
        let fr = NSFetchRequest(entityName: "Achievement")
        fr.predicate = NSPredicate(format: "completed > %@ && completed < %@", date.startOfDay, date.endOfDay!)
        
        do {
            let achievements = try context.executeFetchRequest(fr)
            if achievements.count > 0 {
                return true
            }
            return false
        } catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
            return false
        }
    }
    
    class func createAchievementWithDate(date:NSDate, context:NSManagedObjectContext) {
        context.performBlockAndWait { () -> Void in
            let entity = NSEntityDescription.entityForName("Achievement", inManagedObjectContext: context)
            let achievement = Achievement(entity: entity!, insertIntoManagedObjectContext: context)
            achievement.completed = date
            do {
                try context.save()
            } catch let error as NSError {
                print("creation failed: \(error.localizedDescription)")
            }
        }
        
    }
    
    class func numberOfCurrentStreak(context context:NSManagedObjectContext, earliestDate:NSDate? = nil) -> Int {
        let fr = NSFetchRequest(entityName: "Achievement")
        let sort = NSSortDescriptor(key: "completed", ascending: true)
        if let earliest = earliestDate {
            fr.predicate = NSPredicate(format: "completed > %@", earliest)
        }
        fr.sortDescriptors = [sort]
        
        do {
            let achievements = try context.executeFetchRequest(fr)
            return Achievement.processStreak(achievements)
        } catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
            return 0
        }
    }
    
    class func numberOfYearToDate() -> Int {
        return 0
    }
    
    class func processStreak(achievements:[AnyObject], mostRecentStreak:Bool = true) -> Int {
        var streakCount = 0
        var priorAchievement:Achievement? = nil
        for index in (0..<achievements.count).reverse() {
            if priorAchievement == nil {
                priorAchievement = achievements[index] as? Achievement
                streakCount = streakCount + 1
                
            } else {
                let currentAchievement = achievements[index] as? Achievement
                let priorComponents = NSCalendar.currentCalendar().components(.Day, fromDate: (priorAchievement?.completed)!)
                let currentComponents = NSCalendar.currentCalendar().components(.Day, fromDate: (currentAchievement?.completed)!)
                if currentComponents.day == (priorComponents.day - 1) {
                    streakCount = streakCount + 1
                    priorAchievement = currentAchievement
                }
                if mostRecentStreak == true {
                    break
                }
            }
        }
        return streakCount
    }
}



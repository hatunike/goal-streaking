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
    
    class func numberOfCurrentStreak() -> Int {
        
    }
}

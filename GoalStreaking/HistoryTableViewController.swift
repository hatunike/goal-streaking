
import UIKit
import CoreData

class HistoryTableViewController: UITableViewController {

    let context:NSManagedObjectContext
    let dateFormatter:NSDateFormatter
    let dayFormatter:NSDateFormatter
    required init(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        context = appDelegate.coreDataStack.managedObjectContext
        dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM d"
        dayFormatter = NSDateFormatter()
        dayFormatter.dateFormat = "EEE"
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return NSDate().dayOfWeek() - 1 //Adjusted for Monday as first day of week
        }
        return 7
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        print("number of sections = \(NSDate(timeIntervalSince1970: 0).numberOfDaysUntilDateTime(NSDate()) / 7)")
        return NSDate(timeIntervalSince1970: 0).numberOfDaysUntilDateTime(NSDate()) / 7
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let daysOffset = indexPath.section == 0 ? indexPath.row : indexPath.row + NSDate().dayOfWeek() - 1
        
        let dateCellRepresents = NSDate().dateByAdding(numberOfDays: -daysOffset, weeks: 0)
        cell.textLabel?.text = dayFormatter.stringFromDate(dateCellRepresents)

        
        if Achievement.achievementForDate(dateCellRepresents, context: context) {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }


        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("header")
        if section == 0 {
            let startDate = NSDate().dateByAdding(numberOfDays: -(NSDate().dayOfWeek() - 2))
            cell?.textLabel?.text = "\(dateFormatter.stringFromDate(startDate))\(startDate.suffixForDay()) - \(dateFormatter.stringFromDate(NSDate()))\(NSDate().suffixForDay())"
            
            return cell
        }
        let endDate = NSDate().dateByAdding(numberOfDays: -(NSDate().dayOfWeek() - 1), weeks: -(section - 1))
        let startDate = endDate.dateByAdding(numberOfDays: 0, weeks: -1)

        cell?.textLabel?.text =  "\(dateFormatter.stringFromDate(startDate))\(startDate.suffixForDay()) - \(dateFormatter.stringFromDate(endDate))\(endDate.suffixForDay())"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(27);
    }
}



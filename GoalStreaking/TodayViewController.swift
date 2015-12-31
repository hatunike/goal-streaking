
import UIKit
import CoreData

class TodayViewController: UIViewController, UITextViewDelegate {

    let context:NSManagedObjectContext

    @IBOutlet var streakCountLabel: UILabel!
    @IBOutlet var yearToDateCountLabel: UILabel!
    @IBOutlet var goalTextView: UITextView!
    
    required init(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        context = appDelegate.coreDataStack.managedObjectContext
        super.init(coder: aDecoder)!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func todayFinishedButtonPressed(sender: AnyObject) {
        Achievement.createAchievementWithDate(NSDate(), context: context)
        updateUI()
    }
    
    func updateUI() {
        
    }
}


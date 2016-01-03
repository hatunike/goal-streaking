//
//  NSDate+Additions.swift
//  GoalStreaking
//
//  Created by Charles Hart on 12/30/15.
//  Copyright © 2015 lernu. All rights reserved.
//

import Foundation

extension NSDate {
    func numberOfDaysUntilDateTime(toDateTime: NSDate, inTimeZone timeZone: NSTimeZone? = nil) -> Int {
        let calendar = NSCalendar.currentCalendar()
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        
        var fromDate: NSDate?, toDate: NSDate?
        
        calendar.rangeOfUnit(.Day, startDate: &fromDate, interval: nil, forDate: self)
        calendar.rangeOfUnit(.Day, startDate: &toDate, interval: nil, forDate: toDateTime)
        
        let difference = calendar.components(.Day, fromDate: fromDate!, toDate: toDate!, options: [])
        return difference.day
    }
    
    func dayOfWeek(inTimeZone timeZone: NSTimeZone? = nil) -> Int {
        let calendar = NSCalendar.currentCalendar()
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        let components = calendar.componentsInTimeZone(calendar.timeZone, fromDate: self)
        
        return components.weekday
    }
    
    func dayOfMonth(inTimeZone timeZone: NSTimeZone? = nil) -> Int {
        let calendar = NSCalendar.currentCalendar()
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        let components = calendar.componentsInTimeZone(calendar.timeZone, fromDate: self)
        
        return components.day
    }
    
    func suffixForDay() -> String {
        switch self.dayOfMonth() {
        case let x where x >= 11 && x <= 13:
            return "th"
        case let x where x % 10 == 1:
            return "st"
        case let x where x % 10 == 2:
            return "nd"
        case let x where x % 10 == 3:
            return "th"
        default:
            return "th"
        }
    }
    
    func dateByAdding(numberOfDays days:Int, weeks:Int = 0) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        
        return calendar.dateByAddingUnit(.Day, value: (days + weeks * 7), toDate: self, options: [])!
    }
    
    var startOfDay: NSDate {
        return NSCalendar.currentCalendar().startOfDayForDate(self)
    }
    
    var endOfDay: NSDate? {
        let components = NSDateComponents()
        components.day = 1
        components.second = -1
        return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: startOfDay, options: NSCalendarOptions())
    }
    
    func jan1stOfSameYear() -> NSDate {
        let components = NSCalendar.currentCalendar().components(.Day, fromDate: self)
        components.day = 1
        components.month = 1
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        return NSCalendar.currentCalendar().dateFromComponents(components)!
    }

}
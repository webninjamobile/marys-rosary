
import Foundation

extension NSDate
{
    
    func toWeekDay() -> Int{
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Weekday, fromDate: self)
        let weekday = components.weekday
        
        return weekday - 1;
        
    }
}
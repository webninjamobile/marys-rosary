
import Foundation

extension NSDate
{
    
    func toWeekDay() -> Int{
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitWeekday, fromDate: self)
        let weekday = components.weekday
        
        return weekday - 1;
        
    }
}

import UIKit

class Helpers{
    
    func readjson(fileName: String) -> NSData{
        
        let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "json")
        let jsonData = NSData(contentsOfFile:path!)
        
        return jsonData!
    }
    
    func uniq<S: SequenceType, E: Hashable where E==S.Generator.Element>(source: S) -> [E] {
        var seen: [E:Bool] = [:]
        return source.filter { seen.updateValue(true, forKey: $0) == nil }
    }
    
}

extension Array {
    func contains<T where T : Equatable>(obj: T) -> Bool {
        return self.filter({$0 as? T == obj}).count > 0
    }
}


func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

func showLoading(view : UIViewController) -> UIViewController{
    let viewController = view.storyboard!.instantiateViewControllerWithIdentifier("loading") 
    let formSheetController = MZFormSheetPresentationController(contentViewController: viewController)

    formSheetController.shouldCenterVertically = true
    formSheetController.shouldDismissOnBackgroundViewTap = true
    formSheetController.contentViewSize = CGSizeMake(100, 100)
    
    
    view.presentViewController(formSheetController, animated: true, completion: nil)
    
    return viewController
}
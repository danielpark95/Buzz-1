
import UIKit
import Quikkly
import SwiftyJSON

class CustomScanViewController: ScanViewController {

    override init() {
        super.init()
        var count = 0
        for v in (view.subviews){
            if count != 0 {
                v.removeFromSuperview()
            } else {
               print(v)
            }
            count = count + 1
        }
    }
    

    func scanView(_ scanView: ScanView, didDetectScannables scannables: [Scannable]) {
        // Handle detected scannables
        if let scannable = scannables.first {
            print("Found scannable code: \(scannable.value)")
            
            FirebaseManager.getCard(withUniqueID: scannable.value, completionHandler: { cardJSON in
                for (key,value):(String, JSON) in cardJSON {
                    print("\(key): \(value)")
                }
            })
            
        }
    }
    
}

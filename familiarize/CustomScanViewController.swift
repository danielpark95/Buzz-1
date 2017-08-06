//
//  ViewController.swift
//  DemoSample
//
//  Created by Julian Gruber on 06/03/2017.
//  Copyright © 2017 Quikkly Ltd. All rights reserved.
//
import UIKit
import Quikkly

class CustomScanViewController: ScanViewController {
    
    
    
    override init() {
        super.init()
        self.title = "Scan"
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let cameraOverlay = UIImageView()
        cameraOverlay.image = UIImage(named: "cameraOverlay")
        cameraOverlay.alpha = 0.2
        
        cameraOverlay.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(cameraOverlay)
        cameraOverlay.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        cameraOverlay.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        cameraOverlay.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        cameraOverlay.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
    }

    func scanView(_ scanView: ScanView, didDetectScannables scannables: [Scannable]) {
        // Handle detected scannables
        if let scannable = scannables.first {
            print("Found scannable code: \(scannable.value)")
        }
    }
    
}

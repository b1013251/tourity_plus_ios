//
//  ViewController.swift
//  GLTest
//
//  Created by mukuri on 2015/08/12.
//  Copyright (c) 2015年 mukuri. All rights reserved.
//

import UIKit
import AVFoundation
import SpriteKit
import CoreLocation
import CoreMotion
import SpriteKit

class TopViewController: UIViewController  {
    
    
    // MARK: - Segue
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        //nothing
        return true;
    }
    
    // MARK: - ビューコントローラ
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let sensor = Sensor.sharedInstance
        sensor.start()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}


//
//  ViewController.swift
//  PhotokitTest
//
//  Created by mukuri on 2015/08/16.
//  Copyright (c) 2015年 mukuri. All rights reserved.
//

import UIKit
import Photos

class MyPageController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let session : Session = Session()
        session.getUserInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



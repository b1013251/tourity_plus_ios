//
//  ViewController.swift
//  PhotokitTest
//
//  Created by mukuri on 2015/08/16.
//  Copyright (c) 2015年 mukuri. All rights reserved.
//

import UIKit
import Fabric
import TwitterKit

class DetailBubbleController: UIViewController {
    
    var poi : POI! //位置情報
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func backButtonPush(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "\(poi.post_id) : \(poi.message)"
    }
}
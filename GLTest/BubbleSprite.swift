//
//  Bubble.swift
//  GLTest
//
//  Created by mukuri on 2015/09/28.
//  Copyright (c) 2015年 mukuri. All rights reserved.
//

import Foundation
import SpriteKit

class BubbleSprite : SKSpriteNode {
    var detailDelegate : DetailDelegate!
    var poi            : POI!
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        println("touched \(self.name)")
        self.detailDelegate.moveDetail( self.poi )
    }
}
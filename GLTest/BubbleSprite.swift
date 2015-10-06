/*


    バブル１つを表すSpriteNode

*/

import Foundation
import SpriteKit

class BubbleSprite : SKSpriteNode {
    var detailDelegate : DetailDelegate!
    var poi            : POI!
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        println("touched \(self.name)")
        self.detailDelegate.moveDetailView( self.poi )
    }
}
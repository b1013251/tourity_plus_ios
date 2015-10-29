/*

    
    SpriteKitのAR表示用 Scene


*/

import Foundation
import SpriteKit
import CoreLocation


class BubbleScene : SKScene , SocketDelegate  {
    
    var sensor : Sensor!
    var socket : Socket!
    var detailDelegate : DetailDelegate!
    
    var bubbleImage : [SKSpriteNode] = [] //バブルを格納
    var posPOI      : [POI]          = [] //バブル毎の位置情報を格納
    
    
    override func didMoveToView(view: SKView) {
        //データの取得
        self.sensor = Sensor.sharedInstance
        self.sensor.start()
        
        //シーンが表示されるたびにSocketサーバに接続
        self.socket = Socket.sharedInstance
        self.socket.delegate = self
        self.socket.clearBubble()
        self.socket.connect()
        
        
        //画面関係の初期化
        self.backgroundColor = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
        self.size.height = view.bounds.height
        self.size.width  = view.bounds.width
        self.physicsWorld.gravity = CGVectorMake(0,0)
    }
    
    override func update(currentTime: CFTimeInterval) {
        let realHeading : Double = sensor.heading  - ( sensor.pitch / M_PI * 180 )
        let viewPOI = POI(
            post_id  : 0 , //自分の位置情報にIDはないので，適当な値を入れる
            latitude : sensor.latitude,
            longitude: sensor.longitude ,
            altitude : sensor.altitude ,
            file_path : "")
        
        for ( var i = 0 ; i < posPOI.count ; i++ ) {
            let place : Double = ( ARHelper.isExist(viewPOI: viewPOI, posPOI: posPOI[i] , heading: realHeading) )
            
            if place != ARHelper.NOT_EXIST { //存在していれば
                let x  = Double(CGRectGetMidX(self.frame)) - Double(place / 60.0) * Double(self.size.width)
                let y  = Double(CGRectGetMidY(self.frame))
                    + Double( (sensor.roll + M_PI_2) / M_PI ) * Double(self.size.height) * 4
                    + Double( ARHelper.getVerticalAngle(viewPOI: viewPOI , posPOI: posPOI[i]) * Double(CGRectGetMidY(self.frame)))
                    - Double( sensor.pitch / M_PI * 180.0 * Double(place / 60.0) * 10.0)
                
                let location = CGPoint(x: x, y: y)
                
                
                let rotateAction  =  SKAction.rotateToAngle(CGFloat(sensor.pitch), duration: NSTimeInterval(0.0))
                let moveAction    =  SKAction.moveTo(location , duration: NSTimeInterval(0.1))
                let fadeInAction  =  SKAction.fadeInWithDuration(0.2)
                
                bubbleImage[i].hidden = true
                bubbleImage[i].runAction(rotateAction)
                bubbleImage[i].runAction(moveAction)
                
                //移動すべき範囲内にあれば表示
                /*
                let xrange : Bool = ( Double(bubbleImage[i].position.x) < x + 100.0 ) && ( x - 100.0 < Double(bubbleImage[i].position.x) )
                let yrange : Bool = ( Double(bubbleImage[i].position.y) < y + 100.0 ) && ( y - 100.0 < Double(bubbleImage[i].position.y) )
                if xrange && yrange {
                    self.bubbleImage[i].hidden = false
                }
                */
                bubbleImage[i].hidden = false
                
            } else {
                bubbleImage[i].hidden = true
            }
        }
        
    }
    
    //MARK: - Socket Delegateの実装
    func createBubble(poi : POI)  {
        println("bubble created : \(poi.message)")
        //バブル画像部分
        let node : BubbleSprite! = BubbleSprite(imageNamed: "bubble.png")
        node.xScale   *= 0.5
        node.yScale   *= 0.5
        //node.position = CGPointMake(self.size.width / 2 , self.size.height / 2 )
        //node.alpha    = 0.0
        node.hidden = true
        node.userInteractionEnabled = true
        node.name     = poi.message
        node.poi      = poi
        node.detailDelegate = self.detailDelegate
        
        
        //文字部分
        let label : SKLabelNode = SKLabelNode(fontNamed:"HiraKakuProN-W3")
        label.fontSize  =  40
        label.position  =  CGPointMake( 0 , 0 )
        label.alpha     =  1.0
        label.zPosition =  label.zPosition + 1
        
        if count(poi.message) > 6 {
            var idx: String.Index
            idx = advance(poi.message.startIndex,6)
            
            label.text = poi.message.substringToIndex(idx) + "..."
        } else {
            label.text = poi.message
        }
        
        
        //シーンにバブルを追加する
        node.addChild(label)
        self.addChild(node)
        
        
        //当たり判定をつけることにより重ならないようにする
        node.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(node.size.width * 2.0, node.size.height * 2.0))
        
        
        posPOI.append(poi)
        bubbleImage.append(node)
    }

}

protocol SocketDelegate {
    func createBubble(poi : POI)
}
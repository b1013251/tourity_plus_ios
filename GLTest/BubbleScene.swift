/*

    
    SpriteKitのAR表示用 Scene


*/

import Foundation
import SpriteKit
import CoreLocation


class BubbleScene : SKScene , SKPhysicsContactDelegate, SocketDelegate  {
    
    var sensor : Sensor!
    var socket : Socket!
    var detailDelegate : DetailDelegate!
    
    var bubbleImage : [BubbleSprite] = [] //バブルを格納
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
        self.physicsWorld.contactDelegate = self
    }
    
    override func update(currentTime: CFTimeInterval) {
        let realHeading : Double = fmod(sensor.heading - ARHelper.radToDeg(sensor.pitch) + 360.0 , 360.0)
        //println(realHeading)
        let viewPOI = POI(
            post_id  : 0 , //自分の位置情報にIDはないので，適当な値を入れる
            latitude : sensor.latitude,
            longitude: sensor.longitude ,
            altitude : sensor.altitude ,
            file_path : "")
        
        /* 向いている方向を補正とか言ってみるテスト
        println("補正前 \(sensor.heading)")
        println("ピッチ \(ARHelper.radToDeg(sensor.pitch))")
        println("補正後 \(realHeading)" )
        */
        
        for ( var i = 0 ; i < posPOI.count ; i++ ) {
            let place : Double = ( ARHelper.isExist(viewPOI: viewPOI, posPOI: posPOI[i] , heading: realHeading) )
            
            
            if place != ARHelper.NOT_EXIST { //存在していれば
                //println(place)
                let horizontal : Double = (-1.0) * Double(place / 60.0) * Double(self.size.width)
                
                let x = Double(CGRectGetMidX(self.frame)) + cos( sensor.pitch ) * horizontal
                let y = Double(CGRectGetMidY(self.frame)) + sin( sensor.pitch ) * horizontal
                    + Double( ARHelper.radToDeg(sensor.roll + M_PI_2) * 10.0)
                    + Double( ARHelper.getVerticalAngle(viewPOI: viewPOI , posPOI: posPOI[i]) * Double(CGRectGetMidY(self.frame)))
                
                let location = CGPoint(x: x, y: y)
                
                
                let rotateAction  =  SKAction.rotateToAngle(CGFloat(sensor.pitch), duration: NSTimeInterval(0.0))
                let moveAction    =  SKAction.moveTo(location , duration: NSTimeInterval(0))
                //let fadeInAction  =  SKAction.fadeInWithDuration(0.2)
                
                //bubbleImage[i].hidden = true
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
                bubbleImage[i].physicsBody = SKPhysicsBody(circleOfRadius: (bubbleImage[i].size.width) )
                bubbleImage[i].physicsBody?.categoryBitMask = 0x1
                bubbleImage[i].physicsBody?.collisionBitMask = 0x1 << 1
                bubbleImage[i].physicsBody?.contactTestBitMask = 0x1 | 0x1 << 1
                bubbleImage[i].hidden = false
                
            } else {
                bubbleImage[i].hidden = true
                bubbleImage[i].physicsBody = nil
            }
        }
        
    }
    
    //MARK: - Socket Delegateの実装
    func createBubble(poi : POI)  {
        println("bubble created : \(poi.message)")
        //バブル画像部分
        let node : BubbleSprite! = BubbleSprite(imageNamed: "bubble.png")
        node.xScale   *= 0.4
        node.yScale   *= 0.4
        //node.position = CGPointMake(self.size.width / 2 , self.size.height / 2 )
        //node.alpha    = 0.0
        node.hidden = true
        node.userInteractionEnabled = true
        node.name     = poi.message
        node.poi      = poi
        node.detailDelegate = self.detailDelegate
        
        //node.rand     = Int(arc4random() % 100 ) - 49
        
        
        //文字部分
        let label : SKLabelNode = SKLabelNode(fontNamed:"HiraKakuProN-W3")
        label.fontSize  =  50
        label.position  =  CGPointMake( 0 , 0 )
        label.alpha     =  1.0
        label.zPosition =  20
        
        //6文字以上を...に変換
        if count(poi.message) > 6 {
            var idx: String.Index
            idx = advance(poi.message.startIndex,6)
            
            label.text = poi.message.substringToIndex(idx) + "..."
        } else {
            label.text = poi.message
        }
        
        //サムネイルを表示
        let thumbPath = poi.file_path
        println(thumbPath)
        
        var image : UIImage!
        let file_name = poi.file_path.componentsSeparatedByString("/")[1]
        
        //画像なら取得，動画なら適当な画像
        let file_type = file_name.componentsSeparatedByString(".")[1]
        if file_type == "jpg" {
            let url = NSURL(string: "\(Settings.serverURL)/\(file_name)")
            let mediaData :NSData = NSData(contentsOfURL: url!)!
            image = UIImage(data:mediaData)
        } else if file_type == "mp4" {
            image = UIImage(named: "mthumb")
        }
        
        if file_type == "jpg" || file_type == "mp4" {
            let thumb : SKSpriteNode = SKSpriteNode(texture: SKTexture(image: image), size: CGSizeMake(200, 150))
            thumb.zPosition = 10
            thumb.position = CGPointMake(0 , -100)
            node.addChild(thumb)
        }
        
        //シーンにバブルを追加する
        
        posPOI.append(poi)
        bubbleImage.append(node)
        
        node.addChild(label)
        self.addChild(node)
        
        
        //当たり判定をつけることにより重ならないようにする
        //node.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(node.size.width , node.size.height ))
        
        
    }
    

    /**
    衝突時に呼ばれ，古い方のバブルを消す…
    
    - parameter contact: ノードを取り出すオブジェクト
    */
    func didBeginContact(contact: SKPhysicsContact) {
        
        let dateString1 = (contact.bodyA.node as! BubbleSprite).poi.posted_time
        let dateString2 = (contact.bodyB.node as! BubbleSprite).poi.posted_time
        
        switch self.compareDate(dateString1, dateString2: dateString2) {
        case -1 :
            self.removeByPostID((contact.bodyA.node as! BubbleSprite).poi.post_id)
            break
        case 1 :
            self.removeByPostID((contact.bodyB.node as! BubbleSprite).poi.post_id)
            break
        case 0 :
            break
        default:
            break
        }

    
    }

    
    /**
    
    時刻を比較してその結果を返す
    -1 : 小さい
    0 : 同じ
    +1 : 大きい
    
    - parameter dateString1: 比較対象1（MySQLの形式で文字列を渡す）
    - parameter dateString2: 比較対象2（MySQLの形式で文字列を渡す）
    
    - returns: -1,0,1で大小関係を返す
    */
    private func compareDate(dateString1 : String, dateString2 : String) -> Int {
        let format : NSDateFormatter = NSDateFormatter()
        format.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        var date1 = format.dateFromString(dateString1)
        var date2 = format.dateFromString(dateString2)

        if date1!.compare(date2!) == NSComparisonResult.OrderedAscending {
            return -1
        } else if date1!.compare(date2!) == NSComparisonResult.OrderedDescending {
            return 1
        } else {
            return 0
        }
    }
    
    
    /**
    投稿IDに合致するバブルを消す
    
    - parameter id: 投稿ID
    */
    private func removeByPostID(id : Int) {
        var num : Int = 0
        for poi in posPOI {
            if poi.post_id == id {
                bubbleImage[num].removeFromParent()
                posPOI.removeAtIndex(num)
                bubbleImage.removeAtIndex(num)
            }
            num++
        }
    }
}



protocol SocketDelegate {
    func createBubble(poi : POI)
}
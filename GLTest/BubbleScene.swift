//
//  EastScene.swift
//  CameraTest
//
//  Created by mukuri on 2015/07/02.
//  Copyright (c) 2015年 mukuri. All rights reserved.
//

import Foundation
import SpriteKit
import CoreLocation


class BubbleScene : SKScene , SocketDelegate  {
    
    var sensor : Sensor!
    var bubbleImage : [SKSpriteNode] = []
    var posPOI : [POI]    = []
    
    var detailDelegate : DetailDelegate!
    
    override func didMoveToView(view: SKView) {
        //データの取得
        sensor = Sensor.sharedInstance
        sensor.start()
        
        //画面関係の初期化
        self.backgroundColor = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
        self.size.height = view.bounds.height
        self.size.width  = view.bounds.width
        self.physicsWorld.gravity = CGVectorMake(0,0)
        
        //デバッグ用固定データ
        //posPOI.append( POI(latitude: 41.759193 , longitude: 140.703982 , message: "函館山") )   //hakodate yama
        //posPOI.append( POI(latitude: 41.848004 , longitude: 140.768681 , message: "四季の森") )   //shikino mori
        
        let socket : Socket = Socket.sharedInstance
        socket.delegate     = self
    }

    
    override func update(currentTime: CFTimeInterval) {
        let realHeading : Double = sensor.heading  - ( sensor.pitch / M_PI * 180 )
        let viewPOI = POI(
            post_id  : 0 , //自分の位置情報にIDはないので，適当な値を入れる
            latitude : sensor.latitude,
            longitude: sensor.longitude ,
            altitude : sensor.altitude )
        
        for ( var i = 0 ; i < posPOI.count ; i++ ) {
            let place : Double = ( AR.isExist(viewPOI: viewPOI, posPOI: posPOI[i] , heading: realHeading) )
            
            if place != AR.NOT_EXIST {
                let x  = Double(CGRectGetMidX(self.frame)) - Double(place / 60.0) * Double(self.size.width)
                let y  = Double(CGRectGetMidY(self.frame))
                    + Double( (sensor.roll + M_PI_2) / M_PI ) * Double(self.size.height) * 4
                    + Double( AR.getVerticalAngle(viewPOI: viewPOI , posPOI: posPOI[i]) * Double(CGRectGetMidY(self.frame)))
                    - Double( sensor.pitch / M_PI * 180.0 * Double(place / 60.0) * 10.0)
                
                let location = CGPoint(x: x, y: y)
                
                //println(" \(x) \(place) \(AR.getVerticalAngle(viewPOI: viewPOI , posPOI: posPOI[i]))")
                
                
                let rotateAction  =  SKAction.rotateToAngle(CGFloat(sensor.pitch), duration: NSTimeInterval(0.0))
                let moveAction    =  SKAction.moveTo(location , duration: NSTimeInterval(0.0))
                let fadeInAction  =  SKAction.fadeInWithDuration(0.2)
                
                bubbleImage[i].alpha = 0.0
                bubbleImage[i].runAction(rotateAction)
                bubbleImage[i].runAction(moveAction)
                
                if(bubbleImage[i].speed < 30.0) {
                    bubbleImage[i].alpha = 1.0
                }
                
                
            } else {
                bubbleImage[i].alpha = 0.0
            }
        }
        
    }
    
    
    func createBubble(poi : POI)  {
        //バブル（背景）
        let node : BubbleSprite! = BubbleSprite(imageNamed: "bubble.png")
        node.xScale   *= 0.3
        node.yScale   *= 0.3
        //node.position = CGPointMake(self.size.width / 2 , self.size.height / 2 )
        node.alpha    = 0.0
        node.userInteractionEnabled = true
        node.name     = poi.message
        node.poi      = poi
        node.detailDelegate = self.detailDelegate
        
        
        //文字
        let label : SKLabelNode = SKLabelNode(fontNamed:"HiraKakuProN-W3")
        label.fontSize  =  40
        label.position  =  CGPointMake( 0 , 0 )
        label.alpha     =  1.0
        label.zPosition =  label.zPosition + 1
        label.text      =  poi.message
        
        
        node.addChild(label)
        self.addChild(node)
        
        //当たり判定をつけることにより重ならないようにする
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2.0)
        
        
        posPOI.append(poi)
        bubbleImage.append(node)
    }

}

protocol SocketDelegate {
    func createBubble(poi : POI)
}
//
//  Socket.swift
//  WebsocketTest
//
//  Created by mukuri on 2015/08/22.
//  Copyright (c) 2015年 mukuri. All rights reserved.
//

import Foundation
import Socket_IO_Client_Swift
import SpriteKit


/* SocketIOでリアルタイムにバブルを受け取るためのクラス */
class Socket{
    
    var socket     : SocketIOClient!
    var bubblePool : [NSDictionary]!  = [NSDictionary]()
    var poiArray   : [POI] = []
    var delegate   : SocketDelegate!
    
    var latitude   : Double
    var longitude  : Double
    
    
    init(urlstr : String , lat : Double , lon : Double) {
        latitude  = lat
        longitude = lon
        self.socket = SocketIOClient(socketURL: urlstr , options: nil)
        
        self.socket.on("connect" ,callback: { data , ack in
            println("socket connected")
            self.getData(lat: self.latitude, lon: self.longitude)
        })
        
        self.socket.on("message_bubbles", callback: {data , ack in
            if let realData = data as? [NSDictionary] {
                if self.isNotExist(realData[0].objectForKey("student_id") as! Int!) {
                    self.bubblePool.append(realData[0])
                    let poi : POI = POI(latitude: realData[0].objectForKey("latitude") as! Double , longitude: realData[0].objectForKey("longitude") as! Double ,
                        altitude: realData[0].objectForKey("altitude") as! Double ,  message: realData[0].objectForKey("message") as! String)
                    self.delegate.createBubble(poi)
                }
            }
        })
        self.socket.connect()
    }
    
    
    func getData(#lat : Double , lon : Double) {
        println("emitted")
        self.socket.emit("location_server", ["latitude" : lat , "longitude" : lon , "range" : 1500] )
    }
    
    func getPOIData() -> [POI] {
        return poiArray
    }
    
    
    // MARK : - プライベート関数
    private func isNotExist(id : Int) -> Bool {
        //if bubblePool.count == 0 { return true } //空なら問答無用でtrue
        
        var exist = true
        for (var i = 0 ; i < self.bubblePool.count ; i++) {
            exist = exist && !( ( (self.bubblePool[i] as NSDictionary).objectForKey("student_id") as! Int!) == id )
        }
        return exist
    }
}
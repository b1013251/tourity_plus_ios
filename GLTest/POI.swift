//
//  POI.swift
//  GLTest
//
//  Created by mukuri on 2015/08/12.
//  Copyright (c) 2015年 mukuri. All rights reserved.
//

import Foundation

/* 1つのバブルデータを管理する */
class POI {
    var latitude  : Double // 緯度
    var longitude : Double // 経度
    var altitude  : Double // 標高
    var message   : String // メッセージ
    var post_id   : Int    // 投稿ID
    
    init(post_id : Int , latitude : Double , longitude : Double , altitude : Double) {
        self.latitude  = latitude
        self.longitude = longitude
        self.altitude  = altitude
        self.message   = ""
        self.post_id   = post_id
    }
    
    init(post_id : Int , latitude : Double , longitude : Double , altitude : Double , message : String) {
        self.latitude  = latitude
        self.longitude = longitude
        self.altitude  = altitude
        self.message   = message
        self.post_id   = post_id
    }
}
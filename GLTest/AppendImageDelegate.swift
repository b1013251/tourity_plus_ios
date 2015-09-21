//
//  AppendImageDelegate.swift
//  GLTest
//
//  Created by mukuri on 2015/09/09.
//  Copyright (c) 2015年 mukuri. All rights reserved.
//

import Foundation
import Photos

//データ受け渡し用
protocol AppendImageDelegate {
    func returnData(imageData : UIImage , asset : PHAsset) -> Void //動画に関してもサムネイルを返すだけなので画像
    
    func returnData(imageData : UIImage , url : NSURL , rawData : NSData , mediaType : PHAssetMediaType )
}

//
//  User.swift
//  GLTest
//
//  Created by mukuri on 2015/09/19.
//  Copyright (c) 2015年 mukuri. All rights reserved.
//

/*--------------------------------

          ユーザ管理クラス

---------------------------------*/

import Foundation
import UIKit

class User : NSObject , NSURLSessionDelegate  {
    
    var authToken        : String
    var authTokenSecret  : String
    
    init(authToken : String , authTokenSecret : String) {
        self.authToken       = authToken
        self.authTokenSecret = authTokenSecret
    }

    func upload() {
        let sessionConfig : NSURLSessionConfiguration =
                NSURLSessionConfiguration.defaultSessionConfiguration()
        let session       : NSURLSession =
                NSURLSession(configuration: sessionConfig, delegate: self , delegateQueue:  NSOperationQueue.mainQueue())
        
        
        //リクエストの生成
        let request : NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string:  Settings.serverURL + "/pass")!)
        let bodyData = "authToken=" + authToken + "&authTokenSecret=" + authTokenSecret
        

        request.HTTPMethod = "POST"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        
        
        //タスクの生成・アップロード！
        println("token uploading")
        
        let task = session.dataTaskWithRequest(request){
            (data, response , error) -> Void in
            
            if(error != nil) {
                println("error \(error) in \(Settings.serverURL)")
                return
            }
            
            let cookies : [NSHTTPCookie] = NSHTTPCookie.cookiesWithResponseHeaderFields((response as! NSHTTPURLResponse).allHeaderFields,
                forURL: NSURL(string: "")!) as! [NSHTTPCookie]
            
          
            
            for cookie : NSHTTPCookie in cookies {
                if cookie.name == "Session-Cookie" {
                    println("\(cookie.value) を受け取ったので保存します")
                
                    let userDefaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
                    userDefaults.setObject(cookie.value , forKey: "sessionID")
                }
            }
        }
        
        task.resume()
    }
}
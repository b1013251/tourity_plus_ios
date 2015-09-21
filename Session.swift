//
//  Session.swift
//  GLTest
//
//  Created by mukuri on 2015/09/20.
//  Copyright (c) 2015年 mukuri. All rights reserved.
//

import Foundation

class Session : NSObject {
    
    var sessionIDCookie : String
    var delegate        : SessionDelegate
    
    init(sessionIDCookie : String , delegate : SessionDelegate) {
        self.sessionIDCookie = sessionIDCookie
        self.delegate        = delegate
    }
    
    func sendCookie() {
        //クッキーの生成
        let properties : NSDictionary = NSDictionary(objectsAndKeys:
            Settings.serverURL   , NSHTTPCookieDomain,
            "/"                  , NSHTTPCookiePath,
            "Session-Cookie"     , NSHTTPCookieName,
            self.sessionIDCookie , NSHTTPCookieValue
        )
        
        let cookie  :  NSHTTPCookie  = NSHTTPCookie(properties: properties as [NSObject : AnyObject])!
        let cookies : [NSHTTPCookie] = [
            cookie
        ]
        
        //リクエストの生成
        let request : NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: Settings.serverURL + "/session")!)
        let header  : NSDictionary = NSHTTPCookie.requestHeaderFieldsWithCookies(cookies)
        
        request.HTTPMethod = "POST"
        request.allHTTPHeaderFields = header as [NSObject : AnyObject]
        
        
        //POSTリクエストの送信
        println("sessionIDを送信します")
        let responseData   : NSData   = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)!
        let responseString : NSString = NSString(data:responseData,encoding:1)!
        println(responseString)

        if responseString == "OK" {
            println("ログインしていたようなので、そのまま画面遷移するよ")
            self.delegate.sessionSuccess()
        } else {
            println("ログインされていなかったので、これからログインするよ")
            self.delegate.sessionFailure()
        }
    }
}
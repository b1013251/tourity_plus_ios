//
//  SessionSender.swift
//  GLTest
//
//  Created by mukuri on 2015/10/21.
//  Copyright (c) 2015年 mukuri. All rights reserved.
//

import Foundation

class SessionSender: NSObject {
    /*
    func send() {
        //クッキー送ってあげるうううううううううう
        let userDefaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let sessionIDCookies = userDefaults.stringForKey("sessionID")// as! [NSHTTPCookie]
        
        if sessionIDCookies == nil {
            println("クッキーがなかったので、ログインします")
            self.loginTwitter()
            return
        }
        
        println("sessionID:\(sessionIDCookies)")
        
        let sendCookieSession = Session(sessionIDCookie: sessionIDCookies! , delegate: self)
        sendCookieSession.sendCookie()
    }
    
    func sessionSuccess(){
        NSThread.sleepForTimeInterval(1.0)
        self.performSegueWithIdentifier("topViewSegue", sender: self)
    }
    
    
    //ログインできていなかったら、ログイン画面へ
    func sessionFailure() {
        loginTwitter()
    }
    
    func loginTwitter() {
        //Twitterにログイン
        println("Twitterにログインします")
        Twitter.sharedInstance().logInWithCompletion {
            session, error in
            if (session != nil) {
                println("signed in as \(session!.userName)");
                self.authToken        =  session!.authToken
                self.authTokenSecret  =  session!.authTokenSecret
                let user : User = User(authToken: self.authToken , authTokenSecret: self.authTokenSecret)
                user.upload()
                self.performSegueWithIdentifier("topViewSegue", sender: self)
            } else {
                println("error: \(error!.localizedDescription)");
                self.overView.hidden = true
            }
        }
    }
    */

}
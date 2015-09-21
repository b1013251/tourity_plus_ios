//
//  ViewController.swift
//  PhotokitTest
//
//  Created by mukuri on 2015/08/16.
//  Copyright (c) 2015年 mukuri. All rights reserved.
//

import UIKit
import Fabric
import TwitterKit

class LoginController: UIViewController , UINavigationControllerDelegate , SessionDelegate{
    
    var authToken       : String = ""
    var authTokenSecret : String = ""
    
    @IBOutlet weak var overView: UIView!
    
    @IBOutlet weak var activeIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        activeIndicatorView.startAnimating()
        
        
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
    
    //ログインを既にしていたら、そのまま画面遷移
    func sessionSuccess(){
        NSThread.sleepForTimeInterval(1.0)
        self.performSegueWithIdentifier("topViewSegue", sender: self)
    }

    
    //ログインできていなかったら、ログイン画面へ
    func sessionFailure() {
        loginTwitter()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
}

/*
let loginButton = TWTRLogInButton(logInCompletion: {
session , error in
if session != nil {
self.authToken = session!.authToken
self.performSegueWithIdentifier("topViewSegue", sender: self)
let user : User = User(authToken: self.authToken , authTokenSecret: self.authTokenSecret)
user.upload()
}
})


loginButton.center = self.view.center
self.view.addSubview(loginButton)
*/
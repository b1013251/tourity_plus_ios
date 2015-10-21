/*

    Twitterログインのボタン

*/

import UIKit

class FirstViewController: UIViewController , NSURLSessionDelegate {
    
    @IBOutlet weak var overwrapView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //リクエストの生成
        let request : NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: Settings.serverURL + "/check_user")!)
        let header  : NSDictionary = NSHTTPCookie.requestHeaderFieldsWithCookies(createCookie())
        
        request.HTTPMethod = "GET"
        request.allHTTPHeaderFields = header as [NSObject : AnyObject]
        
        let responseData   : NSData   = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)!
        let responseString : NSString = NSString(data:responseData,encoding:1)!
        println(responseString)
        
        if responseString == "login_ok" {
            println("login_ok")
            performSegueWithIdentifier("topViewSegue", sender: self)
        } else {
            //ログインできない場合の処理
            println(responseString)
            overwrapView.hidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func createCookie() -> [NSHTTPCookie] {
        let userDefaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var sessionIDCookies = userDefaults.stringForKey("sessionID")
        
        if sessionIDCookies == nil {
            println("クッキーがありません．")
            sessionIDCookies = ""
        }
        
        let properties : NSDictionary = NSDictionary(objectsAndKeys:
            Settings.serverURL    , NSHTTPCookieDomain ,
            "/"                   , NSHTTPCookiePath   ,
            "connect.sid"      , NSHTTPCookieName   ,
            sessionIDCookies! , NSHTTPCookieValue
        )
        
        let cookie  :  NSHTTPCookie  = NSHTTPCookie(properties: properties as [NSObject : AnyObject])!
        let cookies : [NSHTTPCookie] = [
            cookie
        ]
        
        return cookies
        
    }
}


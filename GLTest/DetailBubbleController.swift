/*

    バブルの詳細画面

*/


import UIKit
import Fabric
import TwitterKit

class DetailBubbleController: UIViewController {
    
    var poi : POI! //位置情報
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    
    @IBAction func niceButtonPushed(sender: AnyObject) {
        // いいね！
    }
    
    @IBAction func backButtonPush(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "\(poi.post_id) : \(poi.message)"
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //画像を持ってくる
        let file_name = poi.file_path.componentsSeparatedByString("/")[1]
        let url = NSURL(string: "\(Settings.serverURL)/\(file_name)")
        
        var imageData :NSData = NSData(contentsOfURL: url!)!
        detailImage.image = UIImage(data:imageData)
        
        println("\(Settings.serverURL)/\(file_name) \(getEvalCount())")
        println(poi.file_path)
    }
    
    // 評価数をサーバからもってくる
    func getEvalCount() -> Int {
        //リクエストの生成 TODO: evalの追加
        let request : NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: Settings.serverURL + "/eval?\(poi.post_id)")!)
        request.HTTPMethod = "GET"
        
        //リクエストの送信
        var response       : NSURLResponse?
        var error          : NSError?
        let responseData   : NSData!   = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response , error: &error)!
        
        if let err = error {
            println(err)
            return 0
        }
        
        let responseString : NSString = NSString(data:responseData,encoding:1)!
        println(responseString)
        //return String(responseString).toInt()!
        return 0
    }
    
    //クッキーもってくるやつ！
    //ISSUE: DRYに反してる
    private func readCookie() -> [NSHTTPCookie] {
        let userDefaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var sessionIDCookies = userDefaults.stringForKey("sessionID")
        
        if sessionIDCookies == nil {
            println("クッキーがなかったので")
            sessionIDCookies = ""
        }
        
        let properties : NSDictionary = NSDictionary(objectsAndKeys:
            Settings.serverURL    , NSHTTPCookieDomain ,
            "/"                   , NSHTTPCookiePath   ,
            "Session-Cookie"      , NSHTTPCookieName   ,
            sessionIDCookies! , NSHTTPCookieValue
        )
        
        let cookie  :  NSHTTPCookie  = NSHTTPCookie(properties: properties as [NSObject : AnyObject])!
        let cookies : [NSHTTPCookie] = [
            cookie
        ]
        
        return cookies
    }

}
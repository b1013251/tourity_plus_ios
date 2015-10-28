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
    @IBOutlet weak var containerView: UIView!
    
    @IBAction func niceButtonPushed(sender: AnyObject) {
        //リクエストの生成 TODO: evalの追加
        let request : NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: Settings.serverURL + "/send_eval")!)
        request.HTTPMethod = "POST"
        request.HTTPBody = String("post_id=\(poi.post_id)").dataUsingEncoding(NSUTF8StringEncoding)
        
        //リクエストの送信
        var response       : NSURLResponse?
        var error          : NSError?
        let responseData   : NSData!   = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response , error: &error)!

        
        let responseString : NSString = NSString(data:responseData,encoding:1)!
        println(responseString)
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

        if ( poi.file_path != "" ) {
            let file_name = poi.file_path.componentsSeparatedByString("/")[1]
            let url = NSURL(string: "\(Settings.serverURL)/\(file_name)")
            let mediaData :NSData = NSData(contentsOfURL: url!)!
            
            //画像なら表示、動画なら再生
            let file_type = file_name.componentsSeparatedByString(".")[1]
            if file_type == "jpg" {
                detailImage.hidden = false
                detailImage.image = UIImage(data:mediaData)
            } else if file_type == "mp4" {
                println( "\(Settings.serverURL)/\(file_name)")
                containerView.hidden    = false
                let playVideoController = self.childViewControllers[0] as! PlayVideoController
                playVideoController.playVideo("\(Settings.serverURL)/\(file_name)")
            }
        }
        
        
        

    }
    
    // 評価数をサーバからもってくる
    func getEvalCount() -> Int {
        //リクエストの生成 TODO: evalの追加
        let request : NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: Settings.serverURL + "/get_eval?post_id=\(poi.post_id)")!)
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
        
        return 0
    }


}
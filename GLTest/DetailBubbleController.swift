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
    
    
    @IBAction func backButtonPush(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "\(poi.post_id) : \(poi.message)"
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let file_name = poi.file_path.componentsSeparatedByString("/")[1]
        let url = NSURL(string: "\(Settings.serverURL)/\(file_name)")
        
        var imageData :NSData = NSData(contentsOfURL: url!)!
        detailImage.image = UIImage(data:imageData)
        
        println("\(Settings.serverURL)/\(file_name)")
        println(poi.file_path)
    }
}
/*

    バブルの詳細画面

*/


import UIKit
import Fabric
import TwitterKit

class DetailBubbleController: UIViewController {
    
    var poi : POI! //位置情報
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func backButtonPush(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "\(poi.post_id) : \(poi.message)"
    }
}
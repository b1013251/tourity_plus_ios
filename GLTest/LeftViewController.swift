/*

Twitterログインのボタン

*/

import UIKit

class LeftViewController: UIViewController {
    
    var viewController : UINavigationController!
    
    var postViewController : UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let postViewController : PostViewController
            = storyboard.instantiateViewControllerWithIdentifier("PostViewController") as! PostViewController
        self.postViewController = UINavigationController(rootViewController: postViewController)
    }
    
    override func viewDidAppear(animated: Bool) {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func movePostView(sender: AnyObject) {
        //投稿に行く
        self.slideMenuController()?.changeMainViewController(self.postViewController, close: true)
    }
    
}


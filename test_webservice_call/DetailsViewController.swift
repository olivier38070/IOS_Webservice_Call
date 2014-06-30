//
//  DetailsViewController.swift


import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet var messageLabel : UILabel
    
    var name:String?
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    init(coder aDecoder: NSCoder!)
    {
        super.init(coder: aDecoder)
    }
    
    // call after segue is called in ViewController.swift !
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messageLabel.text = name
       
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func  setImagForSelectedTeam()
//        
//    {
//        
//        teamFlagImageView.image = UIImage(named:selectedteamName)
//        
//    }
    
    
    
    /*
    // #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}

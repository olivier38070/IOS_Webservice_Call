//
//  DetailsViewController.swift


import UIKit

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var messageLabel : UILabel
    @IBOutlet var message2 : UILabel
    @IBOutlet var myTableView : UITableView
    
    var name:String?
    var isConnected:String?
    var userUploads:UserUploads = UserUploads()
    
    var tableData: NSArray = NSArray()
    var myArray: [String] = ["olivier", "ws_user1"]
    
    
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
        self.message2.text = isConnected
        
        // Do any additional setup after loading the view.
        myTableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return userUploads.uploads.count
    }
    
    // Called when each row is built
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
//        println("detail row : "  + indexPath.row.description)
//        
//        //the tablecell is optional to see if we can reuse cell
//        var cell : UITableViewCell?
//        cell = tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
//        
//        //If we did not get a reuseable cell, then create a new one
//        if !cell? {
//            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
//        }
//        
////        cell!.textLabel.text = self.myArray[indexPath.row]
//        
//        cell!.textLabel.text = "prj Code :" + userUploads.uploads[indexPath.row].valueForKey("projectCode").description
//        
//        //var myFont:UIFont = UIFont(name:"Arial", size: 10.0 );
//        //cell!.textLabel.font  = myFont;
//        
        
        var cell2: tableViewCell_details_def = tableView.dequeueReusableCellWithIdentifier("cell") as tableViewCell_details_def

        cell2.label1.text = "Code:" + userUploads.uploads[indexPath.row].valueForKey("projectCode").description + " - " + "Site :" + userUploads.uploads[indexPath.row].valueForKey("siteNumber").description + " - " + "subject :" + userUploads.uploads[indexPath.row].valueForKey("subjectID").description
        return cell2
    }
    
    // called when click on a row
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        //        var code: String = tableData[indexPath.row].valueForKey("projectCode") as String
        //        var projectProtocol: String = tableData[indexPath.row].valueForKey("protocol") as String
        //
        //        var name: String = tableData[indexPath.row].valueForKey("userEmail") as String
        //
        //        //Show the alert view with the tracks information
        //        var alert: UIAlertView = UIAlertView()
        //        alert.title = name
        //        alert.message = code + " " + projectProtocol + " "
        //        alert.addButtonWithTitle("Ok")
        //        alert.show()
        
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

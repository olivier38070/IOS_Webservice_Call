//
//  ViewController.swift
//  test_webservice_call
//
//  Created by olivier on 6/26/14.
//  Copyright (c) 2014 olivier. All rights reserved.
//


// Help here :
// http://bharathnagarajrao.wordpress.com/2014/06/17/swiftly-learning-swift/


import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, WebServicesAPIProtocol {
    
    @IBOutlet var appsTableView : UITableView
    
    var webService: webServiceCallAPI = webServiceCallAPI()
    
    var tableData: NSArray = NSArray()
    var imageCache = NSMutableDictionary()
    var sumaryLoaded : Bool = false;
    
    var summary: NSDictionary = NSDictionary()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        sumaryLoaded = false;
        webService.delegate = self;
        webService.getInfos()
        
        // not needed. TODO Investigate why ???
        //self.appsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    result
    {
    getInfosResult =     (
    {
    Infos = "<null>";
    LocalTime = "<null>";
    UTCTime = "<null>";
    filesModality =             (
    MR,
    CT
    );
    uploadUID = "<null>";
    userEmail = titi;
    },
    {
    Infos = "<null>";
    siteID = 10;
    uploadUID = "<null>";
    userEmail = toto;
    }
    );
    
    
    
    
    result
    {
    getSumaryResult =     {
    NbUserConnected = 2;
    NbUserConnectedToday = 2;
    SitesNumber =         (
    0001,
    006
    );
    filesModality =         (
    {
    name = MR;
    number = 5;
    },
    {
    name = CT;
    number = 2;
    }
    );
    filesType =         (
    {
    name = DCM;
    number = 124;
    }
    );
    projectProtocol =         (
    "gs-us-312-0115",
    "bms747158-301"
    );
    
    
    */
    
    
    // response received by web service
    func didRecieveResponse(results: NSDictionary) {
        if (sumaryLoaded == false)
        {
            summary = results.valueForKey("getSumaryResult") as NSDictionary
            // refresh tableView to insert the datas
            appsTableView.reloadData()
        }
        else
        {
            tableData = results.valueForKey("getInfosResult") as NSArray
            // refresh tableView to insert the datas
            appsTableView.reloadData()
            
        }
        
    }
    
    
    
    
    // this is called when user has clicked (tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    // after that, the DetailsViewController is shown
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!)
    {
        if segue.identifier == "DetailsViewID"
        {
            let detailsViewController = segue.destinationViewController as DetailsViewController
            detailsViewController.name  = "titi"
        }
        
    }
    
    
    
    
    
    
    // Called after a reloadData()
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        println("count " , tableData.count)
        
        // first call, with summary datas, returne the number of users + 1 row for the summary
        if (sumaryLoaded == false && summary.count > 0) {
            var count = summary.valueForKey("usersConnected").count
            return count + 1
        }
        //else {
        //    return tableData.count
        //}
        
        
        // during inits, we return 0, as the table will not show anything.
        return 0;
        
    }
    
    // Called when each row is built
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        println("line " , indexPath.row)
        
//        //the tablecell is optional to see if we can reuse cell
//        var cell : UITableViewCell?
//        cell = tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
//        
//        //If we did not get a reuseable cell, then create a new one
//        if !cell? {
//            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
//        }
//        if self.tableData.count == 0 {
//            return cell
//        }
        
        var cell2: tableViewCell_def = tableView.dequeueReusableCellWithIdentifier("cell") as tableViewCell_def
        
        if (indexPath.row == 0) {
            sumaryLoaded = true;
            
            cell2.label1.text = "File Transfer Status";
            
            var user1 = "Users connected : "
            var user2 = summary.valueForKey("NbUserConnected") as NSString
            cell2.label2.text = user1 + user2
            
            var str = "Nb uploadCompleted : "
                str += summary.valueForKey("nbUploadCompleted") as String
            cell2.label4.text = str
            //webService.getUploadInfos(summary.valueForKey("usersConnected")[0] as NSString )
            
        }
        else
        {
            var users = summary.valueForKey("usersConnected") as NSArray
            var currentUser = users[indexPath.row-1] as  NSString
            cell2.label1.text = "User : " + currentUser
            
            cell2.label2.text = ""
            cell2.label3.text = ""
            cell2.label4.text = ""
            //cell2.label2.text = "" //summary[indexPath.row].valueForKey("NbUserConnected") as NSString
        }
        
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
        
        // used with segue, and detailsViewController
        //self.indexOfSelectedTeam = indexPath.row
        self.performSegueWithIdentifier("DetailsViewID", sender: self)
    }
    
    
    
    
    //
    //    println("line " , indexPath.row)
    //
    //    //the tablecell is optional to see if we can reuse cell
    //    var cell : UITableViewCell?
    //    cell = tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
    //
    //    //If we did not get a reuseable cell, then create a new one
    //    if !cell? {
    //    cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
    //    }
    //
    //
    //    if self.tableData.count == 0 {
    //    return cell
    //    }
    //    //
    //    //        cell!.text = tableData[indexPath.row].valueForKey("projectCode") as String
    //    //        cell!.detailTextLabel.text = tableData[indexPath.row].valueForKey("protocol") as NSString
    //    //
    //
    //
    
    
    //cell!.textLabel.text = self.items[indexPath.row]
    // Get the track censored name
    //var trackCensorName: NSString = rowData["projectProtocol"] as NSString
    //cell!.detailTextLabel.text = trackCensorName
    
    //
    //            cell!.image = UIImage(named: "loading")
    //
    //
    //            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
    //
    //                // Grab the artworkUrl60 key to get an image URL
    //                var urlString: NSString = rowData["artworkUrl60"] as NSString
    //
    //                // Check the image cache for the key (using the image URL as key)
    //                var image: UIImage? = self.imageCache.valueForKey(urlString) as? UIImage
    //
    //                if( !image? ) {
    //                    // If the image does not exist in the cache then we need to download it
    //                    var imgURL: NSURL = NSURL(string: urlString)
    //
    //                    //Get the image from the URL
    //                    var request: NSURLRequest = NSURLRequest(URL: imgURL)
    //                    var urlConnection: NSURLConnection = NSURLConnection(request: request,
    //                        delegate: self)
    //
    //                    NSURLConnection.sendAsynchronousRequest(request, queue:
    //                        NSOperationQueue.mainQueue(), completionHandler: {(response:
    //                            NSURLResponse!,data: NSData!,error: NSError!) -> Void in
    //
    //                            if !error? {
    //                                image = UIImage(data: data)
    //
    //                                // Store the image in the cache
    //                                self.imageCache.setValue(image, forKey: urlString)
    //                                cell!.image = image
    //                                tableView.reloadData()
    //                            }
    //                            else {
    //                                println("Error: \(error.localizedDescription)")
    //                            }
    //                        })
    //
    //                }
    //                else {
    //                    cell!.image = image
    //                }
    //
    //
    //                })
    //
    
    
    //var cell2:UITableViewCell = self.appsTableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
    //cell2.textLabel.text = self.items[indexPath.row]
    
    //return cell
    
    //}
    
    
}


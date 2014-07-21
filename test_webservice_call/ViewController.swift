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

class UserUploads {
    var userName: String = String()
    var isConnected:String = String()
    
    var uploads = [NSDictionary]()
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, WebServicesAPIProtocol {
    
    @IBOutlet var appsTableView : UITableView
    
    var webService: webServiceCallAPI = webServiceCallAPI()
    
    var sumaryLoaded : Bool = false;
    var summary: NSDictionary = NSDictionary()
    
    var usersConnected: NSArray = NSArray()
    var userUploads:[UserUploads] = [UserUploads]()
    
    var nbUsersInfosReceived:Int = 0
    var nbUsersInfosToReceive = 0

    var RowClicked:Int = 0
    
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
    
    // response received by web service
    func didRecieveResponse(results: NSDictionary) {
        
        if (sumaryLoaded == false)
        {
            sumaryLoaded = true
            // Get summary infos. this will be listed in the first row of the table view
            
            summary = results.valueForKey("getSumaryResult") as NSDictionary
            // refresh tableView to insert the datas
            appsTableView.reloadData()
            
            // save the users connected
            usersConnected = summary.valueForKey("usersConnected") as NSArray
            
            nbUsersInfosReceived = 0
            nbUsersInfosToReceive = usersConnected.count
            
            println("nb users connected : " + usersConnected.count.description)
            
        }
        else
        {
            var userUpload:UserUploads = UserUploads()
            
            // get the array related to one user, containing one/several uploads
            var someUploads = results.valueForKey("getUsersUploadsResult") as NSDictionary

            var userName = someUploads.valueForKey("UserName") as NSString
            userUpload.userName = userName
            var isconnected = someUploads.valueForKey("isConnected") as NSString
            userUpload.isConnected = isconnected
            var uploads = someUploads.valueForKey("uploads") as NSArray
            
            // enumerate the uploads in the response object
            for index in 0...uploads.count-1 {
                var upload = uploads[index] as NSDictionary
                userUpload.uploads.append(upload)
            }
            // add the userUpload to the main list
            userUploads.append(userUpload)
            
            // refresh tableView to insert the datas
            appsTableView.reloadData()
        }
        
        // request a set of infos about uploads of one user
        
        if (nbUsersInfosReceived < nbUsersInfosToReceive) {
            //for index in 0...self.usersConnected.count-1
            var currentUser = usersConnected[nbUsersInfosReceived] as  NSString
            println("request user : " + currentUser )
            
            self.webService.delegate = self;
            self.webService.getUploadInfos(currentUser)
            nbUsersInfosReceived++
        }
        
    }
    
    
    
    // this is called when user has clicked (tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    // after that, the DetailsViewController is shown
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!)
    {
        if segue.identifier == "DetailsViewID"
        {
            if (RowClicked == 0) {
                let detailsViewController = segue.destinationViewController as DetailsViewController
                detailsViewController.name  = "Summary"
                
                var user1 = "Users : "
                var user2 = summary.valueForKey("NbUserConnected") as NSString
                
                var str = "Nb upload Completed : "
                str += summary.valueForKey("nbUploadCompleted") as String

                detailsViewController.isConnected = user1 + user2 + " - " + str
            }
            else {
                let detailsViewController = segue.destinationViewController as DetailsViewController
                detailsViewController.name  = usersConnected[RowClicked-1].description
                detailsViewController.isConnected = userUploads[RowClicked-1].isConnected
                detailsViewController.userUploads = userUploads[RowClicked-1]
                
            }
        }
        
    }
    
    
    // Called after a reloadData()
    // have to return the number of row of the table view
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        
        // return nb row of table view + 1 : first row show the summary
        if (summary.count > 0) {
            var count = usersConnected.count;
            return count + 1
        }
        
        // during inits, we return 0, as the table will not show anything.
        return 0;
        
    }
    
    // Called when each row is built
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        println("tableView row : " + indexPath.row.description)
        
        var cell2: tableViewCell_def = tableView.dequeueReusableCellWithIdentifier("cell") as tableViewCell_def
        
        if (indexPath.row == 0) {
            // define the forst row = summary infos
            
            cell2.label1.text = "File Transfer Status";
            
            var user1 = "Users : "
            var user2 = summary.valueForKey("NbUserConnected") as NSString
            cell2.label2.text = user1 + user2
            cell2.label3.text = ""
            
            var str = "Nb upload Completed : "
            str += summary.valueForKey("nbUploadCompleted") as String
            cell2.label4.text = str
        }
        else
        {
            if (userUploads.count > 0 && (indexPath.row-1) < userUploads.count) {
            
                println("usersInfos nb lines " + userUploads.count.description)
                var user = userUploads[indexPath.row-1]
                var uploads = user.uploads
                var lastUpload = uploads[uploads.count-1]
                
                var currentUser = user.userName as  NSString
                cell2.label1.text = "-- " + currentUser

                var conn = user.isConnected
                if (conn == "") {
                    cell2.label2.text = "Connected : no"
                }
                else {
                    cell2.label2.text = "Connected : yes"
                }
                cell2.label3.text = "nb uploads : " + uploads.count.description
                
                cell2.label4.text = "last connection " + lastUpload.valueForKey("startTime").description
            }
        }
        
        return cell2
    }
    
    // called when click on a row
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        // used with segue, and detailsViewController
        
        RowClicked = indexPath.row
        self.performSegueWithIdentifier("DetailsViewID", sender: self)
    }
    

    
    
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


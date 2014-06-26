//
//  ViewController.swift
//  test_webservice_call
//
//  Created by olivier on 6/26/14.
//  Copyright (c) 2014 olivier. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, WebServicesAPIProtocol {
    
    @IBOutlet var appsTableView : UITableView
    
    var webService: webServiceCallAPI = webServiceCallAPI()
    
    var tableData: NSArray = NSArray()
    var imageCache = NSMutableDictionary()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        webService.delegate = self;
        webService.getInfos("Jimmy Buffett")
        
        //self.appsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // response received by web service
    func didRecieveResponse(results: NSDictionary) {
        
        tableData = results.valueForKey("getInfosResult") as NSArray
        
        // refresh tableView to insert the datas
        appsTableView.reloadData()
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        
        return tableData.count
    }
    
    // Called when each row is built
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        println("line " , indexPath.row)
        
        //the tablecell is optional to see if we can reuse cell
        var cell : UITableViewCell?
        cell = tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
        
        //If we did not get a reuseable cell, then create a new one
        if !cell? {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        }
        
        
        if self.tableData.count == 0 {
            return cell
        }
        
        cell!.text = tableData[indexPath.row].valueForKey("projectCode") as String
        cell!.detailTextLabel.text = tableData[indexPath.row].valueForKey("projectProtocol") as NSString
        
        return cell
        
    }
    
    // called when click on a row
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        var code: String = tableData[indexPath.row].valueForKey("projectCode") as String
        var projectProtocol: String = tableData[indexPath.row].valueForKey("projectProtocol") as String
        var email: String = tableData[indexPath.row].valueForKey("userEmail") as String
        var name: String = tableData[indexPath.row].valueForKey("userName") as String

        //Show the alert view with the tracks information
        var alert: UIAlertView = UIAlertView()
        alert.title = name
        alert.message = code + " " + projectProtocol + " " + email
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
    
    
    
    
    
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


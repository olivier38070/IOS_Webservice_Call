//
//  WebProtocol.swift
//  test_webservice_call
//
//  Created by olivier on 6/26/14.
//  Copyright (c) 2014 olivier. All rights reserved.
//
import UIKit
import Foundation

// help here :
// http://www.codeproject.com/Articles/105273/Create-RESTful-WCF-Service-API-Step-By-Step-Guide
// http://network-development.blogspot.fr/2014/06/access-rest-web-service-with-apples-new.html
// http://stackoverflow.com/questions/24074042/getting-values-from-json-array-in-swift
// http://stackoverflow.com/questions/24326918/nested-json-data-will-cause-crash-using-ns-dictionary-in-swift



protocol WebServicesAPIProtocol {
    func didRecieveResponse(results: NSDictionary)
}

class webServiceCallAPI: NSObject {
    var data: NSMutableData = NSMutableData()
    var delegate: WebServicesAPIProtocol?

    var currentUser:String = String()
    
    //Clean up the search terms by replacing spaces with +
    //var itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ",
    //    withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch,
    //    range: nil)
    //var escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
    //var urlPath = "https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=music"
    
    func getInfos() {
        // do an asynchronous call
        //var urlPath = "http://dev-transfer.mywebsend.com/serviceRest.svc/GetInfos/"
        var urlPath = "http://10.4.2.139:8084/serviceRest.svc/GetSumary/"
        
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self,startImmediately: false)
        
        //println("URL \(url)")
        connection.start()
    }
    
    func getUploadInfos(searchTerm: String) {
        self.currentUser = searchTerm
        
        // do an asynchronous call
        //var urlPath = "http://dev-transfer.mywebsend.com/serviceRest.svc/GetInfos/"
        var urlPath = "http://10.4.2.139:8084/serviceRest.svc/GetUseruploads/" + searchTerm
        
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self,startImmediately: false)
        
        //println("URL \(url)")
        connection.start()
    }
    
    //NSURLConnection Connection failed
    func connection(connection: NSURLConnection!, didFailWithError error: NSError!) {
        var error = "Connection Failed :\(error.localizedDescription)"
        println(error)
        
        var alert: UIAlertView = UIAlertView()
        alert.title = "Attention"
        alert.message = error
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
    
    //New request so we need to clear the data object
    func connection(didReceiveResponse: NSURLConnection!, didReceiveResponse response:NSURLResponse!) {
        self.data = NSMutableData()
    }
    
    //Append incoming data
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        self.data.appendData(data)
    }
    
    //NSURLConnection delegate function
    func connectionDidFinishLoading(connection: NSURLConnection!) {

        var error: NSError?
        
        var jsonResult : AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error)
        
        if let err = error {
        var errorStr = "json error in the web service : " + error!.localizedDescription
            println(errorStr)
            var alert: UIAlertView = UIAlertView()
            alert.title = "Attention"
            alert.message = errorStr
            alert.addButtonWithTitle("Ok")
            alert.show()
            return
        }
        
        //Finished receiving data and convert it to a JSON object
        //var jsonResult: AnyObject! = NSJSONSerialization.JSONObjectWithData(data,
        //    options:NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
        
        println("web service returned : ")
        println (jsonResult)
        
        // send response to "client"
        var jsonDict = jsonResult as NSDictionary
        delegate?.didRecieveResponse(jsonDict)
    }
    
    
    

}


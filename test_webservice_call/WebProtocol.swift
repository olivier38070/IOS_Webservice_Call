//
//  WebProtocol.swift
//  test_webservice_call
//
//  Created by olivier on 6/26/14.
//  Copyright (c) 2014 olivier. All rights reserved.
//
import UIKit

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

    //Clean up the search terms by replacing spaces with +
    //var itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ",
    //    withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch,
    //    range: nil)
    //var escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
    //var urlPath = "https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=music"
    
    func getInfos(searchTerm: String) {

        // do an asynchronous call
        //var urlPath = "http://dev-transfer.mywebsend.com/serviceRest.svc/GetInfos/"
        var urlPath = "http://10.4.2.139:8084/serviceRest.svc/GetInfos/"
        
        var url: NSURL = NSURL(string: urlPath)
        var request: NSURLRequest = NSURLRequest(URL: url)
        var connection: NSURLConnection = NSURLConnection(request: request, delegate: self,startImmediately: false)
        
        println("Search at URL \(url)")
        
        connection.start()
    }
    
    //NSURLConnection Connection failed
    func connection(connection: NSURLConnection!, didFailWithError error: NSError!) {
        println("Failed with error:\(error.localizedDescription)")
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

        //Finished receiving data and convert it to a JSON object
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data,
            options:NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        
        println("result ")
        println (jsonResult)
        
        // send response to "client"
        delegate?.didRecieveResponse(jsonResult)
    }
    
    
    

}


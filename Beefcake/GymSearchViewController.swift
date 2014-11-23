//
//  GymSearchViewController.swift
//  Beefcake
//
//  Created by Ryan Connors on 11/22/14.
//  Copyright (c) 2014 Ryan Connors. All rights reserved.
//

import UIKit

class GymSearchViewController: UIViewController, UIWebViewDelegate {
    
    
    //------------
    // UI elements
    //------------
    
    // UIWebView for displaying Gym website
    @IBOutlet var webView: UIWebView!
    
    
    //-----------------
    // Global Variables
    //-----------------
    
    // Search data passed down from upstream view controller
    var searchURLPassedDown : String = "https://www.google.com/search?q=gyms&oq=gyms&aqs=chrome..69i57j0l5.629j0j7&sourceid=chrome&es_sm=119&ie=UTF-8"
    
    

    //-------------------------------------------------------
    // Function to be run when the GymMapViewController loads
    //-------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("url Passed Down: \(searchURLPassedDown)")
        
        // convert gymUrl into an NSURL object and store its object reference
        var url = NSURL(string: searchURLPassedDown)
        
        /*
        Convert the NSURL object into an NSURLRequest object and store its object
        reference into the local variable request. An NSURLRequest object represents
        a URL load request in a manner independent of protocol and URL scheme.
        */
        var request = NSURLRequest(URL: url!)
        
        // Ask the webView object to display the web page for the given URL
        webView.loadRequest(request)
    }
    
    
    //-----------------------------------------------------------
    // Function to call when the device recieves a memory warning
    //-----------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    ----------------------------------
    MARK: - UIWebView Delegate Methods
    ----------------------------------
    */
    func webViewDidStartLoad(webView: UIWebView!) {
        // Starting to load the web page. Show the animated activity indicator in the status bar
        // to indicate to the user that the UIWebVIew object is busy loading the web page.
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView!) {
        // Finished loading the web page. Hide the activity indicator in the status bar.
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webView(webView: UIWebView!, didFailLoadWithError error: NSError!) {
        /*
        Ignore this error if the page is instantly redirected via javascript or in another way.
        NSURLErrorCancelled is returned when an asynchronous load is cancelled, which happens
        when the page is instantly redirected via javascript or in another way.
        */
        if error.code == NSURLErrorCancelled {
            return
        }
        
        // An error occurred during the web page load. Hide the activity indicator in the status bar.
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        // Create the error message in HTML as a character string and store it into the local constant errorString
        let errorString = "<html><font size=+2 color='red'><p>An error occurred: <br />Possible causes for this error:<br />- No network connection<br />- Wrong URL entered<br />- Server computer is down</p></font></html>" + error.localizedDescription
        
        // Display the error message within the UIWebView object
        self.webView.loadHTMLString(errorString, baseURL: nil)
    }


}

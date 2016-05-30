//
//  JavaViewController.swift
//  SlideMenuControllerSwift
//

import UIKit
import WebKit
import EmitterKit


extension WKWebView {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return nil
    }
}

class JavaViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView?
    
    /* Start the network activity indicator when the web view is loading */
    func webView(webView: WKWebView,
                 didStartProvisionalNavigation navigation: WKNavigation){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    /* Stop the network activity indicator when the loading finishes */
    func webView(webView: WKWebView,
                 didFinishNavigation navigation: WKNavigation){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webView(webView: WKWebView,
                 decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse,
                                                   decisionHandler: ((WKNavigationResponsePolicy) -> Void)){
        
        print(navigationResponse.response.MIMEType)
        
        decisionHandler(.Allow)
        
    }
    
    override func viewWillAppear(animated: Bool) {
//        self.setScreeName("My Screen Name")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /* Create our preferences on how the web page should be loaded */
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        
        /* Create a configuration for our preferences */
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        /* Now instantiate the web view */
        webView = WKWebView(frame: view.bounds, configuration: configuration)
        
        if let theWebView = webView{
            /* Load a web page into our web view */
            let url = NSURL(string: "http://www.apple.com")
            let urlRequest = NSURLRequest(URL: url!)
            theWebView.scrollView.bounces = false
            theWebView.loadRequest(urlRequest)
            theWebView.navigationDelegate = self
            view.addSubview(theWebView)
            
        }
        
    }
    
}


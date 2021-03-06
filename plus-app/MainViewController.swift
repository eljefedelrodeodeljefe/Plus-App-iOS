//
//  ViewController.swift
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


class MainViewController: UIViewController, WKNavigationDelegate {


    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }

    override func viewWillAppear(animated: Bool) {
        //        self.setScreeName("My Screen Name")
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

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


    override func viewDidLoad() {
        super.viewDidLoad()
        // listen for navigation events, first thing
        EventEmitter.shared.listener = EventEmitter.shared.menu.on {
          msg in self.webView!.evaluateJavaScript("Native.router.go('\(msg)')") { (result, error) in
          	if error != nil {
          		print(result)
          	}
          }
        }
        // this fixes the webiew being und the navigation
        self.edgesForExtendedLayout = .None

        /* Create our preferences on how the web page should be loaded */
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true

        /* Create a configuration for our preferences */
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences

        /* Now instantiate the web view */
        webView = WKWebView(frame: view.frame, configuration: configuration)


        if let theWebView = webView{
            /* Load a web page into our web view */
            let url = NSBundle.mainBundle().URLForResource("bundle", withExtension: "html")
            let urlRequest = NSURLRequest(URL: url!)


            theWebView.scrollView.bounces = false
            theWebView.loadRequest(urlRequest)
            theWebView.navigationDelegate = self
            view.addSubview(theWebView)


        }

    }

}


extension MainViewController : SlideMenuControllerDelegate {

    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }

    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
    }

    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }

    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }

    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }

    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }

    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }

    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
}

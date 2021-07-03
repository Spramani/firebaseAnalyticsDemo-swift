//
//  ViewController.swift
//  firebaseAnalyticsProject
//
//  Created by Adsum MAC 2 on 01/07/21.
//

import UIKit
import FirebaseAnalytics
import FirebaseCore
import WebKit

class ViewController: UIViewController,WKScriptMessageHandler {
    var titles:String = "shubh"
    var food:String = ""
    
    private var webView: WKWebView!
    private var projectURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Get the hosted site url from the GoogleService-Info.plist file.
            let plistPath = Bundle.main.path(forResource: "GoogleService-Info",
                                             ofType: "plist")!
            let plist = NSDictionary(contentsOfFile: plistPath)!
            let appID = plist["PROJECT_ID"] as! String

            let projectURLString = "https://\(appID).firebaseapp.com"
            self.projectURL = URL(string: projectURLString)!

            // Initialize the webview and add self as a script message handler.
            self.webView = WKWebView(frame: self.view.frame)
        self.webView.backgroundColor = .blue
            // [START add_handler]
            self.webView.configuration.userContentController.add(self, name: "firebase")
            // [END add_handler]
            self.view.addSubview(self.webView)
        // Do any additional setup after loading the view.
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
          AnalyticsParameterItemID: "id-\(titles)",
            AnalyticsParameterItemName: titles,
          AnalyticsParameterContentType: "cont"
          ])

        Analytics.setUserProperty(food, forName: "favorite_food")
        

    }
    
   
    
    func userContentController(_ userContentController: WKUserContentController,
                             didReceive message: WKScriptMessage) {
      guard let body = message.body as? [String: Any] else { return }
      guard let command = body["command"] as? String else { return }
      guard let name = body["name"] as? String else { return }

      if command == "setUserProperty" {
        guard let value = body["value"] as? String else { return }
        Analytics.setUserProperty(value, forName: name)
      } else if command == "logEvent" {
        guard let params = body["parameters"] as? [String: NSObject] else { return }
        Analytics.logEvent(name, parameters: params)
      }
    }

}


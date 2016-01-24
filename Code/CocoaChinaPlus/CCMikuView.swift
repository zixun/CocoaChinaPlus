//
//  CCMikuView.swift
//  CocoaChinaPlus
//
//  Created by user on 16/1/24.
//  Copyright © 2016年 zixun. All rights reserved.
//

import UIKit
import JavaScriptCore
import Neon

class CCMikuView: UIWebView {

    static let sharedMiku = CCMikuView()
    
    class func showMiku() {
        let shared = CCMikuView.sharedMiku
        shared.delegate = shared
        shared.backgroundColor = UIColor.clearColor()
        shared.opaque = false;
        shared.show()
    }
    
    func show() {
        let window = UIApplication.sharedApplication().keyWindow
        if window != nil {
            window?.addSubview(self)
            self.anchorInCorner(Corner.BottomLeft, xPad: 20, yPad: 20, width: 100, height: 100);
            let url = "http://localhost:8989/miku-dancing.coding.io/index.html"
            self.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
        }
        
        
    }
    
    

}

extension CCMikuView: UIWebViewDelegate {
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        let context = webView.valueForKeyPath("documentView.webView.mainFrame.javaScriptContext") as! JSContext
        
        context.evaluateScript("control.dance(1)")
        context.evaluateScript("control.play()")
        
        //        context.evaluateScript("control.mute(true)")
        
        context.exceptionHandler = { context, exception in
            print("JS Error: \(exception)")
        }
        
    }
}

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
import RxSwift


class CCMikuView: UIView {
    
    private let webview = CCMikuWebView()
    
    private let disposeBag = DisposeBag()
    
    convenience init() {
        self.init(frame:CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        self.addSubview(self.webview);
        self.webview.userInteractionEnabled = false;
        self.webview.show()
        
        
        let pan = UIPanGestureRecognizer()
        self.addGestureRecognizer(pan);
        pan.rx_event
            .subscribeNext {[unowned self] (pan:UIGestureRecognizer) -> Void in
                self.dragMe(pan as! UIPanGestureRecognizer)
            }
            .addDisposableTo(self.disposeBag)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.webview.fillSuperview()
    }
    
    func dragMe(ges:UIPanGestureRecognizer) {
        let dragPoint = ges.locationInView(self.superview)
        
        self.center = dragPoint;
        
        print(NSStringFromCGPoint(dragPoint))
        
        if ges.state == .Began {
            
        }else if(ges.state == .Changed) {
            
        }else if (ges.state == .Ended || ges.state == .Cancelled || ges.state == .Failed) {
            
            
        }
    }
    
    
    
}


private class CCMikuWebView: UIWebView {
    
    convenience init() {
        self.init(frame:CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.delegate = self
        self.backgroundColor = UIColor.clearColor()
        self.opaque = false;
    }
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        let url = "http://localhost:8989/miku-dancing.coding.io/index.html"
        self.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
    }
    
    /**
     播放
     */
    func play() {
        self.evaluateScript("control.play()")
    }
    
    /**
     暂停
     */
    func pause() {
        self.evaluateScript("control.pause()")
    }
    
    
    
    private func evaluateScript(string:String) {
        let context = self.valueForKeyPath("documentView.webView.mainFrame.javaScriptContext") as! JSContext
        context.evaluateScript(string)
    }

}

extension CCMikuWebView: UIWebViewDelegate {
    
    @objc func webViewDidFinishLoad(webView: UIWebView) {
        
        let context = webView.valueForKeyPath("documentView.webView.mainFrame.javaScriptContext") as! JSContext
        
        context.evaluateScript("control.dance(1)")
        context.evaluateScript("control.play()")
        
        //        context.evaluateScript("control.mute(true)")
        
        context.exceptionHandler = { context, exception in
            print("JS Error: \(exception)")
        }
        
    }
}

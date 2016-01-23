//
//  AppDelegate.swift
//  CocoaChina+
//
//  Created by zixun on 15/8/11.
//  Copyright © 2015年 zixun. All rights reserved.
//

import UIKit
import RxSwift
import GCDWebServer
import JavaScriptCore
import Neon


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let tabbarController = ZXTabBarController()
    
    var webserver = GCDWebServer()
    
    private var webview:UIWebView?
    
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //开启webserver
        self.startWebServer()
        
        //各种平台配置
        CCAppConfiguration.configure(application, launchOptions: launchOptions)
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        if let window = self.window {
            window.backgroundColor = UIColor.blackColor()
            window.rootViewController = self.tabbarController
            window.makeKeyAndVisible()
            
            //程序员鼓励师Miku
            let webview = UIWebView()
            webview.delegate = self
            self.webview = webview;
            self.window!.addSubview(self.webview!)
            self.webview!.backgroundColor = UIColor.clearColor()
            self.webview!.opaque = false;
            
            self.webview!.anchorInCorner(Corner.BottomLeft, xPad: 20, yPad: 20, width: 100, height: 100);
            let url = "http://localhost:8989/miku-dancing.coding.io/index.html"
            self.webview!.loadRequest(NSURLRequest(URL: NSURL(string: url)!))

            
        }

        //UINavigationBar设置
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        UINavigationBar.appearance().barTintColor = UIColor.blackColor()
        
        //statusBar设置
        UIApplication.sharedApplication().statusBarHidden = false
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        //删除一个星期前阅读过的未收藏的文章
        CCArticleService.cleanMouthAgo()
        
        
        
        //模拟器模拟自动登录
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            let str = "simulator" as NSString
            
        #endif
        
        return true
    }
    
    private func startWebServer() {
        if let web = NSBundle.mainBundle().resourcePath?.NS.stringByAppendingPathComponent("miku-dancing.coding.io") {
            self.webserver.addGETHandlerForBasePath("/miku-dancing.coding.io/", directoryPath: web, indexFilename: nil, cacheAge: 0, allowRangeRequests: true)
        }
        
        self.webserver.startWithPort(8989, bonjourName: "Code+")
        print("Visit \(self.webserver?.serverURL) in your web browser")
    }
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        APService.registerDeviceToken(deviceToken)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        APService.handleRemoteNotification(userInfo)
        CCRemoteNotificationHandler.sharedHandler.handle(userInfo)
    }
    
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    // App进入后台
    func applicationDidEnterBackground(application: UIApplication) {
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    }
    
    // App将要从后台返回
    func applicationWillEnterForeground(application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    // 申请处理时间
    func applicationWillTerminate(application: UIApplication) {
    }
    

    
    //分享跳转相关
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return UMSocialSnsService.handleOpenURL(url)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return UMSocialSnsService.handleOpenURL(url)
    }
}

extension AppDelegate : UIWebViewDelegate {
    func webViewDidFinishLoad(webView: UIWebView) {
        
        let context = self.webview!.valueForKeyPath("documentView.webView.mainFrame.javaScriptContext") as! JSContext
        context.evaluateScript("control.music(false)")
        context.evaluateScript("control.mute(false)")
        
        
        context.evaluateScript("control.dance(1)")
        context.evaluateScript("control.play()")
    }
}



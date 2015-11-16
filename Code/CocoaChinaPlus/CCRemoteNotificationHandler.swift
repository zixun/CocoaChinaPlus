//
//  CCRemoteNotificationHandler.swift
//  CocoaChinaPlus
//
//  Created by chenyl on 15/9/24.
//  Copyright © 2015年 zixun. All rights reserved.
//

import UIKit

class CCRemoteNotificationHandler: NSObject,UIAlertViewDelegate {
    
    static let sharedHandler : CCRemoteNotificationHandler = {
        return CCRemoteNotificationHandler()
    }()
    
    private var identity : String?
    
    func handle(userInfo:NSDictionary) {
        guard userInfo.count > 1 else {
            return;
        }
        
        let state = UIApplication.sharedApplication().applicationState
        
        if let aps = userInfo["aps"] as? NSDictionary {
            
            let alert = aps["alert"] as! String
            if let cocoachina_url = userInfo["cocoachina"] {
                self.identity = CCURLHelper.generateIdentity(cocoachina_url  as! String)
                
                if state == UIApplicationState.Active {
                    
                    UIAlertView(title: "新消息",
                              message: alert,
                             delegate: self,
                    cancelButtonTitle: "下次吧",
                    otherButtonTitles: "学习一下").show()
                }else {
                    
                    ZXOpenURL("go/ccp/article?identity=\(self.identity! )")
                }
                
            }
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1  && self.identity != nil {
            ZXOpenURL("go/ccp/article?identity=\(self.identity!)")
        }
    }
    
    
}

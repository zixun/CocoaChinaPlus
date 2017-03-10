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
    
    fileprivate var identity : String?
    
    func handle(_ userInfo:NSDictionary) {
        guard userInfo.count > 1 else {
            return;
        }
        
        let state = UIApplication.shared.applicationState
        
        if let aps = userInfo["aps"] as? NSDictionary {
            
            let alert = aps["alert"] as! String
            if let cocoachina_url = userInfo["cocoachina"] {
                self.identity = CCURLHelper.generateIdentity(cocoachina_url  as! String)
                
                if state == UIApplicationState.active {
                    
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
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1  && self.identity != nil {
            ZXOpenURL("go/ccp/article?identity=\(self.identity!)")
        }
    }
    
    
}

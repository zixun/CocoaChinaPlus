//
//  CCAccountMannage.swift
//  CocoaChinaPlus
//
//  Created by zixun on 15/9/30.
//  Copyright © 2015年 zixun. All rights reserved.
//

import Foundation

class CCAccountMannage: NSObject,EMChatManagerDelegate {
    
    var sessionNotifi = NSNotification(name: "kNotificationSessionChange", object: nil)
    
    static let sharedManage:CCAccountMannage = {
            return CCAccountMannage()
    }()
    
    override init() {
        super.init()
        //设置代理
        EaseMob.sharedInstance().chatManager.removeDelegate(self)
        EaseMob.sharedInstance().chatManager.addDelegate(self, delegateQueue: nil)
    }
    
    
    func didAutoLoginWithInfo(loginInfo: [NSObject : AnyObject]!, error: EMError!) {
        self.postSessionChangeNotification()
    }
    
    
    func loginWithDeviceToken(deviceToken:NSData) {
        let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        let deviceTokenString: String = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            var error:EMError?
            let chatManage = EaseMob.sharedInstance().chatManager

            let isAutoLogin = chatManage.isAutoLoginEnabled
            if isAutoLogin == false {
                //注册
                chatManage.registerNewAccount(deviceTokenString, password: "111111", error: &error)
                //登陆
                chatManage.loginWithUsername(deviceTokenString, password: "111111", error: &error)
                if (error == nil) {
                    // 设置自动登录
                    SwiftFucker.fuckSetIsAutoLoginEnabled()
                    //发送session改变通知
                    self.postSessionChangeNotification()
                    
                    //加入聊天室
                    chatManage.joinChatroom("111927801463964084", error: &error)
                }
            }
        })
    }
    
}

extension CCAccountMannage {
    private func postSessionChangeNotification() {
        NSNotificationCenter.defaultCenter().postNotification(sessionNotifi)
    }
}

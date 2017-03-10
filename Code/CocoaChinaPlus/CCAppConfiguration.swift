//
//  CCAppConfiguration.swift
//  CocoaChinaPlus
//
//  Created by zixun on 15/9/25.
//  Copyright © 2015年 zixun. All rights reserved.
//

import UIKit

class CCAppConfiguration: NSObject {
    
    class func configure(_ application: UIApplication, launchOptions: [AnyHashable: Any]?) {
        
        //友盟统计配置
        CCAppConfiguration.configureYoumengStatistics()
        
        //友盟分享配置
        CCAppConfiguration.configureYoumengSocial()
        
        //极光推送
        CCAppConfiguration.configureJPush(launchOptions)
        
    }
    
    /**
    友盟统计配置
    */
    fileprivate class func configureYoumengStatistics() {
        
        let channel = Bundle.main.infoDictionary!["ZXApplicationChannel"] as! String
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        
        MobClick.start(withAppkey: CCAppKey.appUM, reportPolicy: BATCH, channelId: channel)
        MobClick.setAppVersion(version)
        
        MobClick.updateOnlineConfig()
    }
    
    /**
    友盟分享配置
    */
    fileprivate class func configureYoumengSocial() {
        UMSocialManager.default().umSocialAppkey = CCAppKey.appUM
        UMSocialManager.default().setPlaform(UMSocialPlatformType.wechatSession, appKey: CCAppKey.appWeChat.appkey, appSecret: CCAppKey.appWeChat.secret, redirectURL: "http://sns.whalecloud.com/sina2/callback")
        
        UMSocialManager.default().setPlaform(UMSocialPlatformType.sina, appKey: CCAppKey.appSina.appkey, appSecret: CCAppKey.appSina.secret, redirectURL: "http://sns.whalecloud.com/sina2/callback")
        
    }
    
    /**
    极光推送配置
    */
    fileprivate class func configureJPush(_ launchOptions: [AnyHashable: Any]?) {
//        let type = UIUserNotificationType.badge.rawValue | UIUserNotificationType.sound.rawValue | UIUserNotificationType.alert.rawValue
//        APService.register(forRemoteNotificationTypes: type, categories: nil)
//        APService.setup(withOption: launchOptions)
//        
//        if launchOptions != nil {
//            if let userInfo = launchOptions![UIApplicationLaunchOptionsKey.remoteNotification] as? NSDictionary {
//                CCRemoteNotificationHandler.sharedHandler.handle(userInfo);
//            }
//        }
    }
    
}

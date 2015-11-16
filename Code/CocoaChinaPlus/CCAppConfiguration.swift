//
//  CCAppConfiguration.swift
//  CocoaChinaPlus
//
//  Created by zixun on 15/9/25.
//  Copyright © 2015年 zixun. All rights reserved.
//

import UIKit

class CCAppConfiguration: NSObject {
    
    class func configure(application: UIApplication, launchOptions: [NSObject: AnyObject]?) {
        
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
    private class func configureYoumengStatistics() {
        
        let channel = NSBundle.mainBundle().infoDictionary!["ZXApplicationChannel"] as! String
        let version = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        
        MobClick.startWithAppkey(CCAppKey.appUM, reportPolicy: BATCH, channelId: channel)
        MobClick.setAppVersion(version)
        
        MobClick.updateOnlineConfig()
    }
    
    /**
    友盟分享配置
    */
    private class func configureYoumengSocial() {
        UMSocialData.setAppKey(CCAppKey.appUM)
        UMSocialWechatHandler.setWXAppId(CCAppKey.appWeChat.appkey, appSecret: CCAppKey.appWeChat.secret, url: nil)
        UMSocialSinaHandler.openSSOWithRedirectURL("http://sns.whalecloud.com/sina2/callback")
        UMSocialConfig.hiddenNotInstallPlatforms([UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline])
    }
    
    /**
    极光推送配置
    */
    private class func configureJPush(launchOptions: [NSObject: AnyObject]?) {
        let type = UIUserNotificationType.Badge.rawValue | UIUserNotificationType.Sound.rawValue | UIUserNotificationType.Alert.rawValue
        APService.registerForRemoteNotificationTypes(type, categories: nil)
        APService.setupWithOption(launchOptions)
        
        if launchOptions != nil {
            if let userInfo = launchOptions![UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary {
                CCRemoteNotificationHandler.sharedHandler.handle(userInfo);
            }
        }
    }
    
}

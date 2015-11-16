//
//  ZXTabBarController.swift
//  CocoaChinaPlus
//
//  Created by 子循 on 15/7/27.
//  Copyright © 2015年 zixun. All rights reserved.
//

import UIKit
import ZXKit

class ZXTabBarController: UITabBarController,UITabBarControllerDelegate {
    
    
    var chatController:CChatListViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 0
        self.tabBar.barTintColor = UIColor.blackColor()
        
        let homeVC = CCPHomeViewController()
        homeVC.tabBarItem = UITabBarItem(title: "首页", image:  UIImage.Asset.Home.image , tag: 0)
        let nav_cc = ZXNavigationController(rootViewController: homeVC)
        
        
        let bbsVC = CCPBBSViewController(navigatorURL: NSURL(string: "go/ccp/bbs")!, query: ["link":"http://www.cocoachina.com/bbs/3g/"])
        bbsVC.tabBarItem = UITabBarItem(title: "论坛", image: UIImage.Asset.Bbs.image, tag: 1)
        let nav_bbs = ZXNavigationController(rootViewController: bbsVC)
        
        self.chatController = CChatListViewController()
        chatController.tabBarItem = UITabBarItem(title: "聊天", image: UIImage.Asset.TabbarChat.image, tag: 2)
        let nav_chat = ZXNavigationController(rootViewController: chatController)

        let profileVC = CCProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: "我", image: UIImage.Asset.TabbarProfile.image, tag: 2)
        let nav_profile = ZXNavigationController(rootViewController: profileVC)
        
        
        self.viewControllers = [nav_cc,nav_bbs,nav_chat,nav_profile]
        
    }

}

//
//  CChatListViewController.swift
//  CocoaChinaPlus
//
//  Created by chenyl on 15/9/30.
//  Copyright © 2015年 zixun. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyUserDefaults
import Neon
import RxSwift
import ZXKit
import CCAD

class CChatListViewController: ZXBaseViewController {
    
    private var adBanner: CCADBanner!
    
    private let disposeBag = DisposeBag()
    
    convenience init() {
        self.init(navigatorURL: NSURL(string: "go/ccp/chatlist")!, query: Dictionary<String, String>())
    }
    
    
    required init(navigatorURL URL: NSURL, query: Dictionary<String, String>) {
        super.init(navigatorURL: URL, query: query)
        
        self.adBanner = CCADBanner(type: CCADBannerViewType.Chat, rootViewController: self, completionBlock: { (succeed:Bool, userInfo:[NSObject : AnyObject]!) -> Void in
            
        })
        self.view.addSubview(self.adBanner);
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        alert("请加QQ群:516326791")
        
        self.adBanner.anchorAndFillEdge(.Bottom, xPad: 0, yPad: 0, otherSize:48)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
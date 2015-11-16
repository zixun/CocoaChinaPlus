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

class CChatListViewController: ZXBaseViewController {
    
    
    private let disposeBag = DisposeBag()
    
    convenience init() {
        self.init(navigatorURL: NSURL(string: "go/ccp/chatlist")!, query: Dictionary<String, String>())
    }
    
    
    required init(navigatorURL URL: NSURL, query: Dictionary<String, String>) {
        super.init(navigatorURL: URL, query: query)
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        alert("请加QQ群:516326791")
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
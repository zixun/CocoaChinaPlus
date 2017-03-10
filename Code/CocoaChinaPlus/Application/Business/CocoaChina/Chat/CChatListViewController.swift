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
import AppBaseKit

class CChatListViewController: ZXBaseViewController {
    
    
    fileprivate let disposeBag = DisposeBag()
    
    init() {
        super.init(navigatorURL: URL(string: "go/ccp/chatlist")!, query: Dictionary<String, String>())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIAlertView.quickTip(message: "请加QQ群:516326791")
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(navigatorURL URL: URL?, query: Dictionary<String, String>) {
        fatalError("init(navigatorURL:query:) has not been implemented")
    }

}

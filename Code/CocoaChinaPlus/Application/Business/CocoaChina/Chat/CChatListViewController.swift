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
    
    var adview:UIView?
    private let adBanner = CCADBanner()
    
    private let disposeBag = DisposeBag()
    
    convenience init() {
        self.init(navigatorURL: NSURL(string: "go/ccp/chatlist")!, query: Dictionary<String, String>())
    }
    
    
    required init(navigatorURL URL: NSURL, query: Dictionary<String, String>) {
        super.init(navigatorURL: URL, query: query)
        
        self.adBanner
            .rx_adModelObservable(.ChatBottom)
            .subscribeNext { [weak self] (adModel:CCADModel) -> Void in
                guard let sself = self else {
                    return
                }
                
                if sself.adview != nil {
                    sself.adview!.removeFromSuperview()
                    sself.adview = nil
                }
                sself.adview = adModel.adView
                sself.view.addSubview(sself.adview!)
            }
            .addDisposableTo(self.disposeBag)
        
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        alert("请加QQ群:516326791")
        
        self.adview?.anchorAndFillEdge(.Bottom, xPad: 0, yPad: 0, otherSize:48)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
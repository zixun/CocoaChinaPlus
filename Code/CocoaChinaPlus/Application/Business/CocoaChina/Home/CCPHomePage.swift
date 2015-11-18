//
//  CCPHomePage.swift
//  CocoaChinaPlus
//
//  Created by 子循 on 15/7/19.
//  Copyright © 2015年 zixun. All rights reserved.
//

import UIKit
import ZXKit

// MARK: CCPHomePage
class CCPHomePage: ZXPage {

    private weak var internalDisplayView: UIView?
    
    func setDisplayView(view: UIView?) {
        
        //清除原先的 internalDisplayView
        if let displayView = self.internalDisplayView {
            displayView.removeFromSuperview()
        }
        
        //設定為新的 view
        if let unwrapView = view {
            unwrapView.frame = self.bounds
            self.contentView.addSubview(unwrapView)
            self.internalDisplayView = unwrapView
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.internalDisplayView?.frame = self.bounds
    }
    
}


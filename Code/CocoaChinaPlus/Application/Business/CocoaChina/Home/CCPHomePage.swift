//
//  CCPHomePage.swift
//  CocoaChinaPlus
//
//  Created by 子循 on 15/7/19.
//  Copyright © 2015年 zixun. All rights reserved.
//

import UIKit
import SDWebImage
import ZXKit

class CCPHomePage: ZXPage {

    var displayView:UIView?
    
    func setDisplayVieww(view:UIView?) {
//        if view == self.displayView {
//            return
//        }
        
        if self.displayView != nil {
            self.displayView!.removeFromSuperview()
            self.displayView = nil
        }
        
        if view != nil {
            view!.frame = self.bounds
            self.contentView.addSubview(view!)
        }
        
        self.displayView = view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.displayView?.frame = self.bounds
    }
}


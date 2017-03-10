//
//  CCPTableViewCell.swift
//  CocoaChinaPlus
//
//  Created by zixun on 15/8/29.
//  Copyright © 2015年 zixun. All rights reserved.
//

import UIKit
import Neon
import AppBaseKit

class CCPTableViewCell: UITableViewCell {
    
    var containerView : UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor(hex:0x272626)
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xf8f8f8, alpha: 0.1)
        self.selectedBackgroundView = view
        
        self.containerView = UIView()
        self.containerView.backgroundColor = UIColor.black
        self.addSubview(self.containerView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.fillSuperview(left: 2, right: 2, top: 0.5, bottom: 0.5)
    }
}

//
//  UIImage+SwiftGen.swift
//  CocoaChinaPlus
//
//  Created by user on 15/11/2.
//  Copyright © 2015年 zixun. All rights reserved.
//

import Foundation
import UIKit

//该文件内容由SwiftGen生成  https://github.com/AliSoftware/SwiftGen

extension UIImage {
    enum Asset : String {
        case About = "about"
        case Chengxuyuan = "chengxuyuan"
        case GuidePage1 = "guide_page_1"
        case GuidePage2 = "guide_page_2"
        case GuidePage3 = "guide_page_3"
        case GuidePage4 = "guide_page_4"
        case IcDetailBack = "ic_detail_back" //貌似没用
        case NavCancel = "nav_cancel"
        case NavLikeNo = "nav_like_no"
        case NavLikeYes = "nav_like_yes"
        case NavSearch = "nav_search"
        case Share = "share"
        case Sharetest = "sharetest"
        case IconLight = "icon_light"
        case Bbs = "bbs"
        case Home = "home"
        case TabbarChat = "tabbar_chat"
        case TabbarProfile = "tabbar_profile"
        case Top = "top"
        
        var image: UIImage {
            return UIImage(asset: self)
        }
    }
    
    convenience init!(asset: Asset) {
        self.init(named: asset.rawValue)
    }
}
//
//  AppDef.swift
//  CocoaChinaPlus
//
//  Created by zixun on 15/8/26.
//  Copyright © 2015年 zixun. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import ZXKit

extension DefaultsKeys {
    //标志导航页是否显示过
    static let isGuideShowed = DefaultsKey<Bool>("isGuideShowed")
    
}

class CCAppKey: NSObject {
    
    static let appUM: String = "55dd4329e0f55a36b3003830"
    
    static let appWeChat:(appkey:String,secret:String) =
                         ("wx7880b78e750cb34f",
                          "b0cabfd6d2d6990e12f433a4c41c9227")
    
    static let appSina:(appkey:String,secret:String) =
                       ("640791572",
                        "98e198bb7ed319b4326371be09daaf55")
    
    static let appRongyun:(appkey:String,secret:String) =
                          ("x18ywvqf8uxvc",
                           "Kjg5SscjVZ3")
}

func kADText() -> String {
    return "打造体验最好的第三方CocoaChina客户端\n\nCocoaChina+"
}

extension UIColor {
    static func assistColor() ->UIColor {
        return ZXColor(0x00B9FF)
    }
    
    static func appGrayColor() ->UIColor {
        return ZXColor(0xB4B4B4)
    }
}
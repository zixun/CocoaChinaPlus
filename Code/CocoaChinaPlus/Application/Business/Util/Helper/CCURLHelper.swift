//
//  CCPTools.swift
//  CocoaChinaPlus
//
//  Created by zixun on 15/8/22.
//  Copyright © 2015年 zixun. All rights reserved.
//

import Foundation

class CCURLHelper: NSObject {
    
    class func generateIdentity(url: String) -> String {
        let target = url.lowercaseString;
        
        if (target.rangeOfString("wap") != nil) {
            //wap
            return url.componentsSeparatedByString("=").last!
        }else {
            //pc
            return url.componentsSeparatedByString("/").last!.componentsSeparatedByString(".").first!
        }
    }
    
    class func generateWapURL(identity:String) -> String {
        return "http://www.cocoachina.com/cms/wap.php?action=article&id=\(identity)"
    }
    
    class func generateWapURLFromURL(url:String) -> String {
        let identity = self.generateIdentity(url)
        return self.generateWapURL(identity)
    }
}
//
//  CCPTools.swift
//  CocoaChinaPlus
//
//  Created by zixun on 15/8/22.
//  Copyright © 2015年 zixun. All rights reserved.
//

import Foundation

class CCURLHelper: NSObject {
    
    class func generateIdentity(_ url: String) -> String {
        let target = url.lowercased();
        
        if (target.range(of: "wap") != nil) {
            //wap
            return url.components(separatedBy: "=").last!
        }else {
            //pc
            return url.components(separatedBy: "/").last!.components(separatedBy: ".").first!
        }
    }
    
    class func generateWapURL(_ identity:String) -> String {
        return "http://www.cocoachina.com/cms/wap.php?action=article&id=\(identity)"
    }
    
    class func generateWapURLFromURL(_ url:String) -> String {
        let identity = self.generateIdentity(url)
        return self.generateWapURL(identity)
    }
}

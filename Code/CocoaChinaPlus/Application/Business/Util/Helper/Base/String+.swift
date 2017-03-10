//
//  String+.swift
//  CocoaChinaPlus
//
//  Created by zixun on 17/1/23.
//  Copyright © 2017年 zixun. All rights reserved.
//

import Foundation
import AppBaseKit

extension String {
    
    public func stringByDeletingOccurrencesOfString(_ target: String) -> String {
        return self.NS.replacingOccurrences(of: target, with: "")
    }
    
    public func stringByDeletingScopeString(_ begin:String, end:String) -> String {
        let rangeBegin = self.NS.range(of: begin)
        let rangeEnd = self.NS.range(of: end)
        
        let range = NSRange(location: rangeBegin.location + rangeBegin.length,
                            length: rangeEnd.location - (rangeBegin.location + rangeBegin.length))
        return self.stringByDeletingCharactersInRange(range)
    }
    
    public func stringByDeletingCharactersInRange(_ range: NSRange) -> String {
        return self.NS.replacingCharacters(in: range, with: "")
    }
    
    public func stringByInsertString(str:String, beforeOccurrencesOfString target:String) -> String {
        return self.NS.replacingOccurrences(of: target, with: str + target)
    }
}

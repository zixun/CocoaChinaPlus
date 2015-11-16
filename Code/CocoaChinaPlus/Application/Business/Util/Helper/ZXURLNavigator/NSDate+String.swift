//
//  NSDate+String.swift
//  CocoaChinaPlus
//
//  Created by zixun on 15/9/27.
//  Copyright © 2015年 zixun. All rights reserved.
//

import Foundation

extension NSDate {
    func string() ->String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        return dateFormatter.stringFromDate(self)
    }
}

extension String {
    
    func date() -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
        return dateFormatter.dateFromString(self)!
    }
}
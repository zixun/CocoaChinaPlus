//
//  NSString+Delete.swift
//  CocoaChinaPlus
//
//  Created by zixun on 15/9/20.
//  Copyright © 2015年 zixun. All rights reserved.
//

import Foundation

// MARK: - NSString 删除子字符串类别

public extension NSString {
    
    /**
    返回一个删除掉所有出现target字符串的地方的新的字符串
    
    - parameter target: target 字符串
    
    - returns: 新的字符串
    */
    public func stringByDeletingOccurrencesOfString(target: String) -> String {
       return self.stringByReplacingOccurrencesOfString(target, withString: "")
    }
    
    
    
    /**
    删除指定范围内的所有字符串
    
    - parameter begin: 标志指定范围的起始字符串
    - parameter end:   标志指定范围的结束字符串
    
    - returns: 新的字符串
    */
    public func stringByDeletingScopeString(begin:String, end:String) -> String {
        let rangeBegin = self.rangeOfString(begin)
        let rangeEnd = self.rangeOfString(end)
        
        let range = NSRange(location: rangeBegin.location + rangeBegin.length,
                              length: rangeEnd.location - (rangeBegin.location + rangeBegin.length))
        return self.stringByDeletingCharactersInRange(range)
    }
    
    
    /**
    返回一个在所有出现target字符串的地方之前插入指定字符串的新字符串
    
    - parameter str:  待插入的字符串
    - parameter bstr: target字符串
    
    - returns: 新的字符串
    */
    public func stringByInsertString(str:String, beforeOccurrencesOfString target:String) -> String {
       return self.stringByReplacingOccurrencesOfString(target, withString: str + target)
    }

    
    
    
    
    /**
    返回一个删除掉指定范围内出现target字符串的地方的新的字符串
    
    - parameter target:  target 字符串
    - parameter options: 字符比较模式
    - parameter range:   范围
    
    - returns: 新的字符串
    */
    public func stringByDeletingOccurrencesOfString(target: String,
        options: NSStringCompareOptions,
        range: NSRange) -> String {
            
        return self.stringByReplacingOccurrencesOfString(target,
            withString: "",
            options: options,
            range: range)
    }
    
    
    /**
    返回一个删除掉指定范围内所有字符的新的字符串
    
    - parameter range: 范围
    
    - returns: 新的字符串
    */
    public func stringByDeletingCharactersInRange(range: NSRange) -> String {
        return self.stringByReplacingCharactersInRange(range, withString: "")
    }
    

}

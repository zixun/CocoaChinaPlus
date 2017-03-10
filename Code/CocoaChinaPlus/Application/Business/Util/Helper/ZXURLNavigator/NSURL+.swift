//
//  NSURL+.swift
//  CocoaChinaPlus
//
//  Created by zixun on 17/1/24.
//  Copyright © 2017年 zixun. All rights reserved.
//

import Foundation

// MARK: - NSURL参数操作
public extension URL {
    
    /**
     获取URL中的参数字典
     
     - returns: 参数字典
     */
    public func paramDictionary() -> [String : String]? {
        guard let paramString = self.query else {
            return nil
        }
        
        var dic = [String:String]()
        let paramArr:[String] = paramString.components(separatedBy: "&")
        for param in paramArr {
            let entity:[String] = paramString.components(separatedBy: "=")
            dic[entity[0]] = entity[1]
        }
        
        return dic
    }
    
    /**
     获取指定Key的Value
     
     - parameter key: key字符串
     
     - returns: key对应的值
     */
    public func paramValue(key:String) -> String? {
        guard let dic = self.paramDictionary() else {
            return nil
        }
        
        let value = dic[key]
        return value
    }
    
    /**
     判断参数是否存在
     
     - parameter key: 参数的key
     
     - returns: 是否存在
     */
    public func isParamExist(key:String) -> Bool {
        guard let dic = self.paramDictionary() else {
            return false
        }
        
        if dic[key] == nil {
            return false
        }else {
            return true
        }
        
    }
    
    /**
     生成一个添加了指定参数的新的NSURL
     
     - parameter params: 参数键值对数组
     
     - returns: 新的NSURL
     */
    public func newURLByAppendingParams(params:[String : String]) -> URL {
        var urlString = self.absoluteString
        var isFirst = true
        
        for (key,value) in params {
            if isFirst {
                if self.query == nil {
                    //之前没有参数
                    urlString = urlString + "?" + key + "=" + value
                }else {
                    //之前有参数
                    urlString = urlString + "&" + key + "=" + value
                }
                isFirst = false
            }else {
                urlString = urlString + "&" + key + "=" + value
            }
            
        }
        
        return URL(string: urlString)!
    }
    
    /**
     生成一个替换了指定参数的新的NSURL
     
     - parameter params: 参数键值对数组
     
     - returns: 新的NSURL
     */
    public func newURLByReplaceParams(params:[String : String]) -> URL {
        guard var paramDic = self.paramDictionary() else {
            return self
        }
        
        //保存新params到dic
        for (key,value) in params {
            if self.isParamExist(key: key) {
                paramDic[key] = value
            }
        }
        
        //将dic转成string
        var query = "?"
        for (key,value) in paramDic {
            query = query + key + "=" + value + "&"
        }
        query = (query as NSString).substring(to: (query as NSString).length - 1)
        
        let urlString = (self.scheme ?? "http") + "://" + self.host! + (self.path ?? "") + query
        return URL(string: urlString)!
    }
}

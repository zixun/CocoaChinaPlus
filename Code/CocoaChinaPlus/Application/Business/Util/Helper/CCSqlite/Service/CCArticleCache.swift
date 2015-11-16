//
//  CCArticleCache.swift
//  CocoaChinaPlus
//
//  Created by zixun on 15/10/4.
//  Copyright © 2015年 zixun. All rights reserved.
//

import Foundation

let kArticleCache = CCArticleCache.sharedCache

//对保存在数据库中的文章做一个简单的cache，提升访问性能
class CCArticleCache: NSObject {
    
    static let sharedCache: CCArticleCache = {
        return CCArticleCache()
    }()
    
    private var model_collection =  CCArticleService.queryArticles(.Collection)
    private var model_uncollection =  CCArticleService.queryArticles(.UnCollection)
    
    func updateCache() {
        self.model_collection =  CCArticleService.queryArticles(.Collection)
        self.model_uncollection =  CCArticleService.queryArticles(.UnCollection)
    }
    
    func articlesOfType(type:CCArticleType) ->[CCArticleModel] {
        switch type {
            
            case .Collection:
                return model_collection
            
            case .UnCollection:
                return model_uncollection
            
            default:
                return model_collection + model_uncollection
        }
    }
    
    
    
}
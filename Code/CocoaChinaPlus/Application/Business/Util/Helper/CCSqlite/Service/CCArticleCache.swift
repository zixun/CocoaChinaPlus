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
    
    fileprivate var model_collection =  CCArticleService.queryArticles(.collection)
    fileprivate var model_uncollection =  CCArticleService.queryArticles(.unCollection)
    
    func updateCache() {
        self.model_collection =  CCArticleService.queryArticles(.collection)
        self.model_uncollection =  CCArticleService.queryArticles(.unCollection)
    }
    
    func articlesOfType(_ type:CCArticleType) ->[CCArticleModel] {
        switch type {
            
            case .collection:
                return model_collection
            
            case .unCollection:
                return model_uncollection
            
            default:
                return model_collection + model_uncollection
        }
    }
    
    
    
}

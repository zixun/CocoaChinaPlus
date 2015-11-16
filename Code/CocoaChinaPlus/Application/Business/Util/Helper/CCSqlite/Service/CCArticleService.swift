//
//  CCSqlite.swift
//  CocoaChinaPlus
//
//  Created by chenyl on 15/9/8.
//  Copyright © 2015年 zixun. All rights reserved.
//

import UIKit
import SQLite
import ZXKit

let kArticleDAO = CCDB.tableManager.articleDAO

enum CCArticleType {
    case All
    case UnCollection
    case Collection
}


class CCArticleService: NSObject {
    
    //插入一篇文章
    class func insertArtice(model:CCArticleModel) -> Bool {
        
        do{
            try CCDB.connection.run(kArticleDAO.table.insert(
                kArticleDAO.identity <- model.identity,
                kArticleDAO.title     <- model.title,
                kArticleDAO.linkURL <- model.linkURL,
                kArticleDAO.imageURL  <- model.imageURL,
                kArticleDAO.type <- 0,
                kArticleDAO.dateOfRead <- NSDate().string()))
            
            
            CCArticleCache.sharedCache.updateCache()
            
            return true;
        }catch {
            println("add failed: \(error)")
            return false
        }
    }
    
    //文章是否存在 从缓存中取可提高性能（ipod测试，每一行渲染可以提高162ms）
    class func isArticleExsitById(identity:String?) -> Bool {
        guard identity != nil else {
            return false
        }
        
        for model in kArticleCache.articlesOfType(.All) {
            if model.identity == identity {
                return true
            }
        }
        return false
    }
    
    class func isArticleCollectioned(identity:String) ->Bool {
        for model in kArticleCache.articlesOfType(.Collection) {
            if model.identity == identity {
                return true
            }
        }
        return false
    }
    
    //收藏文章
    class func collectArticleById(identity:String) -> Bool {
        let update = kArticleDAO.table.filter(kArticleDAO.identity == identity)
                                      .update(kArticleDAO.type <- 1,
                                              kArticleDAO.dateOfCollection <- NSDate().string())
        
        if try! CCDB.connection.run(update) > 0 {
            print("update alice")
            CCArticleCache.sharedCache.updateCache()
            return true;
        } else {
            print("update not found")
            return false;
        }
    }
    
    //取消收藏
    class func decollectArticleById(identity:String) -> Bool {
        let update = kArticleDAO.table.filter(kArticleDAO.identity == identity)
            .update(kArticleDAO.type <- 0)
        
        if try! CCDB.connection.run(update) > 0 {
            print("update alice")
            CCArticleCache.sharedCache.updateCache()
            return true;
        } else {
            print("update not found")
            return false;
        }
    }
    
    
    //清空一个月前阅读未收藏的文章
    class func cleanMouthAgo() {
        let now = NSDate()
        let articles = CCArticleService.queryArticles(CCArticleType.UnCollection, index: -1)
        for article in articles {
            let dateOfRead = article.dateOfRead!.date()
            let secondsInterval = now.timeIntervalSinceDate(dateOfRead)
            if secondsInterval >= 60 * 60 * 24 * 30 {//
                CCArticleService.deleteArticleById(article.identity)
            }
        }
        CCArticleCache.sharedCache.updateCache()
    }
    
    
    class func queryArticles(type:CCArticleType) ->[CCArticleModel] {
        return CCArticleService.queryArticles(type, index: -1)
    }
    
    //检索文章
    class func queryArticles(type:CCArticleType,index:Int) ->[CCArticleModel] {
        
        var query:QueryType = kArticleDAO.table.select(kArticleDAO.identity,
            kArticleDAO.linkURL,
            kArticleDAO.title,
            kArticleDAO.imageURL,
            kArticleDAO.dateOfCollection,
            kArticleDAO.dateOfRead,
            kArticleDAO.type)
        
        if type == CCArticleType.Collection {
            query = query.filter(kArticleDAO.type == 1)
        }else if type == CCArticleType.UnCollection {
            query = query.filter(kArticleDAO.type == 0)
        }
        
        if index >= 0 {
            query = query.limit(20, offset: index*20)
        }
        
        var result = [CCArticleModel]()
        for article in  CCDB.connection.prepare(query) {
            let model = CCArticleModel()
            model.identity = article[kArticleDAO.identity]
            model.linkURL = article[kArticleDAO.linkURL]
            model.title = article[kArticleDAO.title]
            model.imageURL = article[kArticleDAO.imageURL]
            model.dateOfCollection = article[kArticleDAO.dateOfCollection]
            model.dateOfRead = article[kArticleDAO.dateOfRead]
            model.type = article[kArticleDAO.type]
            result.append(model)
        }
        return result
    }
    
    //删除文章
    private class func deleteArticleById(identity:String) -> Bool {
        do {
            let alice = kArticleDAO.table.filter(kArticleDAO.identity == identity)
            
            if try  CCDB.connection.run(alice.delete()) > 0 {
                print("deleted alice")
                CCArticleCache.sharedCache.updateCache()
                return true;
            } else {
                print("alice not found")
                return false;
            }
        } catch {
            print("delete failed: \(error)")
            return false;
        }
    }
    
}

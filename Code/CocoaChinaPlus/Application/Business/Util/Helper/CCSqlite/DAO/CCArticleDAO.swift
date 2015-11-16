//
//  CCTableArticle.swift
//  CocoaChinaPlus
//
//  Created by zixun on 15/9/27.
//  Copyright © 2015年 zixun. All rights reserved.
//

import Foundation
import SQLite

class CCArticleDAO: NSObject {
    var table : Table = Table("Article")
    
    //文章identity
    let identity = Expression<String>("identity")
    //标题
    let title = Expression<String?>("title")
    //点击url
    let linkURL = Expression<String>("wapURL")
    //图片url
    let imageURL = Expression<String?>("imageURL")
    //是否收藏  0，未收藏 1，收藏
    let type = Expression<Int?>("type")
    //插入数据库时间
    let dateOfRead = Expression<String>("dateOfRead")
    //收藏时间
    let dateOfCollection = Expression<String?>("dateOfCollection")
    
    
    
    convenience init(connection:Connection) {
        self.init()
        weak var weakSelf = self
        try! connection.run(self.table.create(ifNotExists: true) { t in
            
            if let weakSelf = weakSelf {
                t.column(weakSelf.identity)
                t.column(weakSelf.title)
                t.column(weakSelf.linkURL)
                t.column(weakSelf.imageURL)
                t.column(weakSelf.type)
                t.column(weakSelf.dateOfRead)
                t.column(weakSelf.dateOfCollection)
            }
            
        })
    }
}

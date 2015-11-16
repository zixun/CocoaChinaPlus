//
//  CCTable.swift
//  CocoaChinaPlus
//
//  Created by zixun on 15/9/27.
//  Copyright © 2015年 zixun. All rights reserved.
//

import Foundation
import SQLite

class CCTableManager: NSObject {
    private(set) var articleDAO : CCArticleDAO!
    
    convenience init(connection:Connection) {
        self.init()
        self.articleDAO = CCArticleDAO(connection: connection)
    }
}

//
//  CCDataBase.swift
//  CocoaChinaPlus
//
//  Created by zixun on 15/9/27.
//  Copyright © 2015年 zixun. All rights reserved.
//

import Foundation
import SQLite
import AppBaseKit
import Log4G

let CCDB = CCDataBase.sharedDB

class CCDataBase: NSObject {

    static let sharedDB: CCDataBase = {
        return CCDataBase()
    }()
    
    
    fileprivate(set) var tableManager : CCTableManager!
    
    fileprivate(set) var connection : Connection!
    
    override init() {
        super.init()
        do{
            //获取路径
            let path = AppPathForApplicationSupportResource(relativePath: Bundle.main.bundleIdentifier!)
            
            //创建文件
            if !FileManager.default.fileExists(atPath: path) {
                try FileManager.default.createDirectory(
                    atPath: path, withIntermediateDirectories: true, attributes: nil
                )
            }
            
            //建立连接
            self.connection = try Connection("\(path)/db.sqlite3")
            
            //建立数据库表
            self.tableManager = CCTableManager(connection: self.connection)
        }catch {
            Log4G.error("创建数据库失败！原因: \(error)")
        }
    }
}

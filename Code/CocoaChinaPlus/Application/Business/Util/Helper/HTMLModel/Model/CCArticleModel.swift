//
//  CCArticleModel.swift
//  CocoaChinaPlus
//
//  Created by user on 15/10/30.
//  Copyright © 2015年 zixun. All rights reserved.
//

import Foundation

class CCArticleModel: NSObject {
    
    //标题
    var title : String?
    //发表时间
    var postTime : String? {
        get {
            return _postTime
        }
        
        set {
            var str = newValue
            if (str != nil) {
                str = str!.stringByReplacingOccurrencesOfString("\t", withString: "")
                str = str!.stringByReplacingOccurrencesOfString("\r", withString: "")
                str = str!.stringByReplacingOccurrencesOfString("\n", withString: "")
                str = str!.stringByReplacingOccurrencesOfString("\n", withString: "")
                str = str!.stringByReplacingOccurrencesOfString("\n", withString: "")
                str = str!.stringByReplacingOccurrencesOfString(" ", withString: "")
            }
            
            _postTime = str
        }
    }
    //阅读次数
    var viewed: String?
    //图片链接
    var imageURL: String?
    //文章唯一标识
    var identity: String!
    //文章链接
    var linkURL : String {
        get {
            return _linkURL
        }
        
        set {
            _linkURL = CCURLHelper.generateWapURLFromURL(newValue)
            self.identity = CCURLHelper.generateIdentity(newValue)
        }
    }
    
    //数据库用字段
    
    //文章收藏时间
    var dateOfCollection:String?
    //文章阅读时间
    var dateOfRead:String?
    //文章类型
    var type:Int?
    
    
    private var _linkURL : String = "http://www.cocoachina.com"
    
    private var _postTime : String?
}

class CCPOptionModel: NSObject {
    var urlString: String
    var title: String = ""
    
    init(href: String, title:String) {
        self.urlString = "http://www.cocoachina.com\(href)"
        if title == "App Store研究" {
            self.title = "App Store"
        }else {
            self.title = title
        }
        
        super.init()
    }
    
}

class CCPHomeModel: NSObject {
    
    var page:[CCArticleModel]!
    
    var banners:[CCArticleModel] = []
    
    var options:[CCPOptionModel] = []
    
    convenience init(options:[CCPOptionModel], banners:[CCArticleModel], page:[CCArticleModel]) {
        self.init()
        self.options = options
        self.banners = banners
        self.page = page
    }
    
}

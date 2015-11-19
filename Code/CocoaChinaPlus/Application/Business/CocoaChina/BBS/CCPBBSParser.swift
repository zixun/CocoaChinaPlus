//
//  CCPBBSParser.swift
//  CocoaChinaPlus
//
//  Created by zixun on 15/8/12.
//  Copyright © 2015年 zixun. All rights reserved.
//

import UIKit
import Alamofire
import Ji

let baseURL = "http://www.cocoachina.com/bbs/3g"

// MARK: CCPBBSParser
class CCPBBSParser {
    
    //解析
    class func parserBBS(result: (model: CCPBBSModel) -> Void) {
        
        CCRequest(.GET, baseURL).responseJi { (ji, error) -> Void in
            guard let nodes = ji?.xPath("//li[@class='articlelist clearfix']") else {
                return
            }
            
            //檢查資料是否正確, 將正確的部分建立 model
            var options = [CCPBBSOptionModel]()
            for node in nodes {
                guard
                    let titleNode = node.xPath(".//p[@class='title bbs_title']/a").first,
                    let contentNode = node.xPath(".//p[@class='bbs_content']").first,
                    let title = titleNode.content,
                    let content = contentNode.content,
                    let urlString = titleNode["href"]
                    else {
                        print("資料毀損")
                        continue
                }
                
                //建立一個新的 option model
                let option = CCPBBSOptionModel(title: title, content: content, urlString: urlString)
                options.append(option)
            }
            let model = CCPBBSModel(options: options)
            
            //回調
            result(model: model)
        }
    }
    
}

// MARK: CCPBBSModel
class CCPBBSModel {
    
    var options = [CCPBBSOptionModel]()
    
    convenience init(options: [CCPBBSOptionModel]) {
        self.init()
        self.options = options
    }
    
}

// MARK: CCPBBSOptionModel
class CCPBBSOptionModel {
    
    var title  = ""
    var content  = ""
    var urlString  = ""
    
    convenience init(title: String, content: String, urlString: String) {
        self.init()
        self.title = title
        self.content = content
        self.urlString = baseURL + "/" + urlString
    }
    
}
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

class CCPBBSParser: NSObject {

    var baseURL:String = "http://www.cocoachina.com/bbs/3g"
    
    static let sharedParser : CCPBBSParser = {
        return CCPBBSParser()
    }()
    
    func parserBBS(result: (model:CCPBBSModel) ->Void) {
        
        CCRequest(.GET, baseURL).responseJi { (ji, error) -> Void in
            guard let nodes = ji?.xPath("//li[@class='articlelist clearfix']") else {
                return
            }
            var options = [CCPBBSOptionModel]()
            
            for var i = 0; i < nodes.count; i++ {
                let node = nodes[i]
                let titleNode = node.xPath(".//p[@class='title bbs_title']/a").first!
                let contentNode = node.xPath(".//p[@class='bbs_content']").first!
                
                let title = titleNode.content!
                let content = contentNode.content!
                let urlString = titleNode["href"]!
                
                let option = CCPBBSOptionModel(title: title, content: content, urlString: urlString)
                
                options.append(option)
            }
            
            let model = CCPBBSModel(options: options)
            
            result(model:model)
        }
    }
}


class CCPBBSModel : NSObject {
    var options:[CCPBBSOptionModel] = [CCPBBSOptionModel]()
    
    convenience init(options:[CCPBBSOptionModel]) {
        self.init()
        self.options = options
    }
}

class CCPBBSOptionModel : NSObject {
    var title : String = ""
    var content : String = ""
    var urlString: String = ""
    
    convenience init(title:String, content: String, urlString:String) {
        self.init()
        self.title = title
        self.content = content
        self.urlString = "http://www.cocoachina.com/bbs/3g/\(urlString)"
    }
    
}
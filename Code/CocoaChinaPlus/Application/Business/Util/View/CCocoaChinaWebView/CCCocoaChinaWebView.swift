//
//  ZXMarkdownView.swift
//  CocoaChinaPlus
//
//  Created by 子循 on 15/6/12.
//  Copyright © 2015年 zixun. All rights reserved.
//

import Foundation
import UIKit
import Ji
import Kingfisher
import Log4G
class CCCocoaChinaWebView: ZXHighlightWebView {
    
    var title : String!
    var image = R.image.sharetest()
    var imageURL : String!
    
    fileprivate let styleString = "<link type='text/css' rel='stylesheet' href='ccstyle.css'>" +
                              "<script src='jquery-1.6.4.min.js'></script>"
    
    

    func open(_ urlString:String) {
        self.hud.show(true)
        CCRequest(.get, urlString)
            .response {[weak self] (response) -> Void in
            
                guard let sself = self else {
                    return
                }
                
                guard response.error == nil else {
                    Log4G.warning(response.error!)
                    return
                }
                
                guard let data = response.data else {
                    return
                }
                
                
                let str = String(data: data, encoding: String.Encoding.utf8)
                sself.loadCocoaChinaString(str!)
            }
    }
}

//MARK: - Private
extension CCCocoaChinaWebView {
    
    fileprivate func loadCocoaChinaString(_ string:String) {
        let str = _generateNewHTML(string)
        _handleNote(str as String)
        self.loadHTMLString(str as String)
    }
    
    fileprivate func _handleNote(_ html:String) {
        let ji = Ji(htmlString: html)!
        let titleNode = ji.xPath("//div[@class='detailtitle']/h6")!.first!
        self.title = titleNode.content
        
        guard (ji.xPath("//img")?.count)! > 0 else {
            self.image = R.image.sharetest()
            return
        }
        let imageNode = ji.xPath("//img")!.first!
        self.imageURL = imageNode.attributes["src"]!
        let downloader = KingfisherManager.shared.downloader
        downloader.downloadImage(with: URL(string: imageURL)!, options: nil, progressBlock: nil) { [weak self] (image_download:Image?, error:NSError?, imageURL:URL?, originalData:Data?) in
            if let sself = self,let image = image_download {
                DispatchQueue.main.async {
                    sself.image = image
                }
            }
        }
    }
    
    fileprivate func _generateNewHTML(_ originHTML:String) -> String {
        var str = originHTML
        //删除CocoaChina的Head
        str = str.stringByDeletingScopeString("<header>", end: "</header>")
        //baseURL为本地，所以网络资源需要加前缀
        str = str.stringByInsertString(str: "http://www.cocoachina.com", beforeOccurrencesOfString: "/cms/plus/count.php")
        //影响代码着色 删除
        str = str.replacingOccurrences(of: "<pre class=\"brush:js;toolbar:false\">", with: "<pre><code>")
        //删除无用的网络资源请求
        str = str.stringByDeletingOccurrencesOfString("<link href=\"/cms/templets/wap/style/style.css?1113\" rel=\"stylesheet\" type=\"text/css\">")
        str = str.stringByDeletingOccurrencesOfString("<script src=\"http://code.jquery.com/jquery-1.6.4.min.js\"></script>")
        //去除cocoachina自带广告
        str = str.stringByDeletingScopeString("</footer>", end: "</body>")
        //替换写在HTML中的样式
        str = str.replacingOccurrences(of: "rgb(248, 248, 248)", with: "rgba(248, 248, 248, 0.5)")
        //添加本地资源
        str = str.stringByInsertString(str:self.styleString, beforeOccurrencesOfString: "</head>")
        
        return str
    }
}

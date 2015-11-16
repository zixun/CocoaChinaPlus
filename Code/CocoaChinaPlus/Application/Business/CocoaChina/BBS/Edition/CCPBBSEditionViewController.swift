//
//  CCPBBSEditionViewController.swift
//  CocoaChinaPlus
//
//  Created by zixun on 15/8/14.
//  Copyright © 2015年 zixun. All rights reserved.
//

import UIKit
import Alamofire
import Neon
import ZXKit

//static var pagenow = 1

class CCPBBSEditionViewController: ZXBaseViewController {
    
    //UI
    var tableview:UITableView!
    
    //数据
    var dataSource = CCPBBSEditionModel()
    
    //url
    var currentLink:String = ""
    
    required init(navigatorURL URL: NSURL, query: Dictionary<String, String>) {
        super.init(navigatorURL: URL, query: query)
        self.tableview = UITableView(frame: CGRectZero, style: .Plain)
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.backgroundColor = ZXColor(0x000000, alpha: 0.8)
        self.tableview.separatorStyle  = UITableViewCellSeparatorStyle.None
        
        self.view.addSubview(self.tableview)
        
        
            
            
        self.tableview.addInfiniteScrollingWithActionHandler({ () -> Void in
            self.loadNextPage();
        })
        self.tableview.infiniteScrollingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        
        self.currentLink = query["link"]!
        CCPBBSEditionParser.sharedParser.parserEdition(self.currentLink) { [weak self] (model) -> Void in
            if let sself = self {
                sself.dataSource = model
                sself.tableview.reloadData()
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tableview.fillSuperview()
    }
    
    private func loadNextPage() -> Void {
        weak var weakSelf = self
        
        var url = NSURL(string: self.currentLink)!
        var dic = url.paramDictionary()
        if dic!["more"] == nil {
            //之前是第一页
            url = url.newURLByAppendingParams(["more":"1","page":String(self.dataSource.pagenext)])
            self.currentLink = url.absoluteString
        }else {
            url = url.newURLByReplaceParams(["page":String(self.dataSource.pagenext)])
            self.currentLink = url.absoluteString
        }

        CCPBBSEditionParser.sharedParser.parserEdition(url.absoluteString) { (model) -> Void in
            if let weakSelf = weakSelf {
                weakSelf.dataSource.append(model)
                
                var insertIndexPaths = [NSIndexPath]()
                for post : CCPBBSEditionPostModel in model.posts {
                    
                    let row = weakSelf.dataSource.posts.indexOf(post)
                    let indexPath = NSIndexPath(forRow: ((row != nil) ? row : 0)! , inSection: 0)
                    insertIndexPaths.append(indexPath)
                }
                
                weakSelf.tableview.beginUpdates()
                weakSelf.tableview.insertRowsAtIndexPaths(insertIndexPaths, withRowAnimation: UITableViewRowAnimation.None)
                weakSelf.tableview.endUpdates()
                
                weakSelf.tableview.infiniteScrollingView.stopAnimating()
            }
        }
        
    }
}

extension CCPBBSEditionViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let post = self.dataSource.posts[indexPath.row]
        ZXOpenURL("go/ccp/article", param: ["link": post.link])
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CCPBBSEditionTableViewCell")
        if cell == nil {
            cell = CCPBBSEditionTableViewCell(style: .Default, reuseIdentifier: "CCPBBSEditionTableViewCell")
        }
        
        let post = self.dataSource.posts[indexPath.row]
        (cell as! CCPBBSEditionTableViewCell).configure(post)
        
        return cell!
    }
}

class CCPBBSEditionTableViewCell: CCPTableViewCell {
    
    //UI
    private var titleLabel:UILabel!
    private var authorLabel:UILabel!
    private var timeLabel:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.titleLabel = UILabel()
        self.titleLabel.textColor = UIColor.whiteColor()
        self.titleLabel.font = UIFont.boldSystemFontOfSize(14)
        self.titleLabel.textAlignment = NSTextAlignment.Left
        self.titleLabel.numberOfLines = 2
        self.titleLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        self.containerView.addSubview(self.titleLabel)
        
        self.authorLabel = UILabel()
        self.authorLabel.textColor = UIColor.grayColor()
        self.authorLabel.font = UIFont.systemFontOfSize(12)
        self.authorLabel.textAlignment = .Left
        self.containerView.addSubview(self.authorLabel)
        
        self.timeLabel = UILabel()
        self.timeLabel.textColor = UIColor.grayColor()
        self.timeLabel.font = UIFont.systemFontOfSize(12)
        self.timeLabel.textAlignment = .Right
        self.containerView.addSubview(self.timeLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.anchorAndFillEdge(Edge.Top, xPad: 4, yPad: 4, otherSize: AutoHeight)
        self.authorLabel.anchorInCornerWithAutoSize(Corner.BottomLeft, xPad: 4, yPad: 0)
        self.timeLabel.anchorInCornerWithAutoSize(Corner.BottomRight, xPad: 4, yPad: 0)
        
    }
    
    func configure(model: CCPBBSEditionPostModel) {
        titleLabel.text = model.title
        authorLabel.text = model.author
        timeLabel.text = model.time
    }
}


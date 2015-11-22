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
// MARK: ZXBaseViewController
class CCPBBSEditionViewController: ZXBaseViewController {
    
    //UI
    lazy var tableview: UITableView = {
        let newTableView = UITableView(frame: CGRectZero, style: .Plain)
        newTableView.delegate = self
        newTableView.dataSource = self
        newTableView.backgroundColor = ZXColor(0x000000, alpha: 0.8)
        newTableView.separatorStyle = .None
        newTableView.addInfiniteScrollingWithActionHandler({ [weak self] () -> Void in
            guard let sself = self else {
                return
            }
            sself.loadNextPage();
        })
        newTableView.infiniteScrollingView.activityIndicatorViewStyle = .White
        newTableView.registerClass(CCPBBSEditionTableViewCell.self, forCellReuseIdentifier: "CCPBBSEditionTableViewCell")
        return newTableView
    }()
    
    //数据
    var dataSource = CCPBBSEditionModel()
    
    //url
    var currentLink = ""
    
    required init(navigatorURL URL: NSURL, query: Dictionary<String, String>) {
        super.init(navigatorURL: URL, query: query)

        //設置tableview
        self.view.addSubview(self.tableview)
        
        //設置連結
        if let link = query["link"] {
            self.currentLink = link
        } else {
            print("連結缺失")
        }
        
        //讀取資料
        CCPBBSEditionParser.parserEdition(self.currentLink) { [weak self] (model) -> Void in
            guard let sself = self else {
                return
            }
            sself.dataSource = model
            sself.tableview.reloadData()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tableview.fillSuperview()
    }
    
}

// MARK: Private Instance Method
extension CCPBBSEditionViewController {
    
    //加載下一個分頁
    private func loadNextPage() {
        guard
            let url = NSURL(string: self.currentLink),
            let urlParameter = url.paramDictionary()
            else {
                print("連結缺失或參數錯誤")
                return
        }
        
        //建立下一分頁連結
        var newURL: NSURL
        if let _ = urlParameter["more"] {
            newURL = url.newURLByReplaceParams(["page": String(self.dataSource.pagenext)])
            self.currentLink = newURL.absoluteString
        } else {
            //之前是第一页
            newURL = url.newURLByAppendingParams(["more": "1", "page": String(self.dataSource.pagenext)])
            self.currentLink = newURL.absoluteString
        }
        
        //加載
        CCPBBSEditionParser.parserEdition(newURL.absoluteString) { [weak self] (model) -> Void in
            guard let sself = self else {
                return
            }
            
            sself.dataSource.append(model)
            var insertIndexPaths = [NSIndexPath]()
            for post in model.posts {
                let row = sself.dataSource.posts.indexOf(post)
                let indexPath = NSIndexPath(forRow: row ?? 0, inSection: 0)
                insertIndexPaths.append(indexPath)
            }
            sself.tableview.beginUpdates()
            sself.tableview.insertRowsAtIndexPaths(insertIndexPaths, withRowAnimation: .None)
            sself.tableview.endUpdates()
            sself.tableview.infiniteScrollingView.stopAnimating()
        }
    }
    
}

// MARK: UITableViewDataSource
extension CCPBBSEditionViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCellWithIdentifier("CCPBBSEditionTableViewCell", forIndexPath: indexPath) as! CCPBBSEditionTableViewCell
        let post = self.dataSource.posts[indexPath.row]
        cell.configure(post)
        return cell
    }
    
}

// MARK: UITableViewDelegate
extension CCPBBSEditionViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let post = self.dataSource.posts[indexPath.row]
        ZXOpenURL("go/ccp/article", param: ["link": post.link])
    }
    
}

// MARK: CCPBBSEditionTableViewCell
class CCPBBSEditionTableViewCell: CCPTableViewCell {
    
    //UI
    private lazy var titleLabel: UILabel = {
        let newTitleLabel = UILabel()
        newTitleLabel.textColor = UIColor.whiteColor()
        newTitleLabel.font = UIFont.boldSystemFontOfSize(14)
        newTitleLabel.textAlignment = .Left
        newTitleLabel.numberOfLines = 2
        newTitleLabel.lineBreakMode = .ByTruncatingTail
        return newTitleLabel
    }()
    private lazy var authorLabel: UILabel = {
        let newAuthorLabel = UILabel()
        newAuthorLabel.textColor = UIColor.grayColor()
        newAuthorLabel.font = UIFont.systemFontOfSize(12)
        newAuthorLabel.textAlignment = .Left
        return newAuthorLabel
    }()
    private var timeLabel: UILabel = {
        let newTimeLabel = UILabel()
        newTimeLabel.textColor = UIColor.grayColor()
        newTimeLabel.font = UIFont.systemFontOfSize(12)
        newTimeLabel.textAlignment = .Right
        return newTimeLabel
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //設置標題
        self.containerView.addSubview(self.titleLabel)
        
        //設置作者
        self.containerView.addSubview(self.authorLabel)
        
        //設置時間
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


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
import Log4G

//static var pagenow = 1
// MARK: ZXBaseViewController
class CCPBBSEditionViewController: ZXBaseViewController {
    
    //UI
    lazy var tableview: UITableView = {
        let newTableView = UITableView(frame: CGRect.zero, style: .plain)
        newTableView.delegate = self
        newTableView.dataSource = self
        newTableView.backgroundColor = UIColor(hex: 0x000000, alpha: 0.8)
        newTableView.separatorStyle = .none
        newTableView.addInfiniteScrolling(actionHandler: { [weak self] () -> Void in
            guard let sself = self else {
                return
            }
            sself.loadNextPage();
        })
        newTableView.infiniteScrollingView.activityIndicatorViewStyle = .white
        newTableView.register(CCPBBSEditionTableViewCell.self, forCellReuseIdentifier: "CCPBBSEditionTableViewCell")
        return newTableView
    }()
    
    //数据
    var dataSource = CCPBBSEditionModel()
    
    //url
    var currentLink = ""
    
    required init(navigatorURL URL: URL?, query: Dictionary<String, String>) {
        super.init(navigatorURL: URL, query: query)

        //設置tableview
        self.view.addSubview(self.tableview)
        
        //設置連結
        if let link = query["link"] {
            self.currentLink = link
        } else {
            Log4G.error("連結缺失")
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
    fileprivate func loadNextPage() {
        guard
            let url = URL(string: self.currentLink),
            let urlParameter = url.paramDictionary()
            else {
                Log4G.warning("連結缺失或參數錯誤")
                return
        }
        
        //建立下一分頁連結
        var newURL: URL
        if let _ = urlParameter["more"] {
            newURL = url.newURLByReplaceParams(params: ["page": String(self.dataSource.pagenext)])
            self.currentLink = newURL.absoluteString
        } else {
            //之前是第一页
            newURL = url.newURLByAppendingParams(params: ["more": "1", "page": String(self.dataSource.pagenext)])
            self.currentLink = newURL.absoluteString
        }
        
        //加載
        CCPBBSEditionParser.parserEdition(newURL.absoluteString) { [weak self] (model) -> Void in
            guard let sself = self else {
                return
            }
            
            sself.dataSource.append(model)
            var insertIndexPaths = [IndexPath]()
            for post in model.posts {
                let row = sself.dataSource.posts.index(of: post)
                let indexPath = IndexPath(row: row ?? 0, section: 0)
                insertIndexPaths.append(indexPath)
            }
            sself.tableview.beginUpdates()
            sself.tableview.insertRows(at: insertIndexPaths, with: .none)
            sself.tableview.endUpdates()
            sself.tableview.infiniteScrollingView.stopAnimating()
        }
    }
    
}

// MARK: UITableViewDataSource
extension CCPBBSEditionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "CCPBBSEditionTableViewCell", for: indexPath) as! CCPBBSEditionTableViewCell
        let post = self.dataSource.posts[indexPath.row]
        cell.configure(post)
        return cell
    }
    
}

// MARK: UITableViewDelegate
extension CCPBBSEditionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = self.dataSource.posts[indexPath.row]
        ZXOpenURL("go/ccp/article", param: ["link": post.link])
    }
    
}

// MARK: CCPBBSEditionTableViewCell
class CCPBBSEditionTableViewCell: CCPTableViewCell {
    
    //UI
    fileprivate lazy var titleLabel: UILabel = {
        let newTitleLabel = UILabel()
        newTitleLabel.textColor = UIColor.white
        newTitleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        newTitleLabel.textAlignment = .left
        newTitleLabel.numberOfLines = 2
        newTitleLabel.lineBreakMode = .byTruncatingTail
        return newTitleLabel
    }()
    fileprivate lazy var authorLabel: UILabel = {
        let newAuthorLabel = UILabel()
        newAuthorLabel.textColor = UIColor.gray
        newAuthorLabel.font = UIFont.systemFont(ofSize: 12)
        newAuthorLabel.textAlignment = .left
        return newAuthorLabel
    }()
    fileprivate var timeLabel: UILabel = {
        let newTimeLabel = UILabel()
        newTimeLabel.textColor = UIColor.gray
        newTimeLabel.font = UIFont.systemFont(ofSize: 12)
        newTimeLabel.textAlignment = .right
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
        self.titleLabel.anchorAndFillEdge(Edge.top, xPad: 4, yPad: 4, otherSize: AutoHeight)
        self.authorLabel.anchorInCornerWithAutoSize(Corner.bottomLeft, xPad: 4, yPad: 0)
        self.timeLabel.anchorInCornerWithAutoSize(Corner.bottomRight, xPad: 4, yPad: 0)
    }
    
    func configure(_ model: CCPBBSEditionPostModel) {
        titleLabel.text = model.title
        authorLabel.text = model.author
        timeLabel.text = model.time
    }
    
}


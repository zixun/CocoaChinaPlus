//
//  CCPBBSViewController.swift
//  CocoaChinaPlus
//
//  Created by zixun on 15/8/12.
//  Copyright © 2015年 zixun. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import MBProgressHUD
import ZXKit

class CCPBBSViewController: ZXBaseViewController {
    
    var tableView:UITableView = UITableView()
    
    var dataSource:CCPBBSModel = CCPBBSModel(options: [CCPBBSOptionModel]())
    
    required init(navigatorURL URL: NSURL, query: Dictionary<String, String>) {
        super.init(navigatorURL: URL, query: query)
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {

        self.tableView.backgroundColor = ZXColor(0x000000, alpha: 0.8)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .None
        self.view.addSubview(self.tableView)
        
        weak var weakSelf = self
        self.tableView.addPullToRefreshWithActionHandler({ () -> Void in
            if let weakSelf = weakSelf {
                weakSelf._reloadTableView()
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._reloadTableView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tableView.fillSuperview()
    }
    
    private func _reloadTableView() {
        MBProgressHUD.showHUDAddedTo(self.tableView, animated: true)
        weak var weakSelf = self
        CCPBBSParser.sharedParser.parserBBS { (model) -> Void in
            if let weakSelf = weakSelf {
                weakSelf.dataSource = model
                weakSelf.tableView.reloadData()
                weakSelf.tableView.pullToRefreshView.stopAnimating()
                MBProgressHUD.hideHUDForView(weakSelf.tableView, animated: true)
            }
        }
    }
    
}

extension CCPBBSViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.options.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CCPBBSTableViewCell")
        if cell == nil {
            cell = CCPBBSTableViewCell(style: .Default, reuseIdentifier: "CCPBBSTableViewCell")
        }
        
        let option = self.dataSource.options[indexPath.row]
        
        (cell as! CCPBBSTableViewCell).configure(option)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let link = self.dataSource.options[indexPath.row].urlString
        ZXOpenURL("go/ccp/edition", param: ["link": link])
    }
}

class CCPBBSTableViewCell : CCPTableViewCell {
    private var titleLabel:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.titleLabel = UILabel()
        self.titleLabel.font = UIFont.systemFontOfSize(14)
        self.titleLabel.textColor = UIColor.whiteColor()
        self.titleLabel.textAlignment = .Left
        self.titleLabel.numberOfLines = 2
        self.titleLabel.lineBreakMode = .ByTruncatingTail
        self.containerView.addSubview(self.titleLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.fillSuperview(left: 4, right: 0, top: 4, bottom: 0)
    }
    
    func configure(model:CCPBBSOptionModel) {
        self.titleLabel.text = model.title
    }
    
}

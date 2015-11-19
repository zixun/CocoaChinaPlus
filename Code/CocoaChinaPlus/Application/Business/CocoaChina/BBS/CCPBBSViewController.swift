//
//  CCPBBSViewController.swift
//  CocoaChinaPlus
//
//  Created by zixun on 15/8/12.
//  Copyright © 2015年 zixun. All rights reserved.
//

import UIKit
import MBProgressHUD
import ZXKit

// MARK: CCPBBSViewController
class CCPBBSViewController: ZXBaseViewController {
    
    //UI
    private lazy var tableView: UITableView = {
        let newTableView = UITableView()
        newTableView.backgroundColor = ZXColor(0x000000, alpha: 0.8)
        newTableView.delegate = self
        newTableView.dataSource = self
        newTableView.separatorStyle = .None
        
        //tableview 下拉動作
        newTableView.addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            guard let sself = self else {
                return
            }
            sself.reloadTableView()
        })
        newTableView.registerClass(CCPBBSTableViewCell.self, forCellReuseIdentifier: "CCPBBSTableViewCell")
        return newTableView
    }()
    
    private var dataSource = CCPBBSModel(options: [CCPBBSOptionModel]())
    
    required init(navigatorURL URL: NSURL, query: Dictionary<String, String>) {
        super.init(navigatorURL: URL, query: query)
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadTableView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tableView.fillSuperview()
    }
    
}

// Private Instance Method
extension CCPBBSViewController {
    
    //初始化參數
    private func setup() {
        
        //設置 tableview
        self.view.addSubview(self.tableView)
    }
    
    //tableview 重新加載
    private func reloadTableView() {
        MBProgressHUD.showHUDAddedTo(self.tableView, animated: true)
        CCPBBSParser.parserBBS { [weak self] (model) -> Void in
            guard let sself = self else {
                return
            }
            
            sself.dataSource = model
            sself.tableView.reloadData()
            sself.tableView.pullToRefreshView.stopAnimating()
            MBProgressHUD.hideHUDForView(sself.tableView, animated: true)
        }
    }
    
}

// MARK: UITableViewDataSource
extension CCPBBSViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.options.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CCPBBSTableViewCell", forIndexPath: indexPath) as! CCPBBSTableViewCell
        let option = self.dataSource.options[indexPath.row]
        cell.configure(option)
        return cell
    }
    
}

// MARK: UITableViewDelegate
extension CCPBBSViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let link = self.dataSource.options[indexPath.row].urlString
        ZXOpenURL("go/ccp/edition", param: ["link": link])
    }
    
}

// MARK: CCPBBSTableViewCell
class CCPBBSTableViewCell: CCPTableViewCell {
    
    //UI
    private lazy var titleLabel: UILabel = {
        let newTitleLabel = UILabel()
        newTitleLabel.font = UIFont.systemFontOfSize(14)
        newTitleLabel.textColor = UIColor.whiteColor()
        newTitleLabel.textAlignment = .Left
        newTitleLabel.numberOfLines = 2
        newTitleLabel.lineBreakMode = .ByTruncatingTail
        return newTitleLabel
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 設置 titlelabel
        self.containerView.addSubview(self.titleLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.fillSuperview(left: 4, right: 0, top: 4, bottom: 0)
    }
    
    func configure(model: CCPBBSOptionModel) {
        self.titleLabel.text = model.title
    }
    
}

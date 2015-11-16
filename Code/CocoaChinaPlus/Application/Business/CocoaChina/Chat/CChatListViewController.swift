//
//  CChatListViewController.swift
//  CocoaChinaPlus
//
//  Created by chenyl on 15/9/30.
//  Copyright © 2015年 zixun. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyUserDefaults
import Neon
import RxSwift
import ZXKit

class CChatListViewController: ZXBaseViewController {
    
    var tableview:UITableView!
    
    private let disposeBag = DisposeBag()
    
    convenience init() {
        self.init(navigatorURL: NSURL(string: "go/ccp/chatlist")!, query: Dictionary<String, String>())
    }
    
    
    required init(navigatorURL URL: NSURL, query: Dictionary<String, String>) {
        super.init(navigatorURL: URL, query: query)
        
        self.tableview = UITableView(frame: CGRectZero, style: .Plain)
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.scrollEnabled = false
        self.view.addSubview(self.tableview)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        var rect = self.view.bounds
        rect.size.height = 120
        self.tableview.frame = rect
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension CChatListViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CChatList") as?CChatlistTableCell
        if cell == nil {
            cell = CChatlistTableCell(style: .Default, reuseIdentifier: "CChatList")
        }
        
        if indexPath.row == 0 {
            cell!.subjectLabel.text = "开发者交流群"
            cell!.iconView.image = UIImage(named: "groupPrivateHeader")
        }else {
            cell!.subjectLabel.text = "反馈问题"
            cell!.iconView.image = UIImage(named: "chatListCellHead")
        }
        
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        if EaseMob.sharedInstance().chatManager.isLoggedIn == false {
            
            alert("后台正在努力登陆中，客官不要急！")
        }else {
            self.selectWithIndexPath(indexPath)
        }
    }
    
    private func selectWithIndexPath(indexPath:NSIndexPath) {
        if indexPath.row == 0 {
            let chatroom = ChatViewController(chatter: "111927801463964084", conversationType: .eConversationTypeChatRoom)
            chatroom.title = "开发者交流"
            ZXNav().pushViewController(chatroom, animated: true)
        }else {
            let chatroom = ChatViewController(chatter: "admin", isGroup: false)
            chatroom.title = "CocoaChina+"
            ZXNav().pushViewController(chatroom, animated: true)
        }
    }
    
    private func isSameDays(date1:NSDate, _ date2:NSDate) -> Bool {
        let calendar = NSCalendar.currentCalendar()
        
        
        let comps1 = calendar.components([NSCalendarUnit.Month,NSCalendarUnit.Year,NSCalendarUnit.Day], fromDate:date1)
        let comps2 = calendar.components([NSCalendarUnit.Month,NSCalendarUnit.Year,NSCalendarUnit.Day], fromDate:date2)
        
        return (comps1.day == comps2.day) && (comps1.month == comps2.month) && (comps1.year == comps2.year)
    }

}

class CChatlistTableCell:UITableViewCell {
    
    var iconView:UIImageView!
    var subjectLabel : UILabel!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.blackColor()
        //Init Views
        self.iconView = UIImageView()
        self.addSubview(self.iconView)
        
        self.subjectLabel = UILabel()
        self.subjectLabel.textAlignment = NSTextAlignment.Left
        self.subjectLabel.textColor = UIColor.whiteColor()
        self.addSubview(self.subjectLabel)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.iconView.anchorAndFillEdge(Edge.Left, xPad: 20, yPad: 5, otherSizeTupling: 1)
        self.subjectLabel.alignAndFillWidth(align: .ToTheRightCentered, relativeTo: self.iconView, padding: 5, height: AutoHeight)
    }
    
    
}
//
//  CCProfileViewController.swift
//  CocoaChinaPlus
//
//  Created by zixun on 15/10/1.
//  Copyright © 2015年 zixun. All rights reserved.
//

import UIKit
import Neon

class CCProfileViewController: ZXBaseViewController {

    private var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.tableview = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
        self.tableview.backgroundColor = UIColor.blackColor()
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.separatorStyle = .None
        self.tableview.contentInset = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
        self.view.addSubview(self.tableview)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.tableview.fillSuperview()
    }

}

extension CCProfileViewController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 2
        default:return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell = tableview.dequeueReusableCellWithIdentifier("CCProfileFaceCell") as? CCProfileFaceCell
            if cell == nil {
                cell = CCProfileFaceCell(style: .Default, reuseIdentifier: "CCProfileViewController")
            }
            return cell!
        }else {
            var cell = tableview.dequeueReusableCellWithIdentifier("CCProfileUsualCell") as? CCProfileUsualCell
            if cell == nil {
                cell = CCProfileUsualCell(style: .Default, reuseIdentifier: "CCProfileUsualCell")
            }
            
            
            if indexPath.section == 1 {
                switch indexPath.row {
                case 0:
                    cell!.infoLabel.text = "浏览历史"
                case 1:
                    cell!.infoLabel.text = "我的收藏"
                default: break
                }
            }else if indexPath.section == 2 {
                switch indexPath.row {
                case 0:
                    cell!.infoLabel.text = "意见反馈"
                case 1:
                    cell!.infoLabel.text = "关于CocoaChina+"
                default: break
                }
            }
            
            return cell!
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        }
        return 50
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1
        }else {
            return 20
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                ZXOpenURL("go/ccp/collection?type=0")
            case 1:
                ZXOpenURL("go/ccp/collection?type=1")
            default: break
            }
        }else if indexPath.section == 2 {
            
            switch indexPath.row {
            case 0 :
                print("QQqun")
                
            case 1:
                let vc = CCAboutViewController()
                ZXNav().pushViewController(vc, animated: true)
            default: break
            }
            
            
        }
        
        
    }
}

class CCProfileUsualCell : CCPTableViewCell {
    var infoLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.infoLabel = UILabel()
        self.infoLabel.textColor = UIColor.whiteColor()
        self.infoLabel.textAlignment = NSTextAlignment.Left
        self.infoLabel.font = UIFont.systemFontOfSize(16)
        self.containerView.addSubview(self.infoLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.infoLabel.anchorAndFillEdge(Edge.Left, xPad: 20, yPad: 0, otherSize: self.containerView.frame.size.width - 20)
    }
}

class CCProfileFaceCell : CCPTableViewCell {
    private var icon : UIImageView!
    
    private var tostaLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.icon = UIImageView(image: UIImage.Asset.Chengxuyuan.image.circleImage())
        self.containerView.addSubview(self.icon)
        
        self.tostaLabel = UILabel()
        self.tostaLabel.text = "这个世界上只有10种人：懂二进制的和不懂二进制的"
        self.tostaLabel.textColor = UIColor.whiteColor()
        self.tostaLabel.textAlignment = .Center
        self.tostaLabel.font = UIFont.systemFontOfSize(12)
        self.containerView.addSubview(self.tostaLabel)
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.tostaLabel.anchorAndFillEdge(.Bottom, xPad: 0, yPad: 0, otherSize: 20)
        let distance = self.tostaLabel.frame.origin.y
        self.icon.align(.AboveCentered, relativeTo: self.tostaLabel, padding: 0, width: distance , height: distance)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  CCProfileViewController.swift
//  CocoaChinaPlus
//
//  Created by zixun on 15/10/1.
//  Copyright © 2015年 zixun. All rights reserved.
//

import UIKit
import Neon
import Log4G

class CCProfileViewController: ZXBaseViewController {

    fileprivate var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.tableview = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
        self.tableview.backgroundColor = UIColor.black
        self.tableview.delegate = self
        self.tableview.dataSource = self
        self.tableview.separatorStyle = .none
        self.tableview.contentInset = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
        self.view.addSubview(self.tableview)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.tableview.fillSuperview()
    }

}

extension CCProfileViewController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell = tableview.dequeueReusableCell(withIdentifier: "CCProfileFaceCell") as? CCProfileFaceCell
            if cell == nil {
                cell = CCProfileFaceCell(style: .default, reuseIdentifier: "CCProfileViewController")
            }
            return cell!
        }else {
            var cell = tableview.dequeueReusableCell(withIdentifier: "CCProfileUsualCell") as? CCProfileUsualCell
            if cell == nil {
                cell = CCProfileUsualCell(style: .default, reuseIdentifier: "CCProfileUsualCell")
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1
        }else {
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
                Log4G.log("QQqun")
                
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
        self.infoLabel.textColor = UIColor.white
        self.infoLabel.textAlignment = NSTextAlignment.left
        self.infoLabel.font = UIFont.systemFont(ofSize: 16)
        self.containerView.addSubview(self.infoLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.infoLabel.anchorAndFillEdge(Edge.left, xPad: 20, yPad: 0, otherSize: self.containerView.frame.size.width - 20)
    }
}

class CCProfileFaceCell : CCPTableViewCell {
    fileprivate var icon : UIImageView!
    
    fileprivate var tostaLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.icon = UIImageView(image: R.image.chengxuyuan()!.circleImage())
        self.containerView.addSubview(self.icon)
        
        self.tostaLabel = UILabel()
        self.tostaLabel.text = "这个世界上只有10种人：懂二进制的和不懂二进制的"
        self.tostaLabel.textColor = UIColor.white
        self.tostaLabel.textAlignment = .center
        self.tostaLabel.font = UIFont.systemFont(ofSize: 12)
        self.containerView.addSubview(self.tostaLabel)
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.tostaLabel.anchorAndFillEdge(.bottom, xPad: 0, yPad: 0, otherSize: 20)
        let distance = self.tostaLabel.frame.origin.y
        self.icon.align(.aboveCentered, relativeTo: self.tostaLabel, padding: 0, width: distance , height: distance)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

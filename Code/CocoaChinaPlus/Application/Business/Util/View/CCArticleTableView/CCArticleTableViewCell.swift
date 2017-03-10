//
//  CCArticleTableViewCell.swift
//  CocoaChinaPlus
//
//  Created by user on 15/10/28.
//  Copyright © 2015年 zixun. All rights reserved.
//

import Foundation
import Neon

class CCArticleTableViewCell: CCPTableViewCell {
    
    var urlString:String!
    
    //标志cell是否有图片
    var hasImage:Bool = false
    
    fileprivate var picView:UIImageView!
    
    fileprivate var picMaskView:UIView!
    
    fileprivate var titleLabel:UILabel!
    
    fileprivate var postDateLabel:UILabel!
    
    fileprivate var watchLabel:UILabel!
    
    fileprivate var bottomLine:UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.picView = UIImageView()
        self.picView.layer.cornerRadius = 4
        self.picView.clipsToBounds = true
        self.containerView.addSubview(picView)
        
        self.picMaskView = UIView()
        self.picMaskView.isHidden = true
        self.picMaskView.backgroundColor = UIColor.appGrayColor().withAlphaComponent(0.6)
        self.containerView.addSubview(self.picMaskView)
        
        self.titleLabel = UILabel()
        self.titleLabel.font = UIFont.systemFont(ofSize: 14)
        self.titleLabel.textColor = UIColor.white
        self.titleLabel.textAlignment = NSTextAlignment.left
        self.titleLabel.numberOfLines = 2
        self.titleLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        self.containerView.addSubview(titleLabel)
        
        self.postDateLabel = UILabel()
        self.postDateLabel.font = UIFont.systemFont(ofSize: 10)
        self.postDateLabel.textColor = UIColor.gray
        self.postDateLabel.textAlignment = NSTextAlignment.left
        self.containerView.addSubview(postDateLabel)
        
        self.watchLabel = UILabel()
        self.watchLabel.font = UIFont.systemFont(ofSize: 10)
        self.watchLabel.textColor = UIColor.gray
        self.containerView.addSubview(watchLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.hasImage {
            //有图片的布局
            self.picView.isHidden = false
            
            self.picView.anchorAndFillEdge(Edge.left, xPad: 4, yPad: 4, otherSizeTupling: 1.5)
            self.picMaskView.frame = self.picView.frame
            
            self.titleLabel.alignAndFillWidth(align: .toTheRightMatchingTop, relativeTo: self.picView, padding: 4, height: AutoHeight)
            self.postDateLabel.anchorInCornerWithAutoSize(Corner.bottomLeft, xPad: self.picView.xMax, yPad: 2)
            self.watchLabel.anchorInCornerWithAutoSize(Corner.bottomRight, xPad: 4, yPad: 2)
        }else {
            let xPad : CGFloat = 10.0
            let yPad : CGFloat = 4.0
            self.picView.isHidden = true
            self.titleLabel.anchorAndFillEdge(Edge.top, xPad: xPad, yPad: yPad, otherSize: AutoHeight)
            
            self.postDateLabel.anchorInCornerWithAutoSize(Corner.bottomLeft, xPad: xPad, yPad: yPad)
            self.watchLabel.anchorInCornerWithAutoSize(Corner.bottomRight, xPad: xPad, yPad: yPad)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(_ model:CCArticleModel) {

        self.configure(model, forceHighlight: false)
    }
    
    func configure(_ model:CCArticleModel, forceHighlight:Bool) {
        urlString = model.linkURL
        if model.imageURL != nil {
            self.hasImage = true
            picView.kf.setImage(with: URL(string:model.imageURL!)!)
        }else {
            self.hasImage = false
        }
        
        titleLabel.text = model.title
        postDateLabel.text = model.postTime
        watchLabel.text = model.viewed
        if forceHighlight {
            
            self.highlightCell(true)
        }else {
            if CCArticleService.isArticleExsitById(model.identity) {
                self.highlightCell(false)
            }else {
                self.highlightCell(true)
            }
        }
    }
    
    func highlightCell(_ highlight:Bool) {
        if highlight {
            self.titleLabel.textColor = UIColor.white
            self.picMaskView.isHidden = true
        }else {
            self.titleLabel.textColor = UIColor.appGrayColor()
            self.picMaskView.isHidden = false
        }
    }
    
}

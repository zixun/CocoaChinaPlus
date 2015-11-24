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
    
    private var picView:UIImageView!
    
    private var picMaskView:UIView!
    
    private var titleLabel:UILabel!
    
    private var postDateLabel:UILabel!
    
    private var watchLabel:UILabel!
    
    private var bottomLine:UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.picView = UIImageView()
        self.picView.layer.cornerRadius = 4
        self.picView.clipsToBounds = true
        self.containerView.addSubview(picView)
        
        self.picMaskView = UIView()
        self.picMaskView.hidden = true
        self.picMaskView.backgroundColor = UIColor.appGrayColor().colorWithAlphaComponent(0.6)
        self.containerView.addSubview(self.picMaskView)
        
        self.titleLabel = UILabel()
        self.titleLabel.font = UIFont.systemFontOfSize(14)
        self.titleLabel.textColor = UIColor.whiteColor()
        self.titleLabel.textAlignment = NSTextAlignment.Left
        self.titleLabel.numberOfLines = 2
        self.titleLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        self.containerView.addSubview(titleLabel)
        
        self.postDateLabel = UILabel()
        self.postDateLabel.font = UIFont.systemFontOfSize(10)
        self.postDateLabel.textColor = UIColor.grayColor()
        self.postDateLabel.textAlignment = NSTextAlignment.Left
        self.containerView.addSubview(postDateLabel)
        
        self.watchLabel = UILabel()
        self.watchLabel.font = UIFont.systemFontOfSize(10)
        self.watchLabel.textColor = UIColor.grayColor()
        self.containerView.addSubview(watchLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.hasImage {
            //有图片的布局
            self.picView.hidden = false
            
            self.picView.anchorAndFillEdge(Edge.Left, xPad: 4, yPad: 4, otherSizeTupling: 1.5)
            self.picMaskView.frame = self.picView.frame
            
            self.titleLabel.alignAndFillWidth(align: .ToTheRightMatchingTop, relativeTo: self.picView, padding: 4, height: AutoHeight)
            self.postDateLabel.anchorInCornerWithAutoSize(Corner.BottomLeft, xPad: self.picView.xMax, yPad: 2)
            self.watchLabel.anchorInCornerWithAutoSize(Corner.BottomRight, xPad: 4, yPad: 2)
        }else {
            let xPad : CGFloat = 10.0
            let yPad : CGFloat = 4.0
            self.picView.hidden = true
            self.titleLabel.anchorAndFillEdge(Edge.Top, xPad: xPad, yPad: yPad, otherSize: AutoHeight)
            
            self.postDateLabel.anchorInCornerWithAutoSize(Corner.BottomLeft, xPad: xPad, yPad: yPad)
            self.watchLabel.anchorInCornerWithAutoSize(Corner.BottomRight, xPad: xPad, yPad: yPad)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(model:CCArticleModel) {

        self.configure(model, forceHighlight: false)
    }
    
    func configure(model:CCArticleModel, forceHighlight:Bool) {
        urlString = model.linkURL
        if model.imageURL != nil {
            self.hasImage = true
            picView.kf_setImageWithURL(NSURL(string:model.imageURL!)!)
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
    
    func highlightCell(highlight:Bool) {
        if highlight {
            self.titleLabel.textColor = UIColor.whiteColor()
            self.picMaskView.hidden = true
        }else {
            self.titleLabel.textColor = UIColor.appGrayColor()
            self.picMaskView.hidden = false
        }
    }
    
}
//
//  ZXCircleView.swift
//  CocoaChinaPlus
//
//  Created by zixun on 15/8/17.
//  Copyright © 2015年 zixun. All rights reserved.
//

import UIKit
import RxSwift
import Neon

public typealias ZXCircleViewCellRef = AutoreleasingUnsafeMutablePointer<ZXCircleViewCell>

@objc public protocol ZXCircleViewDelegate : NSObjectProtocol {
    
    //CircleView中循环视图的总数
    func numberOfItemsInCircleView(circleView:ZXCircleView) -> Int
    //CircleView中循环视图的配置
    func circleView(circleView:ZXCircleView, configureCell cellRef:ZXCircleViewCellRef)
    //CircleView中循环视图点击回调
    optional func circleView(circleView:ZXCircleView, didSelectedCellAtIndex index:Int)
    
}

let TimeInterval = 4.5          //全局的时间间隔

public class ZXCircleView: UIView,UIScrollViewDelegate {
    
    public weak var circleDelegate:ZXCircleViewDelegate?
    
    private var control:ZXPageControl!
    
    private var scrollView:UIScrollView!
    
    private var cells = [ZXCircleViewCell]()
    
    private var timer: NSTimer?
    
    private var currentUIndex: Int = 0
    
    //RxSwift资源回收包
    private let disposeBag = DisposeBag()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    public convenience init() {
        self.init(frame:CGRectZero)
        self.initUI()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        self.scrollView.fillSuperview()
        self.control.anchorToEdge(.Bottom, padding: 0, width: self.frame.size.width, height: 20)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        self.scrollView = UIScrollView()
        self.scrollView.delegate = self
        self.scrollView.pagingEnabled = true
        self.scrollView.bounces = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.addSubview(self.scrollView)
        
        self.control = ZXPageControl(type: .OnFullOffEmpty)
        self.control.space = 5
        self.addSubview(control)
        
        self.addTapGestureRecognizer()
    }
    
    public func reloadData() {
        let count = self.circleDelegate?.numberOfItemsInCircleView(self)
        guard count != nil else {
            return
        }
        
        guard count > 0 else {
            return
        }
        
        
        //构建视图
        var contentSize = CGSizeMake(0, self.bounds.size.height)
        
        for var i = 0; i < count! + 2; i++ {
            let index = self.dataIndexFromUIndex(i)
            
            let size = self.bounds.size
            let point = CGPointMake(self.bounds.origin.x + size.width * CGFloat(i) , self.bounds.origin.y)
            let rect = CGRect(origin:point , size:size )
            var cell = ZXCircleViewCell(frame: rect)
            cell.index = index
            self.circleDelegate?.circleView(self, configureCell: &cell)
            self.scrollView.addSubview(cell)
            contentSize.width += rect.size.width
            self.cells.append(cell)
        }
        
        self.scrollView.contentSize = contentSize
        self.scrollView.contentOffset = CGPoint(x: self.bounds.size.width, y: 0)
        self.control.pageCount = count!
        
        //设置滚动
        self.timer?.invalidate()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(TimeInterval, target: self, selector: "timerAction", userInfo: nil, repeats: true)
        
    }
    
    func timerAction() {
        let offset = self.scrollView.contentOffset
        self.scrollView.setContentOffset(CGPointMake(offset.x + self.frame.size.width, 0), animated: true)
    }
    
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        //重置计时器
        if self.timer == nil {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(TimeInterval, target: self, selector: "timerAction", userInfo: nil, repeats: true)
        }
    }
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        guard scrollView.bounds.size.width > 0 else {
            return
        }
        
        let floatIndex = scrollView.contentOffset.x / scrollView.bounds.size.width
        
        if floatIndex - CGFloat(Int(floatIndex)) == 0 {
            self.currentUIndex = Int(floatIndex)
            let count = self.circleDelegate?.numberOfItemsInCircleView(self)
            guard count != nil && count > 0 else {
                return
            }
            
            if Int(floatIndex) == 0 {
                self.scrollView.contentOffset = self.offsetAtUIndex(count!)
                return
            }else if Int(floatIndex) == count! + 1 {
                self.scrollView.contentOffset = self.offsetAtUIndex(1)
                return
            }
            self.control.currentPage = self.dataIndexFromUIndex(Int(floatIndex))
        }
        
    }
    
    private func offsetAtUIndex(index:Int) ->CGPoint {
        let cell = self.cells[index]
        let offset_x = cell.frame.origin.x
        return CGPoint(x: offset_x, y: 0)
    }
    
    
    //dataIndex 是数据源的下标  UIndex是UI布局的下标
    private func dataIndexFromUIndex(index: Int) -> Int {
        let count = self.circleDelegate?.numberOfItemsInCircleView(self)
        
        guard count != nil && count > 0 else {
            return 0
        }
        
        var dataIndex = index - 1
        if index == 0 {
            dataIndex = count! - 1
        }else if (index == count! + 1) {
            dataIndex = 0
        }
        return dataIndex
    }
    
    private func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer()
        self.addGestureRecognizer(tap)
        tap.rx_event
            .subscribeNext { [weak self] (x) -> Void in
                
                guard let sself = self else {
                    return
                }
                
                guard let respond = sself.circleDelegate?.respondsToSelector(Selector("circleView:didSelectedCellAtIndex:")) else {
                    return
                }
                
                if respond == true {
                    sself.circleDelegate!.circleView!(sself, didSelectedCellAtIndex: sself.dataIndexFromUIndex(sself.currentUIndex))
                }
            }
            .addDisposableTo(self.disposeBag)
    }
}

public class ZXCircleViewCell: UIView,NSMutableCopying {
    public var index: Int?
    
    public var imageView: UIImageView!
    
    private var labelMaskView: UIImageView!
    
    public var titleLabel:UILabel!
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        let size = CGSizeMake(frame.size.width, 40)
        let image = UIImage.image(ZXColor(0x646464, alpha: 0.7), size: size)
        
        self.imageView = UIImageView()
        self.addSubview(self.imageView)
        
        
        self.labelMaskView = UIImageView()
        self.labelMaskView.image = image
        self.addSubview(self.labelMaskView)
        
        self.titleLabel = UILabel()
        self.titleLabel.font = UIFont.systemFontOfSize(14)
        self.titleLabel.textColor = UIColor.whiteColor()
        self.titleLabel.textAlignment = .Center
        self.titleLabel.lineBreakMode = .ByTruncatingTail
        self.addSubview(self.titleLabel)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView.fillSuperview()
        self.labelMaskView.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: 40)
        self.titleLabel.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 20, otherSize: 20)
    }
    
    //    func configure(model:CCArticleModel) {
    //        imageView.sd_setImageWithURL(NSURL(string:model.imageURL!)!
    //        )
    //
    //        titleLabel.text = model.title
    //    }
    
    public func mutableCopyWithZone(zone: NSZone) -> AnyObject {
        let cell =  ZXCircleViewCell(frame: self.frame)
        cell.imageView.image = self.imageView.image
        cell.titleLabel.text = self.titleLabel.text
        
        return cell
    }
    
}


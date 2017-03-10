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
import AppBaseKit

public typealias ZXCircleViewCellRef = AutoreleasingUnsafeMutablePointer<ZXCircleViewCell>

@objc public protocol ZXCircleViewDelegate : NSObjectProtocol {
    
    //CircleView中循环视图的总数
    func numberOfItemsInCircleView(circleView:ZXCircleView) -> Int
    //CircleView中循环视图的配置
    func circleView(circleView:ZXCircleView, configureCell cellRef:ZXCircleViewCellRef)
    //CircleView中循环视图点击回调
    @objc optional func circleView(circleView:ZXCircleView, didSelectedCellAtIndex index:Int)
    
}

let TimeInterval = 4.5          //全局的时间间隔

public class ZXCircleView: UIView,UIScrollViewDelegate {
    
    public weak var circleDelegate:ZXCircleViewDelegate?
    
    private var control:ZXPageControl!
    
    private var scrollView:UIScrollView!
    
    private var cells = [ZXCircleViewCell]()
    
    private var timer: Timer?
    
    private var currentUIndex: Int = 0
    
    //RxSwift资源回收包
    private let disposeBag = DisposeBag()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    public convenience init() {
        self.init(frame:CGRect.zero)
        self.initUI()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        self.scrollView.fillSuperview()
        self.control.anchorToEdge(.bottom, padding: 0, width: self.frame.size.width, height: 20)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        self.scrollView = UIScrollView()
        self.scrollView.delegate = self
        self.scrollView.isPagingEnabled = true
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
        
        guard let count = self.circleDelegate?.numberOfItemsInCircleView(circleView: self) else {
            return
        }
        
        guard count > 0 else {
            return
        }
        
        
        //构建视图
        var contentSize = CGSize(width:0, height:self.bounds.size.height)
        
        for i in 0 ..< count + 2 {
            let index = self.dataIndexFromUIndex(index: i)
            
            let size = self.bounds.size
            let point = CGPoint(x:self.bounds.origin.x + size.width * CGFloat(i) ,y:self.bounds.origin.y)
            let rect = CGRect(origin:point , size:size )
            var cell = ZXCircleViewCell(frame: rect)
            cell.index = index
            self.circleDelegate?.circleView(circleView: self, configureCell: &cell)
            self.scrollView.addSubview(cell)
            contentSize.width += rect.size.width
            self.cells.append(cell)
        }
        
        self.scrollView.contentSize = contentSize
        self.scrollView.contentOffset = CGPoint(x: self.bounds.size.width, y: 0)
        self.control.pageCount = count
        
        //设置滚动
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval, target: self, selector: #selector(ZXCircleView.timerAction), userInfo: nil, repeats: true)
        
    }
    
    func timerAction() {
        let offset = self.scrollView.contentOffset
        self.scrollView.setContentOffset(CGPoint(x:offset.x + self.frame.size.width,y:0), animated: true)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //重置计时器
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval, target: self, selector: #selector(ZXCircleView.timerAction), userInfo: nil, repeats: true)
        }
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.bounds.size.width > 0 else {
            return
        }
        
        let floatIndex = scrollView.contentOffset.x / scrollView.bounds.size.width
        
        if floatIndex - CGFloat(Int(floatIndex)) == 0 {
            self.currentUIndex = Int(floatIndex)
            
            guard let count = self.circleDelegate?.numberOfItemsInCircleView(circleView: self) else {
                return
            }
            
            guard count > 0 else {
                return
            }
            
            if Int(floatIndex) == 0 {
                self.scrollView.contentOffset = self.offsetAtUIndex(index: count)
                return
            }else if Int(floatIndex) == count + 1 {
                self.scrollView.contentOffset = self.offsetAtUIndex(index: 1)
                return
            }
            self.control.currentPage = self.dataIndexFromUIndex(index: Int(floatIndex))
        }
        
    }
    
    private func offsetAtUIndex(index:Int) ->CGPoint {
        let cell = self.cells[index]
        let offset_x = cell.frame.origin.x
        return CGPoint(x: offset_x, y: 0)
    }
    
    
    //dataIndex 是数据源的下标  UIndex是UI布局的下标
    private func dataIndexFromUIndex(index: Int) -> Int {
        
        guard let count = self.circleDelegate?.numberOfItemsInCircleView(circleView: self) else {
            return 0
        }
        
        guard count > 0 else {
            return 0
        }
        
        var dataIndex = index - 1
        if index == 0 {
            dataIndex = count - 1
        }else if (index == count + 1) {
            dataIndex = 0
        }
        return dataIndex
    }
    
    private func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer()
        self.addGestureRecognizer(tap)
        tap.rx.event.bindNext {  [weak self] (x:UITapGestureRecognizer) in
            guard let sself = self else {
                return
            }
            sself.circleDelegate?.circleView?(circleView: sself, didSelectedCellAtIndex: sself.currentUIndex)
        }.addDisposableTo(self.disposeBag)
    }
}

public class ZXCircleViewCell: UIView,NSMutableCopying {
    public var index: Int?
    
    public var imageView: UIImageView!
    
    private var labelMaskView: UIImageView!
    
    public var titleLabel:UILabel!
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        let size = CGSize(width:frame.size.width, height:40)
        let image = UIImage.image(color: UIColor(hex:0x646464, alpha: 0.7), size: size)
        self.imageView = UIImageView()
        self.addSubview(self.imageView)
        
        
        self.labelMaskView = UIImageView()
        self.labelMaskView.image = image
        self.addSubview(self.labelMaskView)
        
        self.titleLabel = UILabel()
        self.titleLabel.font = UIFont.systemFont(ofSize: 14)
        self.titleLabel.textColor = UIColor.white
        self.titleLabel.textAlignment = .center
        self.titleLabel.lineBreakMode = .byTruncatingTail
        self.addSubview(self.titleLabel)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView.fillSuperview()
        self.labelMaskView.anchorAndFillEdge(Edge.bottom, xPad: 0, yPad: 0, otherSize: 40)
        self.titleLabel.anchorAndFillEdge(Edge.bottom, xPad: 0, yPad: 20, otherSize: 20)
    }
    
    public func mutableCopy(with zone: NSZone? = nil) -> Any {
        let cell =  ZXCircleViewCell(frame: self.frame)
        cell.imageView.image = self.imageView.image
        cell.titleLabel.text = self.titleLabel.text
        
        return cell
    }
}


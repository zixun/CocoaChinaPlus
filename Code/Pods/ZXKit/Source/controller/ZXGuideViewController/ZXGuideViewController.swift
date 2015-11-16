//
//  ZXGuideView.swift
//  CocoaChinaPlus
//
//  Created by zixun on 15/10/3.
//  Copyright © 2015年 zixun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public protocol ZXGuideViewControllerDelegate : NSObjectProtocol {
    
    func numberOfPagesInGuideView(guideView:ZXGuideViewController) -> NSInteger

    func guideView(guideView:ZXGuideViewController, cellForPageAtIndex index:NSInteger) ->UIView

    func guideView(guideView:ZXGuideViewController, imageAtIndex index:NSInteger) ->UIImageView

    func guideView(guideView:ZXGuideViewController, labelAtIndex index:NSInteger) ->UILabel

    func didClickEnterButtonInGuideView(guideView:ZXGuideViewController)
}

public class ZXGuideViewController: UIViewController {

    public weak var delegate: ZXGuideViewControllerDelegate?
    
    private var scrollView : UIScrollView!
    private var pageControl : UIPageControl!
    private var enterButton : UIButton!
    
    private var imageViews = [UIImageView]()
    private var labels = [UILabel]()
    
    private var centerOfImages = [CGPoint]()
    private var centerOfLabels = [CGPoint]()
    
    private var countOfPages:NSInteger = 0
    
    private var disposeBag = DisposeBag()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .OverCurrentContext
        self.modalTransitionStyle = .CrossDissolve
        
        self.countOfPages = self.numberOfPages()
        
        self.scrollView = UIScrollView()
        self.scrollView.contentSize = CGSizeMake(CGFloat(self.countOfPages) * ZXScreenWidth(), ZXScreenHight())
        self.scrollView.pagingEnabled = true
        self.scrollView.bounces = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.backgroundColor = UIColor.clearColor()
        self.scrollView.delegate = self
        self.view.addSubview(self.scrollView)
        
        
        self.pageControl = UIPageControl()
        self.pageControl.numberOfPages = self.countOfPages
        self.pageControl.currentPage = 0
        self.view.addSubview(self.pageControl)
        
        for var i = 0; i < self.countOfPages; i++ {
            //添加view
            let view = self.cellForPageAtIndex(i)
            var rect = view.frame
            rect.origin.x = CGFloat(i) * ZXScreenWidth()
            rect.origin.y = 0
            view.frame = rect
            self.scrollView.addSubview(view)
            
            //添加image
            let imageView = self.imageAtIndex(i)
            if i == 0 {
                imageView.hidden = false
            }else {
                imageView.hidden = true
            }
            self.view.addSubview(imageView)
            self.imageViews.append(imageView)
            self.centerOfImages.append(imageView.center)
            //添加labels
            let label = self.labelAtIndex(i)
            if i == 0 {
                label.hidden = false
            }else {
                label.hidden = true
            }
            self.view.addSubview(label)
            self.labels.append(label)
            self.centerOfLabels.append(label.center)
        }
        
        //设置“进入首页”的按钮
        self.enterButton = UIButton(type: .RoundedRect)
        self.enterButton.setTitle("立即体验", forState: .Normal)
        self.enterButton.setTitleColor(ZXColor(0xFFB6C1), forState: .Normal)
        self.enterButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 20)
        self.enterButton.layer.cornerRadius = 10
        self.enterButton.layer.borderWidth = 2
        self.enterButton.layer.borderColor = ZXColor(0xFFB6C1).CGColor
        self.enterButton.hidden = true
        self.view.addSubview(self.enterButton)
        
        self.enterButton
            .rx_tap
            .subscribeNext { [weak self]() -> Void in
                guard let sself = self else {
                    return
                }
                sself.dismissViewControllerAnimated(true, completion: nil)
                sself.didClickEnterButton()
            }.addDisposableTo(self.disposeBag)
        
        self.pageControl
            .rx_controlEvents(.ValueChanged)
            .subscribeNext {[weak self] () -> Void in
                
                guard let sself = self else {
                    return
                }
                
                let point = CGPointMake(CGFloat(sself.pageControl.currentPage) * ZXScreenWidth(), 0)
                sself.scrollView.setContentOffset(point, animated: true)
            }
            .addDisposableTo(self.disposeBag)
        
    }
    
    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.scrollView.fillSuperview()
        self.pageControl.anchorToEdge(.Bottom, padding: 15, width: 100, height: 35)
        self.enterButton.anchorToEdge(.Bottom, padding: 40, width: 180, height: 40)
    }
}

extension ZXGuideViewController : UIScrollViewDelegate {
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        self.enterButton.hidden = true
        
        let pageWidth = scrollView.frame.size.width
        let page = NSInteger(floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)) + 1
        
        self.pageControl.currentPage = page
        let index = NSInteger(fabs(scrollView.contentOffset.x) / scrollView.frame.size.width)
        
        if(self.scrollView.contentOffset.x > 0) {
            self.moveImageAndLabelAtIndex(index)
        }
    }
    
    private func ratePoint(p1:CGPoint,p2:CGPoint,rate:CGFloat) ->CGPoint {
        let x = (p2.x - p1.x) * rate + p1.x
        let y = (p2.y - p1.y) * rate + p1.y
        return CGPointMake(x, y)
    }
    
    private func moveImageAndLabelAtIndex(index:NSInteger) {
        
        let scrollRate = (self.scrollView.contentOffset.x / ZXScreenWidth()) - floor(self.scrollView.contentOffset.x / ZXScreenWidth())
        if(index != self.countOfPages - 1) {
            
            
            var p1 = self.centerOfImages[index]
            var p2 = self.centerOfImages[index + 1]
            let p_image = self.ratePoint(p1, p2: p2, rate: scrollRate)
            
            for image:UIImageView in self.imageViews {
                image.hidden = true
                
                image.center = p_image
                let currentImage: UIImageView = self.imageViews[index]
                if(scrollRate <= 0.8){
                    currentImage.hidden = false
                    currentImage.layer.opacity = Float(1.0 - scrollRate/0.8)
                }else{
                    let nextImage: UIImageView = self.imageViews[index + 1]
                    nextImage.hidden = false
                    nextImage.layer.opacity = Float(scrollRate - 0.8) / 0.2
                }
                
            }
            
            p1 = self.centerOfLabels[index]
            p2 = self.centerOfLabels[index + 1]
            let p_label = self.ratePoint(p1, p2: p2, rate: scrollRate)
            
            for label:UILabel in self.labels {
                label.hidden = true
                label.center = p_label
                
                let currentLabel = self.labels[index]
                
                if(scrollRate <= 0.8) {
                    currentLabel.hidden = false
                    currentLabel.layer.opacity = Float(1.0-scrollRate/0.8)
                }else {
                    let nextLabel = self.labels[index + 1]
                    nextLabel.hidden = false
                    nextLabel.layer.opacity = Float(scrollRate-0.8)/0.2
                }
            }
        }else{
            
            let lastImage: UIImageView = self.imageViews[index]
            let p = self.centerOfImages[index]
            lastImage.center = p

            let lastLabel = self.labels[index]
            lastLabel.center = self.centerOfLabels[index]
        }
        
        if ((index == self.countOfPages - 2 && (scrollRate>0.9)) || (index==self.countOfPages-1)) {
            self.enterButton.hidden = false
        }
        
    }
    
}

//MAKR: - Delegate Accesser
extension ZXGuideViewController {
    
    private func numberOfPages() -> NSInteger {
        guard self.delegate != nil else {
            return 0
        }
        
        guard self.delegate!.respondsToSelector("numberOfPagesInGuideView:") else {
            return 0
        }
        
        return self.delegate!.numberOfPagesInGuideView(self)
    }
    
    private func cellForPageAtIndex(index:NSInteger) ->UIView {
        guard self.delegate != nil else {
            return UIView()
        }
        
        guard self.delegate!.respondsToSelector("guideView:cellForPageAtIndex:") else {
            return UIView()
        }
        
        return self.delegate!.guideView(self, cellForPageAtIndex: index)
    }
    
    private func imageAtIndex(index:NSInteger) ->UIImageView {
        guard self.delegate != nil else {
            return UIImageView()
        }
        
        guard self.delegate!.respondsToSelector("guideView:imageAtIndex:") else {
            return UIImageView()
        }
        return self.delegate!.guideView(self, imageAtIndex: index)
    }
    
    private func labelAtIndex(index:NSInteger) ->UILabel {
        guard self.delegate != nil else {
            return UILabel()
        }
        
        guard self.delegate!.respondsToSelector("guideView:labelAtIndex:") else {
            return UILabel()
        }
        
        return self.delegate!.guideView(self, labelAtIndex: index)
    }
    
    private func didClickEnterButton() {
        guard self.delegate != nil else {
            return
        }
        
        guard self.delegate!.respondsToSelector("didClickEnterButtonInGuideView:") else {
            return
        }
        
        self.delegate!.didClickEnterButtonInGuideView(self)
    }
}
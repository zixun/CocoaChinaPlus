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
    
    var scrollView : UIScrollView!
    fileprivate var pageControl : UIPageControl!
    fileprivate var enterButton : UIButton!
    
    fileprivate var imageViews = [UIImageView]()
    fileprivate var labels = [UILabel]()
    
    fileprivate var centerOfImages = [CGPoint]()
    fileprivate var centerOfLabels = [CGPoint]()
    
    fileprivate var countOfPages:NSInteger = 0
    
    private var disposeBag = DisposeBag()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
        
        self.countOfPages = self.numberOfPages()
        
        self.scrollView = UIScrollView()
        self.scrollView.contentSize = CGSize(width:CGFloat(self.countOfPages) * ZXScreenWidth(),height:ZXScreenHeight())
        self.scrollView.isPagingEnabled = true
        self.scrollView.bounces = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.backgroundColor = UIColor.clear
        self.scrollView.delegate = self
        self.view.addSubview(self.scrollView)
        
        
        self.pageControl = UIPageControl()
        self.pageControl.numberOfPages = self.countOfPages
        self.pageControl.currentPage = 0
        self.view.addSubview(self.pageControl)
        
        for i in 0 ..< self.countOfPages {
            //添加view
            let view = self.cellForPageAtIndex(index: i)
            var rect = view.frame
            rect.origin.x = CGFloat(i) * ZXScreenWidth()
            rect.origin.y = 0
            view.frame = rect
            self.scrollView.addSubview(view)
            
            //添加image
            let imageView = self.imageAtIndex(index: i)
            if i == 0 {
                imageView.isHidden = false
            }else {
                imageView.isHidden = true
            }
            self.view.addSubview(imageView)
            self.imageViews.append(imageView)
            self.centerOfImages.append(imageView.center)
            //添加labels
            let label = self.labelAtIndex(index: i)
            if i == 0 {
                label.isHidden = false
            }else {
                label.isHidden = true
            }
            self.view.addSubview(label)
            self.labels.append(label)
            self.centerOfLabels.append(label.center)
        }
        
        //设置“进入首页”的按钮
        self.enterButton = UIButton(type: .roundedRect)
        self.enterButton.setTitle("立即体验", for: .normal)
        self.enterButton.setTitleColor(UIColor(hex:0xFFB6C1), for: .normal)
        self.enterButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 20)
        self.enterButton.layer.cornerRadius = 10
        self.enterButton.layer.borderWidth = 2
        self.enterButton.layer.borderColor = UIColor(hex:0xFFB6C1).cgColor
        self.enterButton.isHidden = true
        self.view.addSubview(self.enterButton)
        
        self.enterButton.rx.tap.bindNext { [unowned self] _ in
            
            self.dismiss(animated: true, completion: nil)
            self.didClickEnterButton()
            }.addDisposableTo(self.disposeBag)
        
        self.pageControl.rx.controlEvent(UIControlEvents.valueChanged).bindNext { [weak self] _ in
            guard let sself = self else {
                return
            }
            
            let point = CGPoint(x:CGFloat(sself.pageControl.currentPage) * ZXScreenWidth(),y:0)
            sself.scrollView.setContentOffset(point, animated: true)
        }.addDisposableTo(self.disposeBag)
    }
    
    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.scrollView.fillSuperview()
        self.pageControl.anchorToEdge(.bottom, padding: 15, width: 100, height: 35)
        self.enterButton.anchorToEdge(.bottom, padding: 40, width: 180, height: 40)
    }
}

extension ZXGuideViewController : UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.enterButton.isHidden = true
        
        let pageWidth = scrollView.frame.size.width
        let page = NSInteger(floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)) + 1
        
        self.pageControl.currentPage = page
        let index = NSInteger(fabs(scrollView.contentOffset.x) / scrollView.frame.size.width)
        
        if(self.scrollView.contentOffset.x > 0) {
            self.moveImageAndLabelAtIndex(index: index)
        }
    }
    
    private func ratePoint(p1:CGPoint,p2:CGPoint,rate:CGFloat) ->CGPoint {
        let x = (p2.x - p1.x) * rate + p1.x
        let y = (p2.y - p1.y) * rate + p1.y
        return CGPoint(x:x, y:y)
    }
    
    private func moveImageAndLabelAtIndex(index:NSInteger) {
        
        let scrollRate = (self.scrollView.contentOffset.x / ZXScreenWidth()) - floor(self.scrollView.contentOffset.x / ZXScreenWidth())
        if(index != self.countOfPages - 1) {
            
            
            var p1 = self.centerOfImages[index]
            var p2 = self.centerOfImages[index + 1]
            let p_image = self.ratePoint(p1: p1, p2: p2, rate: scrollRate)
            
            for image:UIImageView in self.imageViews {
                image.isHidden = true
                
                image.center = p_image
                let currentImage: UIImageView = self.imageViews[index]
                if(scrollRate <= 0.8){
                    currentImage.isHidden = false
                    currentImage.layer.opacity = Float(1.0 - scrollRate/0.8)
                }else{
                    let nextImage: UIImageView = self.imageViews[index + 1]
                    nextImage.isHidden = false
                    nextImage.layer.opacity = Float(scrollRate - 0.8) / 0.2
                }
                
            }
            
            p1 = self.centerOfLabels[index]
            p2 = self.centerOfLabels[index + 1]
            let p_label = self.ratePoint(p1: p1, p2: p2, rate: scrollRate)
            
            for label:UILabel in self.labels {
                label.isHidden = true
                label.center = p_label
                
                let currentLabel = self.labels[index]
                
                if(scrollRate <= 0.8) {
                    currentLabel.isHidden = false
                    currentLabel.layer.opacity = Float(1.0-scrollRate/0.8)
                }else {
                    let nextLabel = self.labels[index + 1]
                    nextLabel.isHidden = false
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
            self.enterButton.isHidden = false
        }
        
    }
    
}

//MAKR: - Delegate Accesser
extension ZXGuideViewController {
    
    fileprivate func numberOfPages() -> NSInteger {
        return self.delegate?.numberOfPagesInGuideView(guideView: self) ?? 0
    }
    
    fileprivate func cellForPageAtIndex(index:NSInteger) ->UIView {
        return self.delegate?.guideView(guideView: self, cellForPageAtIndex: index) ?? UIView()
    }
    
    fileprivate func imageAtIndex(index:NSInteger) ->UIImageView {
        return self.delegate?.guideView(guideView: self, imageAtIndex: index) ?? UIImageView()
    }
    
    fileprivate func labelAtIndex(index:NSInteger) ->UILabel {
        return self.delegate?.guideView(guideView: self, labelAtIndex: index) ?? UILabel()
    }
    
    fileprivate func didClickEnterButton() {
        self.delegate?.didClickEnterButtonInGuideView(guideView: self)
    }
}

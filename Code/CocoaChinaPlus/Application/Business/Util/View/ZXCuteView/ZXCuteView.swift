//
//  ZXCuteView.swift
//  CocoaChinaPlus
//
//  Created by 子循 on 15/8/7.
//  Copyright © 2015年 zixun. All rights reserved.
//

import UIKit
import RxSwift
import AppBaseKit

public class ZXCuteView: UIView {
    
    // 父视图
    public var containerView:UIView?
    
    // 气泡上显示数字的label
    public var bubbleImage:UIImageView?
    
    //气泡的直径
    public var bubbleWidth:CGFloat = 0.0
    
    //气泡粘性系数，越大可以拉得越长
    public var viscosity:CGFloat = 20.0
    
    //气泡颜色
    public var bubbleColor:UIColor = UIColor(hex:0x00B9FF) {
        
        didSet {
            self.frontView?.backgroundColor = self.bubbleColor
            self.backView?.backgroundColor = self.bubbleColor
        }
    }
    
    //需要隐藏气泡时候可以使用这个属性：self.frontView.hidden = YES;
    public var frontView:UIView?//用户拖走的View
    
    public var backView:UIView?//原地保留显示的View
    
    public var tapCallBack:(()->Void)?
    
    private var disposeBag = DisposeBag()
    
    private var initialPoint:CGPoint!
    private var shapeLayer:CAShapeLayer!
    
    private var r1:CGFloat = 0.0 //backView的半径
    private var r2:CGFloat = 0.0 //frontView的半径
    
    private var x1:CGFloat = 0.0 //backView圆心x
    private var y1:CGFloat = 0.0 //backView圆心y
    
    private var x2:CGFloat = 0.0 //frontView圆心x
    private var y2:CGFloat = 0.0 //frontView圆心y
    
    private var centerDistance:CGFloat = 0.0
    private var cosDigree:CGFloat = 0.0
    private var sinDigree:CGFloat = 0.0
    
    
    private var pointA:CGPoint = CGPoint.zero //A
    private var pointB:CGPoint = CGPoint.zero //B
    private var pointD:CGPoint = CGPoint.zero //D
    private var pointC:CGPoint = CGPoint.zero //C
    private var pointO:CGPoint = CGPoint.zero //O
    private var pointP:CGPoint = CGPoint.zero //P
    
    private var oldBackViewFrame:CGRect = CGRect.zero
    private var oldBackViewCenter:CGPoint = CGPoint.zero
    
    private var fillColorForCute:UIColor?
    
    private var cutePath:UIBezierPath!
    
    public convenience init(point:CGPoint,superView:UIView,bubbleWidth:CGFloat) {
        self.init(frame:CGRect(x:point.x, y:point.y, width:bubbleWidth,height:bubbleWidth))
        self.bubbleWidth = frame.size.width
        self.initialPoint = point
        self.containerView = superView
        self.containerView!.addSubview(self)
        self.setup()
        
    }
    
    deinit {
        self.removeFromSuperview()
        self.frontView?.removeFromSuperview()
        self.backView?.removeFromSuperview()
        self.shapeLayer.removeFromSuperlayer()
    }
    
    func setup() {
        self.shapeLayer = CAShapeLayer()
        self.backgroundColor = UIColor.clear
        
        self.frontView = UIView(frame: CGRect(x:initialPoint.x,y:initialPoint.y, width:self.bubbleWidth,height: self.bubbleWidth))
        //计算frontView半径
        r2 = self.frontView!.bounds.size.width / 2.0
        self.frontView!.layer.cornerRadius = r2
        self.frontView!.backgroundColor = self.bubbleColor
        
        self.backView = UIView(frame: self.frontView!.frame)
        r1 = self.backView!.frame.size.width / 2.0
        self.backView!.layer.cornerRadius = r1
        self.backView!.backgroundColor = self.bubbleColor
        
        
        self.bubbleImage = UIImageView()
        self.bubbleImage!.frame = CGRect(x:0, y:0, width:self.frontView!.bounds.size.width, height:self.frontView!.bounds.size.height)
        self.bubbleImage!.image = UIImage(named: "top")
        
        self.frontView!.insertSubview(self.bubbleImage!, at: 0)
        
        self.containerView!.addSubview(backView!)
        self.containerView!.addSubview(self.frontView!)
        
        x1 = self.backView!.center.x;
        y1 = self.backView!.center.y;
        x2 = self.frontView!.center.x;
        y2 = self.frontView!.center.y;
        
        self.pointA = CGPoint(x:x1-r1,y:y1);   // A
        self.pointB = CGPoint(x:x1+r1,y:y1);  // B
        self.pointD = CGPoint(x:x2-r2,y:y2);  // D
        self.pointC = CGPoint(x:x2+r2,y:y2);  // C
        self.pointO = CGPoint(x:x1-r1,y:y1);   // O
        self.pointP = CGPoint(x:x2+r2,y:y2);  // P
        
        self.oldBackViewFrame = self.backView!.frame
        self.oldBackViewCenter = self.backView!.center
        
        self.backView!.isHidden = true //为了看到frontView的气泡晃动效果，需要展示隐藏backView
        self.addAniamtionLikeGameCenterBubble()
        
        let pan = UIPanGestureRecognizer()
        self.frontView!.addGestureRecognizer(pan)
        
        pan.rx.event.bindNext { [unowned self] (ges:UIPanGestureRecognizer) in
            self.dragMe(ges:ges)
        }.addDisposableTo(self.disposeBag)
        
       
        
        let tap = UITapGestureRecognizer()
        self.frontView!.addGestureRecognizer(tap)
        
        tap.rx.event.bindNext { (ges:UITapGestureRecognizer) in
             self.tapMe(tap: ges)
        }.addDisposableTo(self.disposeBag)
    }
    
    func tapMe(tap:UITapGestureRecognizer) {
        guard self.tapCallBack != nil else {
            return
        }
        self.tapCallBack!()
        
    }
    
    func dragMe(ges:UIPanGestureRecognizer) {
        let dragPoint = ges.location(in: self.containerView)
        
        if ges.state == .began {
            self.backView?.isHidden = false
            self.fillColorForCute = self.bubbleColor
            self.removeAniamtionLikeGameCenterBubble()
        }else if(ges.state == .changed) {
            self.frontView?.center = dragPoint
            if r1 <= 6 {
                self.fillColorForCute = UIColor.clear
                self.backView?.isHidden = true
                self.shapeLayer.removeFromSuperlayer()
            }
        }else if (ges.state == .ended || ges.state == .cancelled || ges.state == .failed) {
            self.backView?.isHidden = true
            self.fillColorForCute = UIColor.clear
            self.shapeLayer.removeFromSuperlayer()
            
            
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: { () -> Void in
                 self.frontView?.center = self.oldBackViewCenter
                
                }, completion: { (finished) -> Void in
                    if finished == true {
                        
                        self.addAniamtionLikeGameCenterBubble()
                    }
            })
            
        }
        self.displayLinkAction()
    }
    
    
    private func displayLinkAction() {
        x1 = self.backView!.center.x
        y1 = self.backView!.center.y
        x2 = self.frontView!.center.x
        y2 = self.frontView!.center.y
        
        self.centerDistance = CGFloat(sqrtf( Float( (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) ) ))
        
        if centerDistance == 0 {
            self.cosDigree = 1.0
            self.sinDigree = 0
            
        }else {
            self.cosDigree = (y2-y1)/centerDistance;
            self.sinDigree = (x2-x1)/centerDistance;
        }
        
        r1 = self.oldBackViewFrame.size.width / 2 - centerDistance/self.viscosity
        
        pointA = CGPoint(x:x1-r1*cosDigree, y:y1+r1*sinDigree);  // A
        pointB = CGPoint(x:x1+r1*cosDigree, y:y1-r1*sinDigree); // B
        pointD = CGPoint(x:x2-r2*cosDigree, y:y2+r2*sinDigree); // D
        pointC = CGPoint(x:x2+r2*cosDigree, y:y2-r2*sinDigree);// C
        pointO = CGPoint(x:pointA.x + (centerDistance / 2)*sinDigree, y:pointA.y + (centerDistance / 2)*cosDigree);
        pointP = CGPoint(x:pointB.x + (centerDistance / 2)*sinDigree, y:pointB.y + (centerDistance / 2)*cosDigree);
        
        self.drawRect()
    }

    func drawRect() {
        self.backView!.center = oldBackViewCenter;
        self.backView!.bounds = CGRect(x:0, y:0, width:r1*2, height:r1*2);
        self.backView!.layer.cornerRadius = r1;
        
        self.cutePath = UIBezierPath()
        self.cutePath.move(to: pointA)
        self.cutePath.addQuadCurve(to: pointD, controlPoint: pointO)
        self.cutePath.addLine(to: pointC)
        self.cutePath.addQuadCurve(to: pointB, controlPoint: pointP)
        self.cutePath.move(to: pointA)
        
        if (self.backView!.isHidden == false) {
            self.shapeLayer.path = cutePath.cgPath
            self.shapeLayer.fillColor = fillColorForCute?.cgColor
            self.containerView?.layer.insertSublayer(shapeLayer, below: self.frontView?.layer)
        }
    }
    
    public func addAniamtionLikeGameCenterBubble() {
        self.addPositionAnimation()
        self.addScaleAnimation()
    }
    
    public func removeAniamtionLikeGameCenterBubble() {
        self.removePositionAnimation()
        self.removeScaleAnimation()
    }
   
    private func addPositionAnimation() {
        let pathAnimation:CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "position")
        pathAnimation.calculationMode = kCAAnimationPaced
        pathAnimation.fillMode = kCAFillModeForwards
        pathAnimation.isRemovedOnCompletion = false
        pathAnimation.repeatCount = Float.infinity
        pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        pathAnimation.duration = 5.0;
        
        let curvedPath:CGMutablePath = CGMutablePath()
        let circleContainer:CGRect = self.frontView!.frame.insetBy(dx: self.frontView!.bounds.size.width / 2 - 3, dy: self.frontView!.bounds.size.width / 2 - 3)
        curvedPath.addEllipse(in: circleContainer)
        pathAnimation.path = curvedPath
        //        CGPathRelease(curvedPath)   http://stackoverflow.com/questions/24900595/swift-cgpathrelease-and-arc
        self.frontView!.layer.add(pathAnimation, forKey: "myCircleAnimation")
    }
    
    private func addScaleAnimation() {
        let scaleX:CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform.scale.x")
        scaleX.duration = 1
        scaleX.values = [1.0, 1.1, 1.0];
        scaleX.keyTimes = [0.0, 0.5, 1.0];
        scaleX.repeatCount = Float.infinity;
        scaleX.autoreverses = true;
        scaleX.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.frontView!.layer.add(scaleX, forKey: "scaleXAnimation")
        
        
        let scaleY:CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform.scale.y")
        scaleY.duration = 1.5;
        scaleY.values = [1.0, 1.1, 1.0];
        scaleY.keyTimes = [0.0, 0.5, 1.0];
        scaleY.repeatCount = Float.infinity;
        scaleY.autoreverses = true;
        scaleX.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.frontView!.layer.add(scaleY, forKey: "scaleYAnimation")
    }
    
    private func removeScaleAnimation() {
        self.frontView?.layer.removeAnimation(forKey: "scaleXAnimation")
        self.frontView?.layer.removeAnimation(forKey: "scaleYAnimation")
    }
    
    private func removePositionAnimation() {
        self.frontView?.layer.removeAnimation(forKey: "myCircleAnimation")
    }
}

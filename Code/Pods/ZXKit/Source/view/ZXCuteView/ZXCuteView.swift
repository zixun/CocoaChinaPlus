//
//  ZXCuteView.swift
//  CocoaChinaPlus
//
//  Created by 子循 on 15/8/7.
//  Copyright © 2015年 zixun. All rights reserved.
//

import UIKit
import RxSwift

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
    public var bubbleColor:UIColor = ZXColor(0x00B9FF) {
        
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
    
    
    private var pointA:CGPoint = CGPointZero //A
    private var pointB:CGPoint = CGPointZero //B
    private var pointD:CGPoint = CGPointZero //D
    private var pointC:CGPoint = CGPointZero //C
    private var pointO:CGPoint = CGPointZero //O
    private var pointP:CGPoint = CGPointZero //P
    
    private var oldBackViewFrame:CGRect = CGRectZero
    private var oldBackViewCenter:CGPoint = CGPointZero
    
    private var fillColorForCute:UIColor?
    
    private var cutePath:UIBezierPath!
    
    public convenience init(point:CGPoint,superView:UIView,bubbleWidth:CGFloat) {
        self.init(frame:CGRectMake(point.x, point.y, bubbleWidth,bubbleWidth))
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
        self.backgroundColor = UIColor.clearColor()
        
        self.frontView = UIView(frame: CGRectMake(initialPoint.x,initialPoint.y, self.bubbleWidth, self.bubbleWidth))
        //计算frontView半径
        r2 = self.frontView!.bounds.size.width / 2.0
        self.frontView!.layer.cornerRadius = r2
        self.frontView!.backgroundColor = self.bubbleColor
        
        self.backView = UIView(frame: self.frontView!.frame)
        r1 = self.backView!.frame.size.width / 2.0
        self.backView!.layer.cornerRadius = r1
        self.backView!.backgroundColor = self.bubbleColor
        
        
        self.bubbleImage = UIImageView()
        self.bubbleImage!.frame = CGRectMake(0, 0, self.frontView!.bounds.size.width, self.frontView!.bounds.size.height)
        self.bubbleImage!.image = UIImage(named: "top")
        
        self.frontView!.insertSubview(self.bubbleImage!, atIndex: 0)
        
        self.containerView!.addSubview(backView!)
        self.containerView!.addSubview(self.frontView!)
        
        x1 = self.backView!.center.x;
        y1 = self.backView!.center.y;
        x2 = self.frontView!.center.x;
        y2 = self.frontView!.center.y;
        
        self.pointA = CGPointMake(x1-r1,y1);   // A
        self.pointB = CGPointMake(x1+r1, y1);  // B
        self.pointD = CGPointMake(x2-r2, y2);  // D
        self.pointC = CGPointMake(x2+r2, y2);  // C
        self.pointO = CGPointMake(x1-r1,y1);   // O
        self.pointP = CGPointMake(x2+r2, y2);  // P
        
        self.oldBackViewFrame = self.backView!.frame
        self.oldBackViewCenter = self.backView!.center
        
        self.backView!.hidden = true //为了看到frontView的气泡晃动效果，需要展示隐藏backView
        self.addAniamtionLikeGameCenterBubble()
        
        let pan = UIPanGestureRecognizer()
        self.frontView!.addGestureRecognizer(pan)
        pan.rx_event
            .subscribeNext { (ges) -> Void in
                self.dragMe(ges as! UIPanGestureRecognizer)
            }
            .addDisposableTo(self.disposeBag)
        
        let tap = UITapGestureRecognizer()
        self.frontView!.addGestureRecognizer(tap)
        tap.rx_event
            .subscribeNext { (ges) -> Void in
                self.tapMe(ges as! UITapGestureRecognizer)
            }
            .addDisposableTo(self.disposeBag)
    }
    
    func tapMe(tap:UITapGestureRecognizer) {
        guard self.tapCallBack != nil else {
            return
        }
        self.tapCallBack!()
        
    }
    
    func dragMe(ges:UIPanGestureRecognizer) {
        let dragPoint = ges.locationInView(self.containerView)
        
        if ges.state == .Began {
            self.backView?.hidden = false
            self.fillColorForCute = self.bubbleColor
            self.removeAniamtionLikeGameCenterBubble()
        }else if(ges.state == .Changed) {
            self.frontView?.center = dragPoint
            if r1 <= 6 {
                self.fillColorForCute = UIColor.clearColor()
                self.backView?.hidden = true
                self.shapeLayer.removeFromSuperlayer()
            }
        }else if (ges.state == .Ended || ges.state == .Cancelled || ges.state == .Failed) {
            self.backView?.hidden = true
            self.fillColorForCute = UIColor.clearColor()
            self.shapeLayer.removeFromSuperlayer()
            
            
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
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
        
        pointA = CGPointMake(x1-r1*cosDigree, y1+r1*sinDigree);  // A
        pointB = CGPointMake(x1+r1*cosDigree, y1-r1*sinDigree); // B
        pointD = CGPointMake(x2-r2*cosDigree, y2+r2*sinDigree); // D
        pointC = CGPointMake(x2+r2*cosDigree, y2-r2*sinDigree);// C
        pointO = CGPointMake(pointA.x + (centerDistance / 2)*sinDigree, pointA.y + (centerDistance / 2)*cosDigree);
        pointP = CGPointMake(pointB.x + (centerDistance / 2)*sinDigree, pointB.y + (centerDistance / 2)*cosDigree);
        
        self.drawRect()
    }

    func drawRect() {
        self.backView!.center = oldBackViewCenter;
        self.backView!.bounds = CGRectMake(0, 0, r1*2, r1*2);
        self.backView!.layer.cornerRadius = r1;
        
        self.cutePath = UIBezierPath()
        self.cutePath.moveToPoint(pointA)
        self.cutePath.addQuadCurveToPoint(pointD, controlPoint: pointO)
        self.cutePath.addLineToPoint(pointC)
        self.cutePath.addQuadCurveToPoint(pointB, controlPoint: pointP)
        self.cutePath.moveToPoint(pointA)
        
        if (self.backView!.hidden == false) {
            self.shapeLayer.path = cutePath.CGPath
            self.shapeLayer.fillColor = fillColorForCute?.CGColor
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
        pathAnimation.removedOnCompletion = false
        pathAnimation.repeatCount = Float.infinity
        pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        pathAnimation.duration = 5.0;
        
        let curvedPath:CGMutablePathRef = CGPathCreateMutable()
        let circleContainer:CGRect = CGRectInset(self.frontView!.frame, self.frontView!.bounds.size.width / 2 - 3, self.frontView!.bounds.size.width / 2 - 3)
        CGPathAddEllipseInRect(curvedPath, nil, circleContainer)
        pathAnimation.path = curvedPath
        //        CGPathRelease(curvedPath)   http://stackoverflow.com/questions/24900595/swift-cgpathrelease-and-arc
        self.frontView!.layer.addAnimation(pathAnimation, forKey: "myCircleAnimation")
    }
    
    private func addScaleAnimation() {
        let scaleX:CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform.scale.x")
        scaleX.duration = 1
        scaleX.values = [1.0, 1.1, 1.0];
        scaleX.keyTimes = [0.0, 0.5, 1.0];
        scaleX.repeatCount = Float.infinity;
        scaleX.autoreverses = true;
        scaleX.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.frontView!.layer.addAnimation(scaleX, forKey: "scaleXAnimation")
        
        
        let scaleY:CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform.scale.y")
        scaleY.duration = 1.5;
        scaleY.values = [1.0, 1.1, 1.0];
        scaleY.keyTimes = [0.0, 0.5, 1.0];
        scaleY.repeatCount = Float.infinity;
        scaleY.autoreverses = true;
        scaleX.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.frontView!.layer.addAnimation(scaleY, forKey: "scaleYAnimation")
    }
    
    private func removeScaleAnimation() {
        self.frontView?.layer.removeAnimationForKey("scaleXAnimation")
        self.frontView?.layer.removeAnimationForKey("scaleYAnimation")
    }
    
    private func removePositionAnimation() {
        self.frontView?.layer.removeAnimationForKey("myCircleAnimation")
    }
}

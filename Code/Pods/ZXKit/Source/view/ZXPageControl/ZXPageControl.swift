//
//  ZXControl.swift
//  CocoaChinaPlus
//
//  Created by 子循 on 15/7/30.
//  Copyright © 2015年 zixun. All rights reserved.
//

import UIKit

public enum ZXPageControlType:Int {
    case OnFullOffFull   = 0
    case OnFullOffEmpty  = 1
    case OnEmptyOffFull  = 2
    case OnEmptyOffEmpty = 3
}



public class ZXPageControl: UIControl {

    public var pageCount:Int = 0
    public var space:CGFloat = 12
    
    public var currentPage:Int = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    private var type:ZXPageControlType!
    private var diameter:CGFloat!
    private var onColor:UIColor!
    private var offColor:UIColor!
    
    private var onImage:UIImage!
    private var offImage:UIImage!
    
    private var imageViews = [UIImageView]()
    
    public init(type:ZXPageControlType,
        diameter:CGFloat = 8.0,
        onColor:UIColor = UIColor(white: 1.0, alpha: 0.5),
        offColor:UIColor = UIColor(white: 1.0, alpha: 0.2)
        ) {
        super.init(frame: CGRectZero)
        self.type = type
        self.diameter = diameter
        self.onColor = onColor
        self.offColor = offColor
        self.backgroundColor = UIColor.clearColor()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        CGContextSetAllowsAntialiasing(context, true);
        CGContextClearRect(context, rect)
        
        let dotsWith = CGFloat(self.pageCount)*diameter + CGFloat(max(0, self.pageCount - 1)) * space
        var x = CGRectGetMidX(self.bounds) - dotsWith / 2
        let y = CGRectGetMidY(self.bounds) - diameter / 2
        
        let lineWidth:CGFloat = 1.0
        CGContextSetLineWidth(context, lineWidth)
        
        for var i = 0; i < self.pageCount; i++ {
            let dotRect = CGRectMake(x, y, diameter, diameter)
            if i == currentPage {
                if self.type == ZXPageControlType.OnFullOffEmpty || self.type == ZXPageControlType.OnFullOffFull {
                    CGContextSetFillColorWithColor(context, self.onColor.CGColor)
                    CGContextFillEllipseInRect(context, CGRectInset(dotRect, -0.5, -0.5))
                }else {
                    CGContextSetStrokeColorWithColor(context, self.onColor.CGColor)
                    CGContextStrokeEllipseInRect(context, dotRect)
                    CGContextSetFillColorWithColor(context, self.onColor.CGColor)
                    CGContextAddArc(context, CGRectGetMidX(dotRect), CGRectGetMidY(dotRect), diameter / 2 - lineWidth, 0.0, CGFloat(2.0 * M_PI), 0)
                    CGContextFillPath(context);
                }
            }else {
                if self.type == ZXPageControlType.OnEmptyOffEmpty || self.type == ZXPageControlType.OnFullOffEmpty {
                    CGContextSetStrokeColorWithColor(context, self.offColor.CGColor)
                    CGContextStrokeEllipseInRect(context, dotRect)
                }else {
                    CGContextSetFillColorWithColor(context, self.offColor.CGColor)
                    CGContextFillEllipseInRect(context, CGRectInset(dotRect, -0.5, -0.5))
                }
            }
            x += diameter + space
        }
        
         CGContextRestoreGState(context)
    }
}

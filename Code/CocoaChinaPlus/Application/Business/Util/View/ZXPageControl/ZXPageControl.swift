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
        super.init(frame: CGRect.zero)
        self.type = type
        self.diameter = diameter
        self.onColor = onColor
        self.offColor = offColor
        self.backgroundColor = UIColor.clear
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.saveGState()
        context.setAllowsAntialiasing(true);
        context.clear(rect)
        
        let dotsWith = CGFloat(self.pageCount)*diameter + CGFloat(max(0, self.pageCount - 1)) * space
        var x = self.bounds.midX - dotsWith / 2
        let y = self.bounds.midY - diameter / 2
        
        let lineWidth:CGFloat = 1.0
        context.setLineWidth(lineWidth)
        
        for i in 0 ..< self.pageCount {
            let dotRect = CGRect(x: x, y: y, width: diameter, height: diameter)
            if i == currentPage {
                if self.type == ZXPageControlType.OnFullOffEmpty || self.type == ZXPageControlType.OnFullOffFull {
                    context.setFillColor(self.onColor.cgColor)
                    context.fillEllipse(in: dotRect.insetBy(dx: -0.5, dy: -0.5))
                }else {
                    context.setStrokeColor(self.onColor.cgColor)
                    context.strokeEllipse(in: dotRect)
                    context.setFillColor(self.onColor.cgColor)
                    
                    context.addArc(center: CGPoint(x: dotRect.midY, y: dotRect.midY), radius: diameter / 2 - lineWidth, startAngle: 0.0, endAngle: CGFloat(2.0 * M_PI), clockwise: false)
                    context.fillPath();
                }
            }else {
                if self.type == ZXPageControlType.OnEmptyOffEmpty || self.type == ZXPageControlType.OnFullOffEmpty {
                    context.setStrokeColor(self.offColor.cgColor)
                    context.strokeEllipse(in: dotRect)
                }else {
                    context.setFillColor(self.offColor.cgColor)
                    context.fillEllipse(in: dotRect.insetBy(dx: -0.5, dy: -0.5))
                }
            }
            x += diameter + space
        }
        
         context.restoreGState()
    }
}

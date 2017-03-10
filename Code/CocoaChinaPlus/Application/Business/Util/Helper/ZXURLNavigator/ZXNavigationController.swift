//
//  ZXNavigationController.swift
//  CocoaChinaPlus
//
//  Created by zixun on 17/1/23.
//  Copyright © 2017年 zixun. All rights reserved.
//

import Foundation
import AppBaseKit

open class ZXNavigationController: UINavigationController {
    
    open var enable = true
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        
        // 获取系统自带滑动手势的target对象
        let target = self.interactivePopGestureRecognizer!.delegate;
        
        // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
        let pan = UIPanGestureRecognizer(target: target, action: Selector("handleNavigationTransition:"))
        
        // 设置手势代理，拦截手势触发
        pan.delegate = self;
        
        // 给导航控制器的view添加全屏滑动手势
        self.view.addGestureRecognizer(pan);
        
        // 禁止使用系统自带的滑动手势
        self.interactivePopGestureRecognizer!.isEnabled = false;
        let width = UIScreen.main.bounds.size.width
        
        let image = UIImage.image(color: UIColor(hex: 0x272626), size: CGSize(width: width, height: 0.5))
        let imageView = UIImageView(image: image)
        self.navigationBar.addSubview(imageView)
        var rect = self.navigationBar.bounds
        rect.origin.y = rect.origin.y + rect.size.height - 0.5
        rect.size.height = 0.5
        imageView.frame = rect
    }
    
    
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}

// MARK: UIGestureRecognizerDelegate
extension ZXNavigationController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let translation: CGPoint = (gestureRecognizer as! UIPanGestureRecognizer).translation(in: self.view.superview)
        
        guard self.enable == true else {
            return false
        }
        
        if (translation.x < 0) {
            return false //往右滑返回，往左滑不做操作
        }
        
        if (self.viewControllers.count <= 1) {
            return false
        }
        return true
    }
}

extension UIViewController {
    
    public func presentViewController(_ viewControllerToPresent: UIViewController) {
        self.present(viewControllerToPresent, animated: true, completion: nil)
    }
    
    public func presentViewController(_ viewControllerToPresent: UIViewController,withNavigation:Bool, animated flag: Bool, completion: (() -> Void)?) {
        if withNavigation == false {
            self.present(viewControllerToPresent, animated: flag, completion: completion)
        }else {
            let nav = ZXNavigationController(rootViewController: viewControllerToPresent)
            self.present(nav, animated: flag, completion: completion)
        }
    }
}

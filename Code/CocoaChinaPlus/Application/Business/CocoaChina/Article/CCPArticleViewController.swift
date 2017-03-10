//
//  CCPArticleViewController.swift
//  CocoaChinaPlus
//
//  Created by 子循 on 15/7/23.
//  Copyright © 2015年 zixun. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import MBProgressHUD
import RxSwift
import SwViewCapture
import Log4G

enum CCPArticleViewType {
    case blog
    case bbs
}

class CCPArticleViewController: ZXBaseViewController {

    fileprivate var webview:CCCocoaChinaWebView!
    fileprivate var cuteView:ZXCuteView!
    //文章的wap链接
    fileprivate var wapURL : String!
    //文章的identity
    fileprivate var identity : String!
    
    fileprivate var type : CCPArticleViewType!
    
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate var semaphore = DispatchSemaphore(value: 0)
    
    required init(navigatorURL URL: URL?, query: Dictionary<String, String>) {
        super.init(navigatorURL: URL, query: query)
        
        if query["identity"] != nil {
            self.identity = query["identity"]
            self.wapURL = CCURLHelper.generateWapURL(query["identity"]!)
            self.type = .blog
        }else if query["link"] != nil {
            self.wapURL = query["link"]
            self.type = .bbs
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webview = CCCocoaChinaWebView(frame: self.view.bounds)
        self.view.addSubview(self.webview)
        self.open(wapURL)
        //cuteview逻辑
        self.cuteViewHandle()
        
        //RightBarButtonItems逻辑
        if self.type == .blog {
            self.addRightBarButtonItems()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.cuteView.removeFromSuperview()
    }
    
    func open(_ urlString:String) {
        let url = URL(string: urlString)!

        if url.host == "www.cocoachina.com" {
            self.webview.open(urlString)
        }
    }
}

// MARK: Private
extension CCPArticleViewController {
    
    fileprivate func addRightBarButtonItems() {
        let image = self._isLiked() ? R.image.nav_like_yes() : R.image.nav_like_no()
        let likeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        likeButton.setImage(image, for: UIControlState())
        let collectionItem = UIBarButtonItem(customView: likeButton)
        
        let shareButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        shareButton.setImage(R.image.share(), for: UIControlState())
        shareButton.rx.tap.bindNext { [unowned self] _ in
            UMSocialUIManager.setPreDefinePlatforms([UMSocialPlatformType.sina,UMSocialPlatformType.wechatSession,UMSocialPlatformType.wechatTimeLine,UMSocialPlatformType.wechatFavorite])
            UMSocialUIManager.showShareMenuViewInWindow(platformSelectionBlock: { [unowned self] (type:UMSocialPlatformType, userInfo:[AnyHashable : Any]?) in
                let messageObject:UMSocialMessageObject = UMSocialMessageObject.init()
                messageObject.text = kADText()
                
                if type == UMSocialPlatformType.sina {
                    let shareObject = UMShareImageObject()
                    
                    //设置微博分享参数
                    self.webview.scrollView.swContentCapture({ [unowned self] (image:UIImage?) in
                        shareObject.shareImage = image
                        shareObject.title = self.webview.title + " " + self.wapURL
                        shareObject.descr = kADText()
                        self.semaphore.signal()
                    })
                    _ = self.semaphore.wait(timeout: DispatchTime.distantFuture)
                    messageObject.shareObject = shareObject
                }else {
                    let shareObject = UMShareWebpageObject()
                    shareObject.title = self.webview.title
                    shareObject.descr = kADText()
                    shareObject.webpageUrl = self.wapURL
                    messageObject.shareObject = shareObject
                }
                
                UMSocialManager.default().share(to: type, messageObject: messageObject, currentViewController: self, completion: { (shareResponse:Any?, error:Error?) in
                    if error != nil {
                        Log4G.error("Share Fail with error ：\(error)")
                    }else{
                        Log4G.log("Share succeed")
                    }
                })
                
            })
        }.addDisposableTo(self.disposeBag)
        
        let shareItem = UIBarButtonItem(customView: shareButton)
        
        self.navigationItem.rightBarButtonItemsFixedSpace(items: [collectionItem,shareItem])
        
        likeButton.rx.tap.bindNext { [unowned self] _ in
            if self._isLiked() {
                
                let result = CCArticleService.decollectArticleById(self.identity)
                if result {
                    MBProgressHUD.showText("取消成功")
                    likeButton.setImage(R.image.nav_like_no(), for: UIControlState.normal)
                }else {
                    MBProgressHUD.showText("取消失败")
                }
            }else {
                if !CCArticleService.isArticleExsitById(self.identity) {
                    //如果文章不存在，说明是push之类的进来的
                    let model = CCArticleModel()
                    model.identity = self.identity
                    model.title = self.webview.title
                    model.imageURL = self.webview.imageURL
                    
                    CCArticleService.insertArtice(model)
                }
                let result = CCArticleService.collectArticleById(self.identity)
                
                if result {
                    MBProgressHUD.showText("收藏成功")
                    likeButton.setImage(R.image.nav_like_yes(), for: UIControlState.normal)
                }else {
                    MBProgressHUD.showText("收藏失败")
                }
            }
            
            
            let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
            scaleAnimation.duration = 0.3
            scaleAnimation.values = [1.0,1.2,1.0]
            scaleAnimation.keyTimes = [0.0,0.5,1.0]
            scaleAnimation.isRemovedOnCompletion = true
            scaleAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn), CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)]
            likeButton.layer.add(scaleAnimation, forKey: "likeButtonscale")
        }.addDisposableTo(self.disposeBag)
    }
    
    fileprivate func cuteViewHandle() {
        let point = CGPoint(x: self.view.xMax - 50, y: self.view.yMax - 150)
        self.cuteView = ZXCuteView(point: point, superView: self.view, bubbleWidth: 40)
        self.cuteView.tapCallBack = {[weak self] () -> Void  in
            if let sself = self {
                sself._addAnimationForBackTop()
            }
        }
    }
    
    /**
    文章是否已经标记为收藏
    
    - returns: 是否收藏
    */
    fileprivate func _isLiked() ->Bool {
        return CCArticleService.isArticleCollectioned(self.identity)
    }
    
    fileprivate func _addAnimationForBackTop() {
        //将webview置顶
        for subview in self.webview.subviews {
            if subview.isKind(of: UIScrollView.self) {
                (subview as! UIScrollView).setContentOffset(CGPoint.zero, animated: true)
            }
        }
        
        //置顶动画
        self.cuteView.removeAniamtionLikeGameCenterBubble()
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.cuteView.frontView?.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
            self.cuteView.frontView?.alpha = 0.0
            }, completion: { (finished) -> Void in
                self.cuteView.frontView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.cuteView.frontView?.alpha = 1.0
                self.cuteView.addAniamtionLikeGameCenterBubble()
        })
    }
}

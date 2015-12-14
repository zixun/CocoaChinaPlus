////
////  CCADFullScreenManager.swift
////  CocoaChinaPlus
////
////  Created by user on 15/11/4.
////  Copyright © 2015年 zixun. All rights reserved.
////
//
//import Foundation
//import RxSwift
//import ZXKit
//
//class CCADInterstitial: CCAD {
//    
//    static let sharedInstance = CCADInterstitial()
//    
//    private let showTrigger = PublishSubject<Void>()
//    
//    private var googleHandler : CCADInterstitialGoogleHandler?
//    
//    private var baiduHandler : CCADInterstitialBaiduHandler?
//    
//    private var type: CCADType = .Google
//   
//    //RxSwift资源回收包
//    private let disposeBag = DisposeBag()
//    
//    override init() {
//        super.init()
//        
//        self.rx_adviewTypeChange().subscribeNext { [weak self] (type) -> Void in
//            
//            guard let sself = self else {
//                return
//            }
//            
//            sself.type = type
//            
//            if type == CCADType.Baidu {
//                sself.googleHandler = nil
//                sself.baiduHandler = CCADInterstitialBaiduHandler()
//            }else {
//                sself.baiduHandler = nil
//                sself.googleHandler = CCADInterstitialGoogleHandler()
//                
//            }
//            
//            }.addDisposableTo(self.disposeBag)
//        
//        self.showTrigger
//            .subscribeNext { _ in
//                if self.type == CCADType.Baidu {
//                    self.baiduHandler?.showIfReady()
//                }else {
//                    self.baiduHandler = nil
//                    self.googleHandler?.showIfReady()
//                }
//            }
//            .addDisposableTo(self.disposeBag)
//    }
//    
//    func show() {
//        self.showTrigger.on(Event<Void>.Next())
//    }
//}
//
//
//private class CCADInterstitialGoogleHandler : NSObject, GADInterstitialDelegate {
//    private var interstitialViewGoogle: GADInterstitial!
//    
//    override init() {
//        super.init()
//        self.interstitialViewGoogle = self.createInterstitialGoogle()
//        
//        
//    }
//    
//    func showIfReady() {
//        if self.interstitialViewGoogle.isReady {
//            self.interstitialViewGoogle.presentFromRootViewController(ZXNav().topViewController)
//        }
//    }
//    
//    private func createInterstitialGoogle() -> GADInterstitial {
//        let interstitialViewGoogle = GADInterstitial(adUnitID: "ca-app-pub-4051144321317231/7194423508")
//        interstitialViewGoogle.delegate = self
//        interstitialViewGoogle.loadRequest(GADRequest())
//        return interstitialViewGoogle
//    }
//    
//    @objc func interstitialDidDismissScreen(ad: GADInterstitial!) {
//        self.interstitialViewGoogle = self.createInterstitialGoogle()
//    }
//    
//    @objc func interstitialDidReceiveAd(ad: GADInterstitial!) {
//        println("interstitialDidReceiveAd")
//    }
//    
//    @objc func interstitial(ad: GADInterstitial!, didFailToReceiveAdWithError error: GADRequestError!) {
//        println("didFailToReceiveAdWithError")
//    }
//}
//
//
//private class CCADInterstitialBaiduHandler : NSObject, BaiduMobAdInterstitialDelegate {
//    
//    private var interstitialViewBaidu: BaiduMobAdInterstitial!
//    
//    override init() {
//        super.init()
//        self.interstitialViewBaidu = self.createInterstitialBaidu()
//    }
//    
//    func showIfReady() {
//        
//        if (self.interstitialViewBaidu.isReady){
//            self.interstitialViewBaidu.presentFromRootViewController(ZXNav())
//
//        }
//    }
//    private func createInterstitialBaidu() -> BaiduMobAdInterstitial {
//        let interstitialViewBaidu = BaiduMobAdInterstitial()
//        interstitialViewBaidu.delegate = self
//        interstitialViewBaidu.AdUnitTag = "2083030"
//        interstitialViewBaidu.interstitialType = BaiduMobAdViewTypeInterstitialOther
//        interstitialViewBaidu.load()
//        return interstitialViewBaidu
//    }
//    
//    @objc func publisherId() -> String! {
//        return "cfe01381"
//    }
//    
//    @objc func interstitialSuccessToLoadAd(interstitial: BaiduMobAdInterstitial!) {
//        
//    }
//    
//    @objc func interstitialDidDismissScreen(interstitial: BaiduMobAdInterstitial!) {
//        self.interstitialViewBaidu = self.createInterstitialBaidu()
//    }
//}
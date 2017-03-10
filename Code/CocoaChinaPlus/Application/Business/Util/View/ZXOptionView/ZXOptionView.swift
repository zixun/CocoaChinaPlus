//
//  ZXOptionView.swift
//  CocoaChinaPlus
//
//  Created by 子循 on 15/7/10.
//  Copyright © 2015年 zixun. All rights reserved.
//

import UIKit

public typealias ZXOptionViewCellPoint = AutoreleasingUnsafeMutablePointer<ZXOptionViewCell>

// MARK: - ZXOptionViewDelegate
@objc public protocol ZXOptionViewDelegate :NSObjectProtocol{
    
    func numberOfOptionsInOptionView(_ optionView:ZXOptionView) -> Int
    
    func optionView(_ optionView:ZXOptionView, itemSizeAtIndex index:Int) ->CGSize
    
    func optionView(_ optionView:ZXOptionView, cellConfiguration cellPoint:ZXOptionViewCellPoint)
    
    @objc optional func optionView(_ optionView:ZXOptionView, didSelectOptionAtIndex index:Int)
}

public enum ZXOptionViewType:Int {
    case tap    = 0
    case slider = 1
}

// MARK: - ZXOptionView
open class ZXOptionView: UICollectionView{
    
    open weak var optionDelegate: ZXOptionViewDelegate?
    
    open var floatIndex: Float = 0.0 {
        didSet{
            self.type = .slider
            self.handle(floatIndex)
        }
    }
    
    open var type:ZXOptionViewType = .slider
    
    fileprivate var selectIndex: Int = 0
    
    public init(frame: CGRect) {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.backgroundColor = UIColor.clear
        self.delegate = self
        self.dataSource = self
        self.isPagingEnabled = false
        self.bounces = false
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        
        self.register(ZXOptionViewCell.self, forCellWithReuseIdentifier: "ZXOptionViewCell")
    }
    
    public convenience init() {
        self.init(frame:CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
// MARK: Private Method
extension ZXOptionView {
    
    fileprivate func handle(_ floatIndex:Float) {
        
        if floatIndex - Float(Int(floatIndex)) == 0 {
            self.selectIndex = Int(floatIndex)
            return
        }
        
        let handle = self.calculate(floatIndex)
        self.cellforOptionAtIndex(handle.floor).textLabel.textColor = decimalColor(handle.decimal)
        self.cellforOptionAtIndex(handle.ceilf).textLabel.textColor = decimalColor(1.0 - handle.decimal)
        self.contentOffset = self.contentOffsetAt(floatIndex)
    }
    
    fileprivate func decimalColor(_ decimal:CGFloat) ->UIColor {
        let startColor = UIColor.white
        let endColor = UIColor.gray
        
        return UIColor.gradient(startColor: startColor, endColor: endColor, fraction: decimal)
    }
    
    fileprivate func calculate(_ floatIndex:Float) ->(floor:Int,ceilf:Int,decimal:CGFloat) {
        
        let _floor = Int(floor(floatIndex))
        let _ceilf = Int(ceilf(floatIndex))
        let _decimal:CGFloat = CGFloat(floatIndex - floor(floatIndex))
        return (_floor,_ceilf,_decimal)
    }
    
    fileprivate func contentOffsetAt(_ floatIndex: Float) -> CGPoint {
        let handle = self.calculate(floatIndex)
        let _floorCell = self.cellforOptionAtIndex(handle.floor)
        let _ceilfCell = self.cellforOptionAtIndex(handle.ceilf)
        
        var offsetX =  _floorCell.center.x + (_ceilfCell.center.x - _floorCell.center.x) * handle.decimal - self.frame.size.width / 2.0
        offsetX = min(max(0, offsetX), self.contentSize.width - self.frame.size.width)
        return CGPoint(x: offsetX, y: 0)
    }
    
    fileprivate func cellforOptionAtIndex(_ index:Int) -> ZXOptionViewCell {
        return self.cellForItem(at: IndexPath(row: index, section: 0)) as! ZXOptionViewCell
    }
}

// MARK: UICollectionViewDelegate and UICollectionViewDataSource
extension ZXOptionView : UICollectionViewDelegate,UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard self.optionDelegate != nil else {
            return 0
        }
        
        return self.optionDelegate!.numberOfOptionsInOptionView(self)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: ZXOptionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZXOptionViewCell", for: indexPath) as! ZXOptionViewCell
        cell.index = indexPath.row
        cell.textLabel.textColor = selectIndex == indexPath.row ? UIColor.white : UIColor.gray
        
        if self.optionDelegate != nil {
            self.optionDelegate!.optionView(self, cellConfiguration: &cell)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        guard self.optionDelegate != nil else {
            return CGSize(width: 100, height: 44)
        }
        
        return self.optionDelegate!.optionView(self, itemSizeAtIndex: indexPath.row)
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //颜色处理
        if let cell_pre_selected = self.cellForItem(at: IndexPath(row: self.selectIndex, section: 0)) {
            
            UIView.transition(with: (cell_pre_selected as! ZXOptionViewCell).textLabel, duration: 0.3, options: .transitionCrossDissolve, animations: { () -> Void in
                (cell_pre_selected as! ZXOptionViewCell).textLabel.textColor = UIColor(hex:0xB4B4B4)
                }, completion: nil)
        }
        
        let cell_selected:ZXOptionViewCell = self.cellForItem(at: indexPath) as! ZXOptionViewCell
        
        UIView.transition(with: cell_selected.textLabel, duration: 0.3, options: .transitionCrossDissolve, animations: { () -> Void in
            cell_selected.textLabel.textColor = UIColor.white
            self.contentOffset = self.contentOffsetAt(Float(indexPath.row))
            }, completion: nil)
        
        self.selectIndex = indexPath.row
        
        guard self.optionDelegate != nil else{
            return
        }
        
        guard self.optionDelegate!.responds(to: #selector(ZXOptionViewDelegate.optionView(_:didSelectOptionAtIndex:))) else {
            return
        }
        self.type = .tap
        self.optionDelegate!.optionView!(self, didSelectOptionAtIndex: indexPath.row)
    }
}


// MARK: - ZXOptionViewCell
open class ZXOptionViewCell: UICollectionViewCell {
    
    open var index: Int = 0
    
    open var textLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.textLabel = UILabel()
        self.textLabel.font = UIFont.systemFont(ofSize: 14)
        self.textLabel.textAlignment = NSTextAlignment.center
        self.textLabel.textColor = UIColor(hex: 0xB4B4B4)
        self.contentView.addSubview(textLabel)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel.fillSuperview(left: 2, right: 2, top: 0, bottom: 0)
    }
}


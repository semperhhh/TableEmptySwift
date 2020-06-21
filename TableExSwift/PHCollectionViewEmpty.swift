//
//  PHCollectionViewEmpty.swift
//  TableExSwift
//
//  Created by zhangpenghui on 2020/6/21.
//  Copyright © 2020 zph. All rights reserved.
//

import Foundation
import UIKit

//MARK: emptyDelegate
protocol PHCollectionViewEmptyDelegate {
    
    /// collectionview data now
    func collectionViewEmpty() -> Int
    
    /// optianal, custom emptyView
    func collectionViewEmptyView(_ collectionView: UICollectionView) -> UIView?
}

//MARK: extension emptyDelegate
extension PHCollectionViewEmptyDelegate {
    
    func collectionViewEmptyView(_ collectionView: UICollectionView) -> UIView? {
        
        print("extension collectionViewEmptyView")
        
        return PHEmptyView()
    }
}

struct CollectionViewKeys {
    
    static var PHDelegate: PHCollectionViewEmptyDelegate?
    
    static var PHEmptyView: UIView?
}

//MARK: extension collectionView
extension UICollectionView {
    
    func swizzle() {
        
        guard let m1 = class_getInstanceMethod(self.classForCoder, #selector(reloadData)) else { return  }
        
        guard let m2 = class_getInstanceMethod(self.classForCoder, #selector(newReloadData)) else { return }
        
        method_exchangeImplementations(m1, m2)
    }
    
    @objc func newReloadData() {
        
        emptyStatus()
        newReloadData()
    }
    
    var PHDelegate: PHCollectionViewEmptyDelegate? {
        set {
            objc_setAssociatedObject(self, &CollectionViewKeys.PHDelegate, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &CollectionViewKeys.PHDelegate) as? PHCollectionViewEmptyDelegate
        }
    }
    
    /// emptyView, default is PHEmptyView
    var emptyView: UIView? {
        set {
            objc_setAssociatedObject(self, &CollectionViewKeys.PHEmptyView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &CollectionViewKeys.PHEmptyView) as? UIView
        }
    }
    
    /// whether show emptyView
    func emptyStatus() {
        
        print("数据个数", self.PHDelegate?.collectionViewEmpty() ?? 0)
        
        let isEmpty: Bool = PHDelegate?.collectionViewEmpty() ?? 0 > 0 ? false : true
  
        if isEmpty {//show emptyView
            
            emptyView = emptyView != nil ? emptyView : (self.PHDelegate?.collectionViewEmptyView(self) != nil ? self.PHDelegate?.collectionViewEmptyView(self) : UIView())
            self.addSubview(emptyView!)
        }else {
            emptyView?.removeFromSuperview()
        }
    }
}

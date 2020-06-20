//
//  PHTableViewEmpty.swift
//  TableExSwift
//
//  Created by zhangpenghui on 2020/6/20.
//  Copyright © 2020 zph. All rights reserved.
//

import UIKit
import Foundation

protocol PHTableViewEmpty {

    func tableViewEmpty() -> Int
}

struct AssociatedKeys {
    
    static var PHDelegate: PHTableViewEmpty?
    
    static var PHEmptyView: UIView?
}

extension UITableView {
    
    func swizzle() {
        
        guard let m1 = class_getInstanceMethod(self.classForCoder, #selector(reloadData)) else { return  }
        
        guard let m2 = class_getInstanceMethod(self.classForCoder, #selector(newReloadData)) else { return }
        
        method_exchangeImplementations(m1, m2)
    }
    
    @objc func newReloadData() {
        
        emptyStatus()
        newReloadData()
    }
    
    var PHDelegate: PHTableViewEmpty? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.PHDelegate, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.PHDelegate) as? PHTableViewEmpty
        }
    }
    
    var emptyView: UIView? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.PHEmptyView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.PHEmptyView) as? UIView
        }
    }
    
    /// 判断是否空状态
    func emptyStatus() {
        
        print("数据个数", self.PHDelegate?.tableViewEmpty() ?? 0)
        
        let isEmpty: Bool = PHDelegate?.tableViewEmpty() ?? 0 > 0 ? false : true
  
        if isEmpty {//空状态
            emptyView == nil ? emptyView = PHEmptyView() : nil //防止多次创建
            self.addSubview(emptyView!)
        }else {
            emptyView?.removeFromSuperview()
        }
    }
}

class PHEmptyView: UIView {
    
    /// 空状态图片
    var emptyImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "tableEmpty_img")
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    /// 空状态文字
    var emptyLab: UILabel = {
        let lab = UILabel()
        lab.text = "暂无内容"
        lab.textAlignment = NSTextAlignment.center
        lab.textColor = UIColor.systemGray2
        lab.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return lab
    }()
    
    var emptyString: String? {
        
        didSet {
            if emptyString != nil {
                self.emptyLab.text = emptyString
            }
        }
    }
    
    var emptyImageString: String? {
        
        didSet {
            if emptyImageString != nil {
                self.emptyImgView.image = UIImage(named: emptyImageString!)?.withTintColor(UIColor.systemGray2, renderingMode: .alwaysOriginal)
            }
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        //如果没有给位置
        if frame == CGRect.zero  {
            self.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 50, y: UIScreen.main.bounds.height / 2 - 160, width: 100, height: 130)
        }
        
        self.addSubview(emptyImgView)
        self.addSubview(emptyLab)
    }
    
    override func layoutSubviews() {
        
        emptyImgView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.width)
        emptyLab.frame = CGRect(x: 0, y: self.bounds.width, width: self.bounds.width, height: 30)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


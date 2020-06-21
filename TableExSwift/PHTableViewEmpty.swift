//
//  PHTableViewEmpty.swift
//  TableExSwift
//
//  Created by zhangpenghui on 2020/6/20.
//  Copyright © 2020 zph. All rights reserved.
//

import UIKit
import Foundation

//MARK: emptyDelegate
protocol PHTableViewEmptyDelegate {
    
    /// tableview data now
    func tableViewEmpty() -> Int
    
    /// optianal, custom emptyView
    func tableViewEmptyView(_ tableView: UITableView) -> UIView?
}

//MARK: extension emptyDelegate
extension PHTableViewEmptyDelegate {
    
    func tableViewEmptyView(_ tableView: UITableView) -> UIView? {
        
        print("extension tableViewEmptyView")
        
        return PHEmptyView()
    }
}

struct AssociatedKeys {
    
    static var PHDelegate: PHTableViewEmptyDelegate?
    
    static var PHEmptyView: UIView?
}

//MARK: extension tableview
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
    
    var PHDelegate: PHTableViewEmptyDelegate? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.PHDelegate, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.PHDelegate) as? PHTableViewEmptyDelegate
        }
    }
    
    /// emptyView, default is PHEmptyView
    var emptyView: UIView? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.PHEmptyView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.PHEmptyView) as? UIView
        }
    }
    
    /// whether show emptyView
    func emptyStatus() {
        
        print("数据个数", self.PHDelegate?.tableViewEmpty() ?? 0)
        
        let isEmpty: Bool = PHDelegate?.tableViewEmpty() ?? 0 > 0 ? false : true
  
        if isEmpty {//show emptyView
            
            emptyView = emptyView != nil ? emptyView : (self.PHDelegate?.tableViewEmptyView(self) != nil ? self.PHDelegate?.tableViewEmptyView(self) : UIView())
            self.addSubview(emptyView!)
        }else {
            emptyView?.removeFromSuperview()
        }
    }
}

//MARK: PHEmptyView
class PHEmptyView: UIView {
    
    /// empty image
    var emptyImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "tableEmpty_img")
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    /// empty text
    var emptyLab: UILabel = {
        let lab = UILabel()
        lab.text = "Empty Data"
        lab.textAlignment = NSTextAlignment.center
        lab.textColor = UIColor.systemGray2
        lab.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return lab
    }()
    
    /// show img, default is "tableEmpty_img", by value "nil" imageView is hidden.
    /// - Parameter emptyImgString: img string
    /// - Returns: self
    func emptyImg(_ emptyImgString: String?) -> PHEmptyView {
        
        if emptyImgString == nil {
            self.emptyImgView.isHidden = true
        } else {
            self.emptyImgView.isHidden = false
            self.emptyImgView.image = UIImage(named: emptyImgString!)
        }
        return self
    }
    
    /// show text, default is "Empty Data", by value "nil" label is Hidden.
    /// - Parameter emptyString: text
    /// - Returns: self
    func emptyText(_ emptyString: String?) -> PHEmptyView {
        
        if emptyString == nil {
            self.emptyLab.isHidden = true
        } else {
            self.emptyLab.isHidden = false
            self.emptyLab.text = emptyString
        }
        return self
    }
    
    /// 重写init
    init() {
     
        super.init(frame: CGRect(x: UIScreen.main.bounds.width / 2 - 50, y: UIScreen.main.bounds.height / 2 - 160, width: 100, height: 130))
        
        self.addSubview(emptyImgView)
        self.addSubview(emptyLab)
    }

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        //if no frame
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


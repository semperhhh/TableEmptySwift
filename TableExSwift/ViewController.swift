//
//  ViewController.swift
//  TableExSwift
//
//  Created by zhangpenghui on 2020/6/20.
//  Copyright © 2020 zph. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    /// 添加
    lazy var addBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 20, y: self.view.bounds.height - 88, width: 44, height: 44))
        btn.backgroundColor = UIColor.systemPink
        btn.setTitle("添加", for: .normal)
        btn.addTarget(self, action: #selector(addBtnClick), for: .touchUpInside)
        btn.layer.cornerRadius = 22
        return btn
    }()
    
    @objc func addBtnClick() {
        self.dataList.append("1")
        self.dataList.append("2")
        self.dataList.append("3")
        self.tableview.reloadData()
    }
    
    /// 移除
    lazy var removeBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 74, y: self.view.bounds.height - 88, width: 44, height: 44))
        btn.backgroundColor = UIColor.systemPink
        btn.setTitle("移除", for: .normal)
        btn.addTarget(self, action: #selector(removeBtnClick), for: .touchUpInside)
        btn.layer.cornerRadius = 22
        return btn
    }()
    
    @objc func removeBtnClick() {
        self.dataList.removeAll()
        self.tableview.reloadData()
    }
    
    var dataList: [String] = ["1", "2", "3"]
    
    lazy var tableview: UITableView = {
        
        let tableview = UITableView(frame: self.view.bounds, style: .plain)
//        tableview.swizzle()//整个项目只调用一次即可,可以放到appdelegate
        tableview.backgroundColor = UIColor.white
        tableview.dataSource = self
        tableview.delegate = self
        tableview.PHDelegate = self
        tableview.tableFooterView = UIView()
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.addSubview(tableview)
        self.view.addSubview(addBtn)
        self.view.addSubview(removeBtn)
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate, PHTableViewEmptyDelegate {
    
    func tableViewEmpty() -> Int {
        return self.dataList.count
    }

    /* 自定义状态视图
    func tableViewEmptyView(_ tableView: UITableView) -> UIView? {
        
        print("tableViewEmptyView")
        
        let v = UIView(frame: CGRect(x: tableView.bounds.width / 2 - 100, y: tableView.bounds.height / 2 - 200, width: 200, height: 200))
        v.backgroundColor = UIColor.systemIndigo
        return v
    }
 */
    
    /// 默认的状态视图,text和img为nil则不展示
    /*
    func tableViewEmptyView(_ tableView: UITableView) -> UIView? {

        let view: PHEmptyView = PHEmptyView().emptyText(nil).emptyImg(nil)
        return view
    }
 */

 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.contentView.backgroundColor = UIColor.systemTeal
        let lab = UILabel(frame: CGRect(x: 15, y: 0, width: cell.contentView.bounds.width - 30, height: cell.contentView.bounds.height))
        lab.text = "\(indexPath.row)"
        cell.contentView.addSubview(lab)
        return cell
    }
}


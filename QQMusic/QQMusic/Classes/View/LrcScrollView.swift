//
//  LrcScrollView.swift
//  QQMusic
//
//  Created by Lenhulk on 2016/11/29.
//  Copyright © 2016年 Lenhulk. All rights reserved.
//

import UIKit

let kLrcCellID : String = "LrcTVCell"

class LrcScrollView: UIScrollView {
    
    // MARK: - 控件&属性
    fileprivate lazy var tableView : UITableView = UITableView()
    fileprivate var lrclines : [String]?
    
    var lrcName : String = "" {
        didSet{
            //一加载歌词就设置tableView偏移量(第一句歌词从中间往上滚)
            tableView.setContentOffset(CGPoint(x: 0, y: -bounds.width * 0.5), animated: true)
            lrclines = LrcTools.parseLrc(lrcName)
            tableView.reloadData()
        }
    }

    // MARK: - 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
}


// MARK: - 设置UI
extension LrcScrollView{
    fileprivate func setupUI(){
        addSubview(tableView)
        tableView.dataSource = self
        tableView.register(LrcViewCell.self, forCellReuseIdentifier: kLrcCellID)
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 35
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let x : CGFloat = bounds.width
        let y : CGFloat = 0
        let w : CGFloat = bounds.width
        let h : CGFloat = bounds.height
        tableView.frame = CGRect(x: x, y: y, width: w, height: h)
            //设置顶部和底部可滚动的额外区域
        tableView.contentInset = UIEdgeInsetsMake(bounds.height * 0.5, 0, bounds.height * 0.5, 0)
            //设置一开始的偏移量
        tableView.contentOffset = CGPoint(x: 0, y: -bounds.size.width * 0.5)
    }
}


// MARK: - UITableViewDelegate
extension LrcScrollView: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lrclines!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kLrcCellID, for: indexPath)
        cell.textLabel?.text = lrclines![indexPath.row]
        return cell
    }
}

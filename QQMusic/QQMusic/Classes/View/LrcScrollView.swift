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
    
    // MARK: - 控件&内部属性
    fileprivate lazy var tableView : UITableView = UITableView()
    fileprivate var lrclines : [LrclineModel]?
    fileprivate var currentlineIndex : Int = 0
    
    // MARK: - 对外属性
    var currentTime : TimeInterval = 0 {
        didSet{
            //校验歌词是否有值
            guard let lrclines = lrclines else { return }
            //遍历所有歌词
            let count = lrclines.count
            for i in 0..<count{
                //1取出当前歌词
                let lrcline = lrclines[i]
                //2取出下一句歌词
                let nextIndex = i + 1
                if nextIndex > count - 1 { continue }
                let nextLrcline = lrclines[nextIndex]
                //3大于i位置的歌词,并且小于i+1位置的歌词,则显示i位置的歌词
                if currentTime > lrcline.lrcTime && currentTime < nextLrcline.lrcTime && i != currentlineIndex{
                    let preIndexPath = IndexPath(row: currentlineIndex, section: 0) //上一个对应的path
                    currentlineIndex = i
                    let indexPath = IndexPath(row: i, section: 0)   //当前的path
                    tableView.reloadRows(at: [indexPath, preIndexPath], with: .none)
                    tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
    }
    
    var lrcName : String = "" {
        didSet{
            //一加载歌词就设置tableView偏移量(第一句歌词从中间往上滚)
            tableView.setContentOffset(CGPoint(x: 0, y: -bounds.width * 0.5), animated: true)
            lrclines = LrcTools.parseLrc(lrcName)
            tableView.reloadData()
            
            currentlineIndex = 0
        }
    }

    // MARK: - 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    ///设置TV一开始的偏移量
    private func setTableViewContentOffset(){
        tableView.contentOffset = CGPoint(x: 0, y: -bounds.size.width * 0.5)
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
    }
}


// MARK: - UITableViewDelegate
extension LrcScrollView: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lrclines?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kLrcCellID, for: indexPath)
        
        if indexPath.row == currentlineIndex{
            cell.textLabel?.textColor = UIColor.cyan
        } else {
            cell.textLabel?.textColor = UIColor.white
        }
        
        let lrcline = lrclines![indexPath.row]
        cell.textLabel?.text = lrcline.lrcText
        
        return cell
    }
}

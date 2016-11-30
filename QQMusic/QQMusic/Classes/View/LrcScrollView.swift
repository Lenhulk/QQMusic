//
//  LrcScrollView.swift
//  QQMusic
//
//  Created by Lenhulk on 2016/11/29.
//  Copyright © 2016年 Lenhulk. All rights reserved.
//

import UIKit

private let kLrcCellID : String = "LrcTVCell"

// MARK: - 定义LrcScrollViewDelegate协议
protocol LrcScrollViewDelegate : class {
    func lrcScrollView(_ lrcScrollView : LrcScrollView, lrcText : String, progress : Double)
}

class LrcScrollView: UIScrollView {
    
    // MARK: - 控件&内部属性
    fileprivate lazy var tableView : UITableView = UITableView()
    fileprivate var lrclines : [LrclineModel]?
    fileprivate var currentlineIndex : Int = 0
    
    // MARK: - 对外属性
    weak var lrcSVDelegate : LrcScrollViewDelegate?
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
                
                //4判断是否正在播放同一句歌词
                if i == currentlineIndex{
                    
                    //01获取当前句进度
                    let progress = (currentTime - lrcline.lrcTime) / (nextLrcline.lrcTime - lrcline.lrcTime)
                    
                    //02取出当前对应cell
                    let indexPath = IndexPath(row: i, section: 0)
                    guard let currentCell = tableView.cellForRow(at: indexPath) as? LrcViewCell else { continue }
                    currentCell.lrcLabel.progress = progress
                    
                    //03通知代理&传入内容
                    lrcSVDelegate?.lrcScrollView(self, lrcText: lrcline.lrcText, progress: progress)
                }
            }
        }
    }
    
    var lrcName : String = "" {
        didSet{
            //一加载歌词就设置tableView偏移量(第一句歌词从中间往上滚, 不要有动画效果会比较好)
            tableView.setContentOffset(CGPoint(x: 0, y: -bounds.width * 0.5), animated: false)
            lrclines = LrcTools.parseLrc(lrcName)
            tableView.reloadData()
            
            //每次有新的歌词的时候要把currentlineIndex重置, 否则歌词处若记录一个大行数, 切歌进入下一首在新的歌词文件中读取不到这个行数的值, 会崩溃
            currentlineIndex = 0
        }
    }

    // MARK: - 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    ///设置TV一开始的偏移量
    func setTableViewContentOffset(){
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


// MARK: - ScrollView数据源方法
extension LrcScrollView: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lrclines?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kLrcCellID, for: indexPath) as! LrcViewCell
        
        if indexPath.row == currentlineIndex{
            cell.lrcLabel.font = UIFont.systemFont(ofSize: 16.0)
        } else {
            cell.lrcLabel.font = UIFont.systemFont(ofSize: 14.0)
            cell.lrcLabel.progress = 0
        }
        
        let lrcline = lrclines![indexPath.row]
        cell.lrcLabel.text = lrcline.lrcText
        
        return cell
    }
    
}

//
//  PlayingViewController.swift
//  QQMusic
//
//  Created by Lenhulk on 2016/11/28.
//  Copyright © 2016年 Lenhulk. All rights reserved.
//

import UIKit

class PlayingViewController: UIViewController {
    
    // MARK: - 控件属性
    @IBOutlet weak var backgroundImageView: UIImageView!

    // MARK: - 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    


}

// MARK: - 设置UI界面
extension PlayingViewController{
    fileprivate func setupUI(){
        setupBlurView()
    }
    
    /// 添加毛玻璃效果
    private func setupBlurView(){
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]   //设置自动拉伸
        backgroundImageView.addSubview(blurView)
    }
    
    ///设置状态栏颜色
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}

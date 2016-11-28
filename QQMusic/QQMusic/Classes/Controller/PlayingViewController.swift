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
    @IBOutlet weak var progressSlider: UISlider!
    
    // MARK: - 懒加载
    fileprivate lazy var musicList : [MusicModel] = [MusicModel]()
    
    // MARK: - 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadMusicData()
        startPlayingMusic()
    }
    


}

// MARK: - 设置UI界面
extension PlayingViewController{
    
    fileprivate func setupUI(){
        setupBlurView()
            //设置滑块样式
        progressSlider.setThumbImage(UIImage(named: "player_slider_playback_thumb"), for: .normal)
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

// MARK: - 加载歌曲数据
extension PlayingViewController{
    
    fileprivate func loadMusicData(){
        guard let path = Bundle.main.path(forResource: "Musics.plist", ofType: nil) else { return }
        guard let dataArr = NSArray(contentsOfFile: path) as? [[String : Any]] else { return }
        for dict in dataArr{
            musicList.append(MusicModel(dict: dict))
        }
    }
}

// MARK: - 播放歌曲
extension PlayingViewController{
    
    fileprivate func startPlayingMusic(){
        //1取出歌曲播放
        let redomNum = arc4random_uniform(UInt32(musicList.count))
        let music = musicList[Int(redomNum)]
        MusicTools.playMusic(music.filename)
        //2改变界面内容
    }
}





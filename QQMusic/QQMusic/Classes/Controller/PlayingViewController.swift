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
    @IBOutlet weak var singerLabel: UILabel!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var iconViewWidthCons: NSLayoutConstraint!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    // MARK: - 成员属性
    fileprivate lazy var musicList : [MusicModel] = [MusicModel]()
    fileprivate var progressTimer : Timer?
    
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
            //1设置毛玻璃
        setupBlurView()
            //2设置滑块样式
        progressSlider.setThumbImage(UIImage(named: "player_slider_playback_thumb"), for: .normal)
            //3设置IconImageView
        var ratio : CGFloat = 0.7
        if UIScreen.main.bounds.height == 480{
            ratio = 0.6
            iconViewWidthCons.constant = UIScreen.main.bounds.width * 6 / 7
        }   //iphone4屏幕适配(好像会崩溃)
        iconImageView.layer.cornerRadius = view.bounds.width * ratio * 0.5
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.borderWidth = 8
        iconImageView.layer.borderColor = UIColor.black.cgColor
    }
    
    /// 添加毛玻璃效果
    private func setupBlurView(){
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = CGRect(x: 0, y: 0, width: backgroundImageView.bounds.width, height: backgroundImageView.bounds.height)
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]   //自动拉伸到父控件的长宽
        backgroundImageView.addSubview(blurView)
    }
    
    ///给iconImageView添加圆角
//    private func setupCorner(){
//    }
    
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
        backgroundImageView.image = UIImage(named: music.icon)
        iconImageView.image = UIImage(named: music.icon)
        songLabel.text = music.name
        singerLabel.text = music.singer
        progressSlider.value = 0
        
        //3修改显示的时间
        currentTimeLabel.text = "00:00"
        totalTimeLabel.text = stringWithTime(MusicTools.getDuration())
        
        //4添加更新进度的定时器
        addProgressTimer()
        
        //5给IconImageView添加动画
        addRotationAnimation()
    }
    
    fileprivate func stringWithTime(_ time : TimeInterval) -> String{
        let min = Int(time) / 60
        let sec = Int(time) % 60
        return String(format: "%02d:%02d", arguments: [min, sec])
    }
    
    private func addRotationAnimation(){
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnim.fromValue = 0
        rotationAnim.toValue = M_PI * 2
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.duration = 30
        self.iconImageView.layer.add(rotationAnim, forKey: nil)
    }
}

// MARK: - 操作定时器
extension PlayingViewController{
    
    /// 添加定时器
    fileprivate func addProgressTimer(){
        progressTimer = Timer(timeInterval: 1.0, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        RunLoop.main.add(progressTimer!, forMode: .commonModes)
    }
    
    /// 更新进度
    @objc private func updateProgress(){
        currentTimeLabel.text = stringWithTime(MusicTools.getCurrentTime())
        progressSlider.value = Float(MusicTools.getCurrentTime() / MusicTools.getDuration())
    }
    
    /// 移除定时器
    fileprivate func removeProgressTimer(){
        progressTimer?.invalidate()
        progressTimer = nil
    }
}



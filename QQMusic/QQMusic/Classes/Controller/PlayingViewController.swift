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
    @IBOutlet weak var lrcScrollView: LrcScrollView!
    @IBOutlet weak var lrcLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    
    // MARK: - 成员属性
    fileprivate lazy var musicList : [MusicModel] = [MusicModel]()
    fileprivate var progressTimer : Timer?
    fileprivate var lrcTimer : CADisplayLink?
    fileprivate var currentMusic : MusicModel!
    
    // MARK: - 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadMusicData()
        currentMusic = musicList[4]
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
        setupIconViewCons()
        
        //4设置scrollview的滚动范围
        lrcScrollView.contentSize = CGSize(width: view.bounds.width * 2, height: 0)
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
    private func setupIconViewCons(){
        var ratio : CGFloat = 0.7
        if UIScreen.main.bounds.height == 480{
            ratio = 0.6
            iconViewWidthCons.constant = UIScreen.main.bounds.width * 0.6 - UIScreen.main.bounds.width * 0.7
        }   //iphone4屏幕适配(好像会崩溃?)
        iconImageView.layer.cornerRadius = view.bounds.width * ratio * 0.5
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.borderWidth = 8
        iconImageView.layer.borderColor = UIColor.black.cgColor
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
        //随机
//        let redomNum = arc4random_uniform(UInt32(musicList.count))
//        let music = musicList[Int(redomNum)]
        
        MusicTools.playMusic(currentMusic.filename)
        
        //2改变界面内容
        backgroundImageView.image = UIImage(named: currentMusic.icon)
        iconImageView.image = UIImage(named: currentMusic.icon)
        songLabel.text = currentMusic.name
        singerLabel.text = currentMusic.singer
        progressSlider.value = 0
        
        //3修改显示的时间
        currentTimeLabel.text = "00:00"
        totalTimeLabel.text = stringWithTime(MusicTools.getDuration())
        
        //4添加更新进度的定时器
        removeProgressTimer()
        addProgressTimer()
        
        //5给IconImageView添加动画
        addRotationAnimation()
        
        //6将歌词文件传入
        lrcScrollView.lrcName = currentMusic.lrcname
        
        //7添加更新歌词的定时器
        removeLrcTimer()
        addLrcTimer()
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

// MARK: - 歌曲进度的控制
extension PlayingViewController{
    
    /// 点击滑块的时候
    @IBAction func sliderTouchDown(){
        removeProgressTimer()       //移除定时器
    }

    /// 主要用于拖动滑块时同步修改current时间
    @IBAction func sliderValueChange(){
        let time = Double(progressSlider.value) * MusicTools.getDuration()
        currentTimeLabel.text = stringWithTime(time)
    }

    /// 点击/拖动滑块在Slider内松开手的时候
    @IBAction func sliderTouchUpInside(){
        let time = Double(progressSlider.value) * MusicTools.getDuration()
        MusicTools.setCurrentTime(time)
        addProgressTimer()      //添加新的定时器
    }
    
    /// 点击/拖动滑块在Slider外远距离松开手的时候
    @IBAction func sliderTouchUpOutside(){
        let time = Double(progressSlider.value) * MusicTools.getDuration()
        MusicTools.setCurrentTime(time)
        addProgressTimer()      //添加新的定时器
    }
    
    /// 点击Slider进度条的时候获取点击的点改变进度
    @IBAction func sliderTapGes(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: progressSlider)
        let ratio = point.x / progressSlider.bounds.width
        let time = Double(ratio) * MusicTools.getDuration()
        MusicTools.setCurrentTime(time)
        updateProgress()
    }
}

// MARK: - 操作定时器
extension PlayingViewController{
    
    /// 添加歌曲进度定时器
    fileprivate func addProgressTimer(){
        progressTimer = Timer(timeInterval: 1.0, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        RunLoop.main.add(progressTimer!, forMode: .commonModes)
    }
    
    /// 实时更新界面上的进度的方法
    @objc fileprivate func updateProgress(){
        currentTimeLabel.text = stringWithTime(MusicTools.getCurrentTime())
        progressSlider.value = Float(MusicTools.getCurrentTime() / MusicTools.getDuration())
    }
    
    /// 移除歌曲进度定时器
    fileprivate func removeProgressTimer(){
        progressTimer?.invalidate()
        progressTimer = nil
    }

    /// 添加歌词定时器
    fileprivate func addLrcTimer(){
        lrcTimer = CADisplayLink(target: self, selector: #selector(updateLrc))
        lrcTimer?.add(to: RunLoop.main, forMode: .commonModes)
    }

    /// 移除歌词定时器
    fileprivate func removeLrcTimer(){
        lrcTimer?.invalidate()
        lrcTimer = nil
    }
    
    /// 给歌词的当前时间传值
    @objc fileprivate func updateLrc(){
        lrcScrollView.currentTime = MusicTools.getCurrentTime()
    }
}

// MARK: - 更新歌曲(上一首/下一首/暂停/播放)
extension PlayingViewController{
    
    /// 下一首
    @IBAction func nextMusicBtnClick() {
        switchMusic(isNext : true)
    }
    
    /// 上一首
    @IBAction func previousMusicBtnClick() {
        switchMusic(isNext: false)
    }
    
    /// 切换歌曲(向下/向上)
    private func switchMusic(isNext : Bool){
        let currentIndex = musicList.index(of: currentMusic)!
        var index : Int = 0
        if isNext {
            index = currentIndex + 1
            index = index > musicList.count - 1 ? 0 : currentIndex + 1
        } else {
            index = currentIndex - 1
            index = index < 0 ? musicList.count - 1 : currentIndex - 1
        }
        currentMusic = musicList[index]
        startPlayingMusic()
        //切歌的时候,若按钮为暂停状态,恢复为播放,恢复动画
        if !playPauseButton.isSelected {
            playPauseButton.isSelected = !playPauseButton.isSelected
            iconImageView.layer.resumeAnim()
        }
    }
    
    /// 播放/暂停(暂停时移除动画, 恢复播放时重新添加)
    @IBAction func playOrPauseBtnClick(_ btn: UIButton) {
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            MusicTools.playMusic(currentMusic.filename)
            iconImageView.layer.resumeAnim()
        } else {
            MusicTools.pauseMusic()
            iconImageView.layer.pauseAnim()
        }
    }
    
}

// MARK: - 歌词ScrollView
extension PlayingViewController : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //设置透明度随滚动渐变
        let ratio = scrollView.contentOffset.x / scrollView.bounds.width
        iconImageView.alpha = 1 - ratio
        lrcLabel.alpha = 1 - ratio
        
    }
}



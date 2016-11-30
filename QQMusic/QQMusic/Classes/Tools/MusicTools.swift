//
//  MusicTools.swift
//  播放音乐
//
//  Created by Lenhulk on 2016/11/28.
//  Copyright © 2016年 Lenhulk. All rights reserved.
//

import UIKit
import AVFoundation

class MusicTools: NSObject {
    fileprivate static var player : AVAudioPlayer?
}

// MARK: - 对歌曲的控制
extension MusicTools{
    
    class func playMusic(_ musicName : String){
        //1 获取资源的URL
        guard let url = Bundle.main.url(forResource: musicName, withExtension: nil) else { return }
        
        //0 判断和暂停/停止的对象是否同一首歌曲(继续播放的时候不会切歌)
        if player?.url == url{
            player?.play()
            return
        }
        
        //2 根据URL创建AVAudioPlayer对象
        guard let audioPlayer = try? AVAudioPlayer(contentsOf: url) else { return }
        self.player = audioPlayer
        
        //3 播放音乐
        audioPlayer.play()
    }
    
    class func pauseMusic() {
        player?.pause()
    }
    
    class func stopMusic(){
        player?.stop()
        player?.currentTime = 0
    }
}

// MARK: - 对其他的控制(音量/时间/代理设置)
extension MusicTools{
    
    class func changeVolume(volume : Float){
        player?.volume = volume
    }
    
    class func setCurrentTime(_ currentTime : TimeInterval) {
        player?.currentTime = currentTime
    }
    
    class func getCurrentTime() -> TimeInterval{
        return player?.currentTime ?? 0
    }
    
    class func getDuration() -> TimeInterval{
        return player?.duration ?? 0
    }
    
    class func setPlayerDelegate(_ delegate : AVAudioPlayerDelegate){
        player?.delegate = delegate
    }
    
}











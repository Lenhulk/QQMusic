//
//  AppDelegate.swift
//  QQMusic
//
//  Created by Lenhulk on 2016/11/28.
//  Copyright © 2016年 Lenhulk. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        //开启后台播放功能
        let session = AVAudioSession.sharedInstance()
        
        do{
            //设置音频可以后台播放
            try session.setCategory(AVAudioSessionCategoryPlayback)
            //激活会话
            try session.setActive(true)
        } catch {
            print(error)
        }
        
        return true
    }

}


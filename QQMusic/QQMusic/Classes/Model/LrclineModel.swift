//
//  LrclineModel.swift
//  QQMusic
//
//  Created by Lenhulk on 2016/11/30.
//  Copyright © 2016年 Lenhulk. All rights reserved.
//

import UIKit

/// 处理"每行歌词"的歌词模型
class LrclineModel: NSObject {
    var lrcText : String = ""
    var lrcTime : TimeInterval = 0
    init(lrclineString : String) {
        let lrclineStrs = lrclineString.components(separatedBy: "]")    //前段时间 后段歌词
        lrcText = lrclineStrs[1]
        let lrclineTimeStr = lrclineStrs[0].components(separatedBy: "[")[1]
        
        let min = Double(lrclineTimeStr.components(separatedBy: ":")[0])!
        let sec = Double(lrclineTimeStr.components(separatedBy: ":")[1].components(separatedBy: ".")[0])!
        let msec = Double(lrclineTimeStr.components(separatedBy: ".")[1])!
        lrcTime = min * 60 + sec + msec * 0.01
    }
    
}

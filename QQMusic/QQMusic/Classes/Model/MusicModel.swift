//
//  MusicModel.swift
//  QQMusic
//
//  Created by Lenhulk on 2016/11/28.
//  Copyright © 2016年 Lenhulk. All rights reserved.
//

import UIKit

class MusicModel: NSObject {
    //曲名
    var name : String = ""
    //mp3文件名
    var filename : String = ""
    //歌词文件名
    var lrcname : String = ""
    //歌手名
    var singer : String = ""
    //封面图片名
    var icon : String = ""
    
    init(dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

//
//  LrcTools.swift
//  QQMusic
//
//  Created by Lenhulk on 2016/11/29.
//  Copyright © 2016年 Lenhulk. All rights reserved.
//

import UIKit

class LrcTools: NSObject {

}

extension LrcTools {
    class func parseLrc(_ lrcname : String) -> [String]? {
        //1 获取路径
        guard let path = Bundle.main.path(forResource: lrcname, ofType: nil) else { return nil }
        
        //2 读取路径中的内容
        guard let totalLrcString = try? String(contentsOfFile: path) else { return nil }
        
        //3 对字符串进行分割
        let lrclineStrings = totalLrcString.components(separatedBy: "\n")   //分割出每行歌词
        var lrclines : [String] = [String]()    //用于存放切割后的歌词
        for lrclineStr in lrclineStrings{
            //过滤不需要的内容
            if lrclineStr.contains("[ti:") || lrclineStr.contains("[ar:") || lrclineStr.contains("[al:") || !lrclineStr.contains("[") {
                continue
            }
            print(lrclineStr)
            //取出歌词
            lrclines.append(lrclineStr.components(separatedBy: "]")[1])
        }
        return lrclines
    }

    
    
}

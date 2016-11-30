//
//  LrcLabel.swift
//  QQMusic
//
//  Created by Lenhulk on 2016/11/30.
//  Copyright © 2016年 Lenhulk. All rights reserved.
//

import UIKit

class LrcLabel: UILabel {
    
    //单句歌词进度
    var progress : Double = 0{
        didSet{
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        //给字体绘色(渐变)
        UIColor.green.set()
        let drawRect = CGRect(x: 0, y: 0, width: rect.width * CGFloat(progress), height: rect.height)
        UIRectFillUsingBlendMode(drawRect, .sourceIn)
    }

}

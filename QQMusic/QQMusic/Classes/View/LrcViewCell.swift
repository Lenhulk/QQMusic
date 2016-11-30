//
//  LrcViewCell.swift
//  QQMusic
//
//  Created by Lenhulk on 2016/11/29.
//  Copyright © 2016年 Lenhulk. All rights reserved.
//

import UIKit

class LrcViewCell: UITableViewCell {
    
    lazy var lrcLabel : LrcLabel = LrcLabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(lrcLabel)
        
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        lrcLabel.textAlignment = .center
        lrcLabel.textColor = UIColor.white
        lrcLabel.font = UIFont.systemFont(ofSize: 14)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        lrcLabel.sizeToFit()
        lrcLabel.center = contentView.center
    }

}

//
//  LrcViewCell.swift
//  QQMusic
//
//  Created by Lenhulk on 2016/11/29.
//  Copyright © 2016年 Lenhulk. All rights reserved.
//

import UIKit

class LrcViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        textLabel?.textAlignment = .center
        textLabel?.textColor = UIColor.white
        textLabel?.font = UIFont.systemFont(ofSize: 14)
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

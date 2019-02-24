//
//  UIMaker.swift
//  Player
//
//  Created by 王申宇 on 2019/2/13.
//  Copyright © 2019 mac. All rights reserved.
//

import Foundation
import UIKit

/// @brief 控件生成器类
/// @author huangyibiao
/// @date 2014-10-22
class UIMaker {
    ///
    /// @brief 生成按钮
    ///
    class func button(imageName: String, target: AnyObject?, action: Selector) ->UIButton {
        var img = UIImage(named: imageName)
        var button = UIButton(type: UIButton.ButtonType.custom) as UIButton
        button.frame = CGRect(x:0,y: 0,width: img!.size.width, height: img!.size.height)
        button.addTarget(target, action: action, for: UIControl.Event.touchUpInside)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.imageView?.contentMode = UIView.ContentMode.scaleAspectFill
        return button
    }
    
    ///
    /// @brief 生成标签
    ///
    class func label(frame: CGRect, title: String?) ->UILabel {
        var label = UILabel(frame: frame)
        label.backgroundColor = UIColor.clear
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.text = title
        
        return label
    }
}

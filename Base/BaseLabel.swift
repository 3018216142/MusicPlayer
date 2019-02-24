//
//  BaseLabel.swift
//  Player
//
//  Created by 王申宇 on 2019/2/11.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class BaseLabel: UILabel {
    
    var progress : CGFloat = 0.0 {
        
        didSet{
            
            setNeedsDisplay()
        }
        
    }
    override func draw(_ rect: CGRect) {
        // 必须super
        super.draw(rect)
        UIColor.red.set()
        let newRect = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width * progress, height: rect.size.height)
        textColor = .white
        
        UIRectFillUsingBlendMode(newRect, .sourceIn)
    }
    
    
}

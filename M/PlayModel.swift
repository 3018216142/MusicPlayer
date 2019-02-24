//
//  PlayModel.swift
//  RealPlayer
//
//  Created by 王申宇 on 2019/2/14.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class PlayModel: NSObject {
    
    var musicPreTime : TimeInterval = 0.0{
        
        didSet{
            musicPreText = TimeTool.TimeConver(timeInterval: musicPreTime)
        }
    }
    
    var musicTotalTime : TimeInterval = 0.0{
        
        didSet{
            musicLastText = TimeTool.TimeConver(timeInterval: musicTotalTime)
        }
    }
    
    var musicLastTime : TimeInterval = 0.0
    
    var musicPreText : String? = "00:00"
    
    var musicLastText : String? = "00:00"
    
    
    
}


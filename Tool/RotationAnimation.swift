//
//  RotationAnimation.swift
//  RealPlayer
//
//  Created by 王申宇 on 2019/2/15.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class RotationAnimation: NSObject {
    
    class func RotationAnimation(layer : CALayer )  {
        layer.removeAllAnimations()
        layer.removeAnimation(forKey: "layerAnimation")
        ResumeAnimation(layer: layer)
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = Double.pi * 2
        animation.duration = 30
        animation.repeatCount = MAXFLOAT
        layer.add(animation, forKey: "layerAnimation")
        
    }
    
    /// 暂停动画
    class func PauseAnimation(layer : CALayer)  {
        let pauseTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        
        layer.speed = 0
        layer.timeOffset = pauseTime
    }
    
    /// 继续动画
    class func ResumeAnimation(layer :CALayer)  {
        let pauseTIme = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0;
        layer.beginTime = 0
        let pauseOffset = layer.convertTime(CACurrentMediaTime(), from: nil) - pauseTIme
        
        layer.beginTime = pauseOffset
        
        
    }
}

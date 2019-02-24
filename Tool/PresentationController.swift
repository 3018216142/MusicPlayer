//
//  PresentationController.swift
//  RealPlayer
//
//  Created by 王申宇 on 2019/2/17.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class PresentationController: UIPresentationController {
    
    
    /// 控制弹出控制器的大小
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView?.frame =  UIScreen.main.bounds
        presentedView?.isUserInteractionEnabled = true
        containerView?.isUserInteractionEnabled = true
        // let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        // 给弹出的试图添加手势
        //presentedView?.addGestureRecognizer(tap)
        // 给背景试图添加手势
        //containerView?.addGestureRecognizer(tap)
        
    }
}
extension PresentationController {
    
    func dismiss()  {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
}


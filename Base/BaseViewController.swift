//
//  ViewController.swift
//  Player
//
//  Created by 王申宇 on 2019/2/9.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import SnapKit

typealias btnClickBlock = (_ left : Bool)-> ()
class BaseViewController: UIViewController {
    
    var closeBlock : btnClickBlock?
    
    var moreBlock : btnClickBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}

extension BaseViewController {
    /// present一个控制器
    ///
    /// - Parameter vc: 要推出的控制器
    func PresentViewController(vc : UIViewController?)  {
        if vc != nil {
            self.present(vc!, animated: true, completion: {
                
            })
        }
    }
    func DismissViewController(vc : UIViewController?)  {
        if vc != nil {
            vc?.dismiss(animated: true, completion: {
                
            })
        }
    }
}

// MARK: - 设置类似于导航栏左右按钮
extension BaseViewController {
    
    func setNavigationItem(_ left : Bool , imageName : String , clickBlock : @escaping (_ left : Bool) -> ())  {
        
        self.closeBlock = clickBlock
        
        self.moreBlock = clickBlock
        
        let btn : UIButton = UIButton()
        view.addSubview(btn)
        if left {
            
            
            btn.snp.makeConstraints({ (make) in
                make.left.equalTo(view).offset(10)
                make.top.equalTo(view).offset(50)
                make.width.equalTo(50)
                make.height.equalTo(50)
            })
            btn.addTarget(self, action: #selector(leftBtnClick), for: UIControl.Event.touchUpInside)
            
        }
        else{
            btn.snp.makeConstraints({ (make) in
                make.right.equalTo(view).offset(-10)
                make.top.equalTo(view).offset(50)
                make.width.equalTo(50)
                make.height.equalTo(50)
            })
            btn.addTarget(self, action: #selector(rightBtnClick), for: UIControl.Event.touchUpInside)
            
        }
        
        btn.setImage(UIImage(named: imageName), for: UIControl.State.normal)
        
        view.bringSubviewToFront(btn)
    }
    
}

// MARK: - 按钮点击事件
extension BaseViewController {
    
    @objc fileprivate func leftBtnClick()  {
        if (self.closeBlock != nil) {
            closeBlock!(true)
        }
    }
    @objc fileprivate func rightBtnClick()  {
        if (self.moreBlock != nil) {
            self.moreBlock!(false)
        }
    }
}

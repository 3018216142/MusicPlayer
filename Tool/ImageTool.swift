//
//  ImageTool.swift
//  RealPlayer
//
//  Created by 王申宇 on 2019/2/14.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class ImageTool: NSObject {
    
    
    class func DraeLrcInImage(image : UIImage , lrc : String) -> UIImage {
        let size = image.size
        
        UIGraphicsBeginImageContext(size)
        
        let rect = CGRect(x:0, y: 0, width: size.width, height: size.height)
        image.draw(in: rect)
        
        // 设置属性，让文字居中
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        
        let attribute = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17) , NSAttributedString.Key.foregroundColor : UIColor.green , NSAttributedString.Key.paragraphStyle : style]
        
        (lrc as NSString).draw(in: rect, withAttributes: attribute)
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return resultImage!
        
    }
}


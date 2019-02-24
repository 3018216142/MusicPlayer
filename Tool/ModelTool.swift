//
//  ModelTool.swift
//  RealPlayer
//
//  Created by 王申宇 on 2019/2/17.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class ModelTool: NSObject {
    
    class func SCX_getMusicModel() -> (([MusicModel]) ) {
        guard let path = Bundle.main.path(forResource: "Musics.plist", ofType: nil) else {
            return  [MusicModel]()
        }
        guard let modelArr = NSArray(contentsOfFile: path)  else {
            return [MusicModel]()
        }
        var models = [MusicModel]()
        
        for dic in modelArr{
            let model = MusicModel(dic: dic as! [String : AnyObject])
            models.append(model)
        }
        return models
    }
    
}

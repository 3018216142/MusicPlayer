//
//  MusicModel.swift
//  RealPlayer
//
//  Created by 王申宇 on 2019/2/14.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

var lrcModels : [LrcModel]?

class MusicModel: NSObject{
    /** 歌曲名称 */
    var name: String?
    /** 歌曲文件名称 */
    var filename: String?
    /** 歌词文件名称 */
    var lrcname: String?
    /** 歌手名称 */
    var singer: String?
    /** 歌手头像名称 */
    var singerIcon: String?
    /** 专辑头像图片 */
    var icon: String?
    
    // 音乐模型，包括音乐播放时长，总时长，进度等
    var musicModel : PlayModel?
    
    // 歌词模型数组
    
    
    override init() {
        super.init()
    }
    
    init(dic : [String : AnyObject]) {
        super.init()
        setValuesForKeys(dic)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    /// 处理歌词，根据歌词名字找到文件，然后变成歌词，然后分解歌词，吧一个歌词字符串变成一个数组，然后再把这个歌词数组给tableview就变成一个歌词列表了
    class func SCX_UpdateLrcView(model : WordsOfSong) -> [LrcModel] {
        let url = "https://music.163.com/api/lyric?id=\(MusicFigure.id) "
        var lrc = ""
        do{
            lrc = try String(model.lrc.lyric)
        }catch{
            
            print(error)
            return [LrcModel]()
        }
        
        let lrecArr =  lrc.components(separatedBy: "\n")
        
        var lrcModelArr = [LrcModel]()
        // 便利拆分歌词
        for lrcIndex in lrecArr{
            
            // 首先处理歌词中无用的东西 // [ti:][ar:][al:]
            if lrcIndex.contains("[ti:") || lrcIndex.contains("[ar:") || lrcIndex.contains("[al:")  {
                continue
            }
            
            let lrcStr = lrcIndex.replacingOccurrences(of: "[", with: "")
            
            let lrcResultArr = lrcStr.components(separatedBy: "]")
            
            
            let lrcModel = LrcModel()
            
            let timeStr = lrcResultArr.first
            let time = TimeTool.ConverTimeStrToTime(timeStr: timeStr)
            
            lrcModel.LrcBeginTime = time
            lrcModel.LrcContent = lrcResultArr.last
            lrcModelArr.append(lrcModel)
        }
        lrcModels = lrcModelArr
        // 第一个歌词的结束时间是第二个的开始时间
        for i in 0..<lrcModelArr.count {
            
            if i == lrcModelArr.count - 1 {
                continue
            }
            let  preLrcModel = lrcModelArr[i]
            let nextModel = lrcModelArr[i + 1]
            preLrcModel.LrcEndTime = nextModel.LrcBeginTime
            
        }
        return lrcModelArr
        
    }
    
}

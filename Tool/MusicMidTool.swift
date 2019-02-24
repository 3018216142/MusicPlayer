//
//  MusicMidTool.swift
//  RealPlayer
//
//  Created by 王申宇 on 2019/2/14.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import MediaPlayer
class MusicMidTool: NSObject {
    
    // 单例
    static let shareInstance = MusicMidTool()
    
    // 歌曲模型
    var models = [MusicModel]()
    
    /// 当前歌词
    var currentLrc : String? = ""
    
    var artWorkItem : MPMediaItemArtwork?
    
    
    var currentIndex = -1{
        
        didSet{
            
            if currentIndex < 0  {
                currentIndex = models.count - 1
            }
            if currentIndex > models.count - 1 {
                
                currentIndex = 0
            }
            
        }
        
    }
    
    //MARK: -这部分没用
    /// 播放音乐
    func PlayMusic(model : MusicModel)  {

        let name = model.filename
        guard name != nil else {
            return
        }

        currentIndex = models.index(of: model)!

        PlayTool.shareInstance.PlayMusic(name: name!)

    }

    /// 播放音乐
    func PlayCurrentMusic()  {

        let model = models[currentIndex]
        guard model.filename != nil else {
            return
        }

        PlayTool.shareInstance.PlayMusic(name: model.filename!)

    }

    /// 暂停音乐
    func PauseMusic()  {
        if currentIndex < 0 {
            return
        }

        let model = models[currentIndex]
        guard model.filename != nil else {
            return
        }
        PlayTool.shareInstance.SCX_PauseMusic()


    }

    /// 下一曲
    func NextMusic()  {

        currentIndex += 1
        let model =  models[currentIndex]

        PlayTool.shareInstance.PlayMusic(name: model.filename!)


    }

    /// 上一曲
    func SCX_PreMusic()  {

        currentIndex -= 1
        let model =  models[currentIndex]

        PlayTool.shareInstance.PlayMusic(name: model.filename!)
    }
    
    /// 将播放器seek到某个时间
    func SCX_SeekToTime(time : TimeInterval)  {
        PlayTool.shareInstance.SCX_SeekToTime(time: time)
    }
    
    /// 获取音乐的播放进度
    func updatePlayModel() -> (MusicModel) {
        // 容错，防止第一次进来的时候，没有播放歌曲，插入了耳机，那么没有index
        if currentIndex < 0 {
            
            return MusicModel()
            
        }
        let model : MusicModel = models[currentIndex]
        if model.musicModel == nil {
            model.musicModel = PlayModel()
        }
        let musicModel = model.musicModel
        musicModel?.musicPreTime = (PlayTool.shareInstance.player?.currentTime)!
        musicModel?.musicTotalTime = (PlayTool.shareInstance.player?.duration)!
        return model
        
    }
    
    /// 获取实时对应的那个歌词
    
    class func SCX_updateCurrentLrc(models : [LrcModel]) -> LrcModel? {
        let currentTime = PlayTool.shareInstance.player?.currentTime
        // 当前播放时间的
        for model in models {
            if model.LrcBeginTime < currentTime! && currentTime! < model.LrcEndTime {
                
                return model
            }
        }
        return LrcModel()
        
    }
    
    func MusicBackgroundConfig()  {
        
        
        // 获取锁屏中心
        let center = MPNowPlayingInfoCenter.default()
        // MPMediaItemPropertyAlbumTitle       专辑标题
        // MPMediaItemPropertyAlbumTrackCount  专辑歌曲数
        // MPMediaItemPropertyAlbumTrackNumber 专辑歌曲编号
        // MPMediaItemPropertyArtist           艺术家/歌手
        // MPMediaItemPropertyArtwork          封面图片 MPMediaItemArtwork类型
        // MPMediaItemPropertyComposer         作曲
        // MPMediaItemPropertyDiscCount        专辑数
        // MPMediaItemPropertyDiscNumber       专辑编号
        // MPMediaItemPropertyGenre            类型/流派
        // MPMediaItemPropertyPersistentID     唯一标识符
        // MPMediaItemPropertyPlaybackDuration 歌曲时长  NSNumber类型
        // MPMediaItemPropertyTitle            歌曲名称
        // MPNowPlayingInfoPropertyElapsedPlaybackTime
        let model = models[currentIndex]
        
        let albumTitle = model.name ?? ""
        let artist = model.singer ?? ""
        let artwork = model.icon ?? ""
        let elapsedPlaybackTime = PlayTool.shareInstance.player?.currentTime ?? 0.0
        let durtion = PlayTool.shareInstance.player?.duration ?? 0.0
        
        // 获取歌词
        var lrc : LrcModel? = nil
        if lrcModels != nil {
            lrc = MusicMidTool.SCX_updateCurrentLrc(models: lrcModels!)!
            
        }
        else{
            
        }
        
        
        // 初始图片
        let artImage = UIImage(named: artwork)
        var lrcImage : UIImage?
        if currentLrc != lrc?.LrcContent && artImage != nil && lrc != nil && lrc?.LrcContent != nil {
            currentLrc = lrc?.LrcContent
            // 将歌词画到图片上面去
            lrcImage = ImageTool.DraeLrcInImage(image: artImage!, lrc: (lrc?.LrcContent)!)
        }
        
        
        if lrcImage != nil {
            // 必须将这个变量设置为全局，如果不设置为全局的时候，第二次进来，因为歌词没有改变，所以不走这个方法，呢么就不能绘制图片，这个参数就为空，那么锁屏界面就显示不了图片了
            artWorkItem = MPMediaItemArtwork(image: lrcImage!)
        }
        
        let infoDic :NSMutableDictionary  = [MPMediaItemPropertyAlbumTitle : albumTitle ,
             MPMediaItemPropertyArtist : artist ,
             MPNowPlayingInfoPropertyElapsedPlaybackTime : elapsedPlaybackTime ,
             MPMediaItemPropertyPlaybackDuration : durtion
        ]
        if artWorkItem != nil {
            infoDic.setValue(artWorkItem, forKey: MPMediaItemPropertyArtwork)
        }
        let playInfo = infoDic.copy()
        
        center.nowPlayingInfo = playInfo as? [String : Any]
        // 开始接受远程事件
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        
    }
    
}


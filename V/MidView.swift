//
//  MidView.swift
//  RealPlayer
//
//  Created by 王申宇 on 2019/2/15.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class XMidView: UIScrollView {
    
    var MidIconView = IconView()
    
    var SCX_Mid_LrcView = LrcView(style: .plain)
    
    var SCX_IconName : String?
    
    var SCX_MusicModel : MusicModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        
        showsHorizontalScrollIndicator = false
        
        isPagingEnabled = true
        
        contentSize = CGSize(width: ScreenWidth * 2, height: 0)
        
        //  专辑图片试图配置
        MidIconView = IconView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        addSubview(MidIconView)
        
        // 歌词试图配置
        SCX_Mid_LrcView.SCX_SetUpLrcTableViewFrame(frame: CGRect(x: ScreenWidth, y: 0, width: frame.size.width, height: frame.size.height))
        SCX_Mid_LrcView.tableView.allowsSelection = false
        SCX_Mid_LrcView.tableView.backgroundColor = .clear
        SCX_Mid_LrcView.tableView.separatorStyle = .none
        SCX_Mid_LrcView.tableView.contentInset = UIEdgeInsets(top: frame.size.height / 2, left: 0, bottom: frame.size.height / 2, right: 0)
        addSubview(SCX_Mid_LrcView.view)
    }
    
    /// 更新歌词试图
    func SCX_UpdateLrcView(model : MusicModel)  {
        
        let mdl: WordsOfSong
        var  lrcArr = [LrcModel]()
        if (lrcModels?.count)! > 0 {
            lrcArr  = lrcModels!
        }
        else{
            // 获取这首歌所有歌词，然后把每一句歌词转化为一个模型，存到数组，然后得到这个歌词数组
            func update1(model: WordsOfSong){
                lrcArr =  MusicModel.SCX_UpdateLrcView(model: model)
            }
        }
        
        // 这区这一行歌词的模型
        let lrc = MusicMidTool.SCX_updateCurrentLrc(models: lrcArr)
        
        // 歌词实时变化当前时间
        let currentTime = model.musicModel?.musicPreTime
        // 歌词开始时间
        let beginTime = lrc?.LrcBeginTime
        // 歌词结束的时间
        let endTime = lrc?.LrcEndTime
        
        if currentTime != nil && beginTime != nil && endTime != nil {
            // 计算本句歌词走过的时长
            let time = currentTime! - beginTime!
            let timeAll = endTime! - beginTime!
            let progress = time / timeAll
            
            // 实时更新专辑界面的歌词
            func updateCurrentLrc(model: WordsOfSong){
                MidIconView.SCX_UpdateCurrentLrc(model: model, progress: CGFloat( progress + 0.1))
            }
            if lrc?.LrcContent != nil {
                
                // 实时更新歌词界面的歌词，让tableView滚动
                SCX_Mid_LrcView.Lrc_Index = lrcArr.index(of: lrc!)!
                
                SCX_Mid_LrcView.lrcProgress = CGFloat(progress)
            }
        }
        
        
        
        
        
        
    }
    
    /// 更新中间试图
    func SCX_UpdateMidView(model : MusicModel) {
        
        SCX_MusicModel = model
        SCX_IconName = model.icon
        func setUpView(model: SongDetail, index: Int){
            MidIconView.SCX_SetUpView(model: model, withIndex: index)
        }
    }
    // 更新歌词界面的歌词
    func update(model: WordsOfSong){
        let lrcArr = MusicModel.SCX_UpdateLrcView(model: model)
        SCX_Mid_LrcView.lrcModels = lrcArr
    }
    func SCX_UpdateMidView1(model : MusicModel){
        SCX_UpdateLrcView(model: model)
    }
    
    func IconAnimation(rotationType: RotationType) {
        MidIconView.IconAnimation(rotationType: rotationType)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
}


extension XMidView : UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let spreed = contentOffset.x / ScreenWidth
        
        MidIconView.alpha = 1 - spreed
        
        SCX_Mid_LrcView.tableView.alpha = spreed
        
    }
    
}




//
//  BottomView.swift
//  RealPlayer
//
//  Created by 王申宇 on 2019/2/14.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import MediaPlayer

enum RotationType {
    case begin
    case pause
    case resume
}

class BottomView: UIView {
    lazy var BPreTimeLabel : UILabel = UILabel()
    
    lazy var BLastTimeLabel : UILabel = UILabel()
    
    lazy var BProgressView : UISlider = UISlider()
    
    lazy var BPreMusicBtn : UIButton = UIButton()
    
    lazy var BNextMusicBtn : UIButton = UIButton()
    
    lazy var BPalyBtn : UIButton = UIButton()
    
    var delegate : BottomViewDelegate?
    
    /// 各个控件参数
    var BPreTime : String? = "00:00"{
        
        didSet{
            
            BPreTimeLabel.text = BPreTime
        }
        
    }
    
    var BNextTime : String? = "00:00"{
        
        didSet{
            
            BLastTimeLabel.text = BNextTime
            
        }
        
    }
    
    var BPregress : Float = 0{
        
        didSet{
            
            BProgressView.value = BPregress
            
        }
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        commomSetUp()
        
    }
    
    /// 更新底部视图
    func XUpdateBottomView(model : MusicModel , play : Bool)  {
        
        BPalyBtn.isSelected = play
        if model.musicModel?.musicPreText == nil || model.musicModel?.musicPreText == "" {
            model.musicModel?.musicPreText = "00:00"
        }
        if model.musicModel?.musicLastText == nil || model.musicModel?.musicLastText == "" {
            model.musicModel?.musicLastText = "00:00"
        }
        
        BPreTime = model.musicModel?.musicPreText
        BNextTime = model.musicModel?.musicLastText
        BPreTimeLabel.text = BPreTime
        BLastTimeLabel.text = BNextTime
        if model.musicModel?.musicPreTime == nil {
            
            BPregress = 0
            
        }
        else{
            
            BPregress = Float( (model.musicModel?.musicPreTime)!) / Float((model.musicModel?.musicTotalTime)!)
        }
        
        BProgressView.value = BPregress
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - 初始化设置
extension BottomView{
    
    
    /// 基本配置
    func commomSetUp()  {
        
        // 添加试图到self上面
        addSubview(BPreTimeLabel)
        addSubview(BProgressView)
        addSubview(BLastTimeLabel)
        addSubview(BPreMusicBtn)
        addSubview(BPalyBtn)
        addSubview(BNextMusicBtn)
        
        // MARK: - 文件基本配置
        BPreTimeLabel.textColor = .white
        BLastTimeLabel.textColor = .white
        BPreTimeLabel.font = .systemFont(ofSize: 10)
        BLastTimeLabel.font = .systemFont(ofSize: 10)
        BPreTimeLabel.text = BPreTime
        BLastTimeLabel.text = BNextTime
        
        BProgressView.setThumbImage(UIImage(named: "player_slider_playback_thumb"), for: .normal)
        BProgressView.tintColor = .green
        // 值改变的时候
        BProgressView.addTarget(self, action: #selector(valueChange), for: .valueChanged)
        // 天机手势
        BProgressView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGesture(tap:))))
        // MARK: - 设置按钮图片
        BPreMusicBtn.setImage(UIImage(named:"player_btn_pre_highlight"), for: .highlighted)
        BPreMusicBtn.setImage(UIImage(named:"player_btn_pre_normal"), for: .normal)
        BPalyBtn.setImage(UIImage(named:"player_btn_play_highlight"), for: .highlighted)
        BPalyBtn.setImage(UIImage(named:"player_btn_pause_normal"), for: .selected)
        BPalyBtn.setImage(UIImage(named:"player_btn_play_normal"), for: .normal)
        
        BNextMusicBtn.setImage(UIImage(named:"player_btn_next_normal"), for: .normal)
        BNextMusicBtn.setImage(UIImage(named:"player_btn_next_highlight"), for: .highlighted)
        
        // MARK: - 添加点击事件
        BPalyBtn.addTarget(self, action: #selector(PlayMusic(btn:)), for: .touchUpInside)
        BPreMusicBtn.addTarget(self, action: #selector(preMusic), for: .touchUpInside)
        BNextMusicBtn.addTarget(self, action: #selector(nextMusic), for: .touchUpInside)
    }
    
}

// MARK: - 按钮点击事件
extension BottomView{
    
    
    /// 播放或者暂停音乐
    @objc fileprivate func PlayMusic(btn : UIButton)  {
        
        BPalyBtn.isSelected = !BPalyBtn.isSelected
        
        if !BPalyBtn.isSelected {
            // 暂停音乐
            MusicMidTool.shareInstance.PauseMusic()
            delegate?.ModelChange(play: false , rotationType: .pause)
        }
        else{
            
            // 播放音乐
            print("播放音乐")
            MusicMidTool.shareInstance.PlayCurrentMusic()
            delegate?.ModelChange(play: true , rotationType: .resume)
            
        }
        
        
    }
    
    /// 下一曲
    @objc fileprivate func nextMusic()  {
        
        BPalyBtn.isSelected = true
        
        MusicMidTool.shareInstance.NextMusic()
        
        delegate?.ModelChange(play: true , rotationType: .begin)
        
    }
    
    /// 上一曲
    @objc fileprivate func preMusic()   {
        
        BPalyBtn.isSelected = true
        
        MusicMidTool.shareInstance.SCX_PreMusic()
        
        delegate?.ModelChange(play: true , rotationType: .begin)
        
    }
}

// MARK: - 处理进度条相关事件，来处理进度
extension BottomView{
    
    
    /// 进度条值改变的时候
    @objc func valueChange()  {
        
        // 获取当前进度条的值
        let value = BProgressView.value
        HandlePlayerTimer(value: CGFloat(value))
        
    }
    /// 点击手势的时候
    @objc func tapGesture(tap : UITapGestureRecognizer)  {
        
        /// 获取手指在slider上面的位置
        let point = tap.location(in: BProgressView)
        let touch_X = point.x
        
        // 相对于slider的比例
        let value = touch_X / BProgressView.frame.size.width
        BProgressView.value = Float(value)
        HandlePlayerTimer(value: value)
    }
    func HandlePlayerTimer(value : CGFloat)  {
        // 获取当前音乐model
        let currentModel = MusicMidTool.shareInstance.updatePlayModel()
        
        //计算进度条相对于总时间的进度
        let currentTime = (currentModel.musicModel?.musicTotalTime)! * TimeInterval(value)
        
        // 赋值给模型
        currentModel.musicModel?.musicPreTime = currentTime
        
        // 获取已经播放的时间字符串
        BPreTime = currentModel.musicModel?.musicPreText
        
        // 给label赋值
        BPreTimeLabel.text = BPreTime
        
        // 将播放器定位到制定时间
        MusicMidTool.shareInstance.SCX_SeekToTime(time: currentTime)
    }
    
}



/// 底部试图代理方法
protocol BottomViewDelegate{
    
    func ModelChange(play : Bool , rotationType : RotationType)
    
}

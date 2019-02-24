//
//  DetailViewController.swift
//  RealPlayer
//
//  Created by 王申宇 on 2019/2/15.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import MediaPlayer
class DetailViewController: BaseViewController {
    static let shareInstance = DetailViewController()
    
    /// 记录手指的位置，用来判断上下滑动来关闭界面
    var originPoint : CGPoint = CGPoint.zero
    var firstPoint : CGPoint = CGPoint.zero
    var secondPoint : CGPoint = CGPoint.zero
    var offset : CGFloat = 0.0
    
    var XMusicModel : MusicModel?
    
    var  XtopView : TopView = TopView()
    
    var  XMidVIew : XMidView = XMidView()
    
    var  XBottomView : BottomView = BottomView()
    
    /// 监听播放状态定时器
    var timer : Timer?
    
    /// 实时更新歌词
    var lrcLink : CADisplayLink?
    
    
    
    
    
    init() {
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        
        
        XsetUpBackView()
        
        XsetUpButton()
        
        XsetUpTopMidAndBottomView()
        
        configBackCommond()
        
        // 监听播放完成通知，自动播放下一首
        NotificationCenter.default.addObserver(self, selector: #selector(XPlayerDidFinish), name: Notification.Name(rawValue : "SCX_PlayFinishNotificationKey"), object: nil)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 添加定时器，监听时刻改变的label
        timer = Timer(timeInterval: 1, target: self, selector: #selector(SCX_moniorPlaytime), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
        
        // 实时更新歌词
        lrcLink = CADisplayLink(target: self, selector: #selector(SCX_moniorPlayLrc))
        lrcLink?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
        
        // 更新一下界面
        XupdateDetailView(model: XMusicModel!, play: true, rotationType: .begin)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
        
        lrcLink?.invalidate()
        lrcLink = nil
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue : "SCX_PlayFinishNotificationKey"), object: nil)
    }
}

// MARK: - 设置界面
extension DetailViewController {
    
    
    /// 设置背景图片
    fileprivate func XsetUpBackView()  {
        
        let imageView : UIImageView = UIImageView(frame: view.bounds)
        let image : UIImage = UIImage(named: "dzq@2x.jpg")!
        imageView.image = image
        imageView.isUserInteractionEnabled = true
        let blur : UIBlurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurView : UIVisualEffectView = UIVisualEffectView(effect: blur)
        blurView.frame = view.frame;
        blurView.alpha = 1
        imageView .addSubview(blurView)
        view.isUserInteractionEnabled = true
        //view.addSubview(imageView)
        view = imageView
        
        
    }
    
    /// 设置界面上的按钮
    fileprivate func XsetUpButton()  {
        setNavigationItem(true, imageName: "miniplayer_btn_playlist_close") { (left) in
            if left {
                // 闭包里面使用方法一定前面要加self
                self.DismissViewController(vc: self)
            }
            else{
                print("点击更多了")
            }
        }
    }
    
    /// 设置上中下试图
    fileprivate func XsetUpTopMidAndBottomView()  {
        
        XsetTopView()
        
        XsetMidView()
        
        XsetBottomView()
        
    }
    
    /// 创建头部试图
    fileprivate func XsetTopView()  {
        
        let topView = TopView(frame: CGRect(x: 0, y: 0, width: ScreenWidth , height: ScreenHeight / 5))
        XtopView = topView
        //SCX_UpdateTopView(model: SCX_Music_Model!)
        view.addSubview(topView)
        
    }
    
    /// 更新头部试图
    func XUpdateTopView(model :SongDetail)  {
        
        XtopView.XupdateTopView(byModel: model, withIndex: MusicFigure.id)
        
    }
    
    fileprivate func XsetMidView()  {
        let midView = XMidView(frame: CGRect(x: 0, y: ScreenHeight / 5, width: ScreenWidth, height: ScreenHeight / 5 * 3))
        XMidVIew = midView
        //SCX_UpdateMidView(model: SCX_Music_Model!)
        view.addSubview(midView)
    }
    
    /// 更新中间试图
    func XUpdateMidView(model :MusicModel) {
        
        XMidVIew.SCX_UpdateMidView(model: model)
        
    }
    
    /// 更新歌词试图
    func XUpdateLrc(model :MusicModel)  {
        XMidVIew.SCX_UpdateLrcView(model: model)
    }
    
    
    
    fileprivate func XsetBottomView()  {
        let bottomView  = BottomView(frame: CGRect(x: 0, y: ScreenHeight / 5 * 4, width: ScreenWidth, height: ScreenHeight / 5))
        bottomView.delegate = self
        XBottomView = bottomView
        //SCX_UpdateBottomView(model: SCX_Music_Model!)
        view.addSubview(bottomView)
        
    }
    
    /// 更新底部试图
    func XUpdateBottomView(model : MusicModel , play : Bool)  {
        
        XBottomView.XUpdateBottomView(model: model, play: play)
        
    }
    
    
}

// MARK: - 手势事件
extension DetailViewController :UIGestureRecognizerDelegate {
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touchPoint = touches.first?.location(in: view)
        originPoint = touchPoint!
        firstPoint = originPoint
        offset = 0
        if (touches.first?.view?.isKind(of: UIButton.self))! {
            DismissViewController(vc: self)
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        secondPoint = (touches.first?.location(in: view))!
        let offset1 = secondPoint.y - originPoint.y;
        offset = offset1;
        if view.frame.origin.y  < 300 && offset1 > 0 {
            view.frame.origin.y += offset
        }
        if view.frame.origin.y  > 300 && offset1 > 0 {
            DismissViewController(vc: self)
        }
        firstPoint = secondPoint;
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if view.frame.origin.y < 300 {
            view.frame.origin.y = 0
        }
        secondPoint = CGPoint.zero
        firstPoint = CGPoint.zero
        offset = 0
    }
    
}

// MARK: - bottomView代理方法,更新model了
extension DetailViewController: BottomViewDelegate{
    
    func ModelChange(play: Bool, rotationType: RotationType) {
        let model = MusicMidTool.shareInstance.updatePlayModel()
        XMusicModel = model
        
        XupdateDetailView(model: model, play: play, rotationType: rotationType)
        
    }
    
}
extension DetailViewController{
    
    /// 实时更新本界面，很重要的方法
    func XupdateDetailView(model : MusicModel , play : Bool , rotationType : RotationType )  {
        func UpdateTopView(byModel songDetails: SongDetail){
            XUpdateTopView(model: songDetails)
        }
        XUpdateMidView(model: model)
        XUpdateBottomView(model: model , play: play)
        
        switch rotationType {
        case .begin:
            XMidVIew.IconAnimation(rotationType: .begin)
        case .pause :
            XMidVIew.IconAnimation(rotationType: .pause)
        case .resume:
            XMidVIew.IconAnimation(rotationType: .resume)
        default:
            break
        }
        
        
    }
    
}

// MARK: - 添加定时器时刻监听播放进度
extension DetailViewController{
    
    
    /// 时刻监听播放进度
    @objc func SCX_moniorPlaytime()  {
        let model = MusicMidTool.shareInstance.updatePlayModel()
        XUpdateBottomView(model: model, play: XBottomView.BPalyBtn.isSelected)
    }
    
    /// 实时监听歌词
    @objc func SCX_moniorPlayLrc()  {
        
        XUpdateLrc(model: XMusicModel!)
        
        
        // 实时监听远程事件，控制锁屏界面, 只有在后台的时候才监听
        if UIApplication.shared.applicationState == .background {
            MusicMidTool.shareInstance.MusicBackgroundConfig()
        }
        
        
    }
    
}
extension DetailViewController{
    
    
    /// 播放完成
    @objc func XPlayerDidFinish()  {
        MusicMidTool.shareInstance.NextMusic()
        let model = MusicMidTool.shareInstance.updatePlayModel()
        XMusicModel = model
        XupdateDetailView(model: model, play: true, rotationType: .begin)
    }
    
}

// MARK: - 实时监控远程事件,处理歌曲的播放暂停
extension DetailViewController{
    
    /* // 不包含任何子事件类型
     UIEventSubtypeNone                              = 0,
     
     // 摇晃事件（从iOS3.0开始支持此事件）
     UIEventSubtypeMotionShake                       = 1,
     
     //远程控制子事件类型（从iOS4.0开始支持远程控制事件）
     //播放事件【操作：停止状态下，按耳机线控中间按钮一下】
     UIEventSubtypeRemoteControlPlay                 = 100,
     //暂停事件
     UIEventSubtypeRemoteControlPause                = 101,
     //停止事件
     UIEventSubtypeRemoteControlStop                 = 102,
     //播放或暂停切换【操作：播放或暂停状态下，按耳机线控中间按钮一下】
     UIEventSubtypeRemoteControlTogglePlayPause      = 103,
     //下一曲【操作：按耳机线控中间按钮两下】
     UIEventSubtypeRemoteControlNextTrack            = 104,
     //上一曲【操作：按耳机线控中间按钮三下】
     UIEventSubtypeRemoteControlPreviousTrack        = 105,
     //快退开始【操作：按耳机线控中间按钮三下不要松开】
     UIEventSubtypeRemoteControlBeginSeekingBackward = 106,
     //快退停止【操作：按耳机线控中间按钮三下到了快退的位置松开】
     UIEventSubtypeRemoteControlEndSeekingBackward   = 107,
     //快进开始【操作：按耳机线控中间按钮两下不要松开】
     UIEventSubtypeRemoteControlBeginSeekingForward  = 108,
     //快进停止【操作：按耳机线控中间按钮两下到了快进的位置松开】
     UIEventSubtypeRemoteControlEndSeekingForward    = 109,
     */
    override func remoteControlReceived(with event: UIEvent?) {
        let type = event?.subtype
        var play : Bool = true
        var animationBegin : Bool = true
        
        
        switch type! {
        case .remoteControlPlay:
            print("播放")
            MusicMidTool.shareInstance.PlayMusic(model: XMusicModel!)
            play = true
            animationBegin = true
            
        case .remoteControlPause:
            print("暂停")
            MusicMidTool.shareInstance.PauseMusic()
            play = false
            animationBegin = false
            
        case .remoteControlNextTrack:
            print("下一首")
            MusicMidTool.shareInstance.NextMusic()
            play = true
            animationBegin = true
            
        case .remoteControlPreviousTrack:
            print("上一首")
            MusicMidTool.shareInstance.SCX_PreMusic()
            play = true
            animationBegin = true
        // 处理耳机线控
        case .remoteControlTogglePlayPause:
            if (PlayTool.shareInstance.player?.isPlaying)! {
                print("暂停")
                MusicMidTool.shareInstance.PauseMusic()
                play = false
                animationBegin = false
            }
            else{
                
                print("播放")
                MusicMidTool.shareInstance.PlayMusic(model: XMusicModel!)
                play = true
                animationBegin = true
            }
            
        case .remoteControlBeginSeekingForward:
            PlayTool.shareInstance.player?.currentTime += 3
            print("快进开始")
        case .remoteControlBeginSeekingBackward:
            PlayTool.shareInstance.player?.currentTime -= 3
            print("快退开始")
        case .remoteControlEndSeekingBackward:
            print("快退结束")
        case .remoteControlEndSeekingForward:
            print("快进结束")
        default:
            print("nono")
        }
        let model = MusicMidTool.shareInstance.updatePlayModel()
        XMusicModel = model
        
        if animationBegin {
            XupdateDetailView(model: model, play: play, rotationType: .resume)
            
        }
        else{
            XupdateDetailView(model: model, play: play, rotationType: .pause)
        }
        
        
    }
    
    
}
extension DetailViewController{
    
    /// 锁屏界面上的按钮设置
    func configBackCommond()  {
        let command = MPRemoteCommandCenter.shared()
        command.likeCommand.isEnabled = true
        command.likeCommand.addTarget(self, action: #selector(Xlike))
        command.likeCommand.localizedTitle = "喜欢"
        command.likeCommand.isActive = true
        
        command.dislikeCommand.isEnabled = true
        command.dislikeCommand.addTarget(self, action: #selector(XUnlike))
        command.dislikeCommand.localizedTitle = "不喜欢"
        command.dislikeCommand.isActive = true
        
        command.playCommand.isEnabled = true
        
        
        let playCommond : MPRemoteCommand = command.playCommand
        playCommond.isEnabled = true
        // playCommond.addTarget(self, action: #selector(SCX_handleRemote))
        
        let pauseCommond : MPRemoteCommand = command.pauseCommand
        pauseCommond.isEnabled = true
        
        pauseCommond.addTarget(self, action: #selector(play))
        
        let nextCommond : MPRemoteCommand = command.nextTrackCommand
        nextCommond.isEnabled = true
        
        nextCommond.addTarget(self, action: #selector(play))
    }
    
    /// 这个方法只是个中间方法，如果不写的话按钮不显示
    @objc func play()  {
        
    }
    @objc func Xlike() {
        print("喜欢,先用暂停代理")
        MusicMidTool.shareInstance.PauseMusic()
        let model = MusicMidTool.shareInstance.updatePlayModel()
        XMusicModel = model
        XupdateDetailView(model: model, play: false, rotationType: .pause)
    }
    @objc func XUnlike()  {
        print("不喜欢,先用上一曲代替")
        MusicMidTool.shareInstance.SCX_PreMusic()
        let model = MusicMidTool.shareInstance.updatePlayModel()
        XMusicModel = model
        XupdateDetailView(model: model, play: true, rotationType: .begin)
    }
    
}







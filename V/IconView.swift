//
//  IconView.swift
//  RealPlayer
//
//  Created by 王申宇 on 2019/2/15.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

let ScreenWidth = UIScreen.main.bounds.size.width

let ScreenHeight = UIScreen.main.bounds.size.height

class IconView: UIView {
    
    lazy var SCX_mid_imageView = UIImageView()
    
    lazy var SCX_mid_textLabel : BaseLabel = BaseLabel()
    
    var SCX_musicModel : MusicModel?
    
    func didSet(byModel songDetails: SongDetail, withIndex index: Int){
        
        var SCX_mid_imageName : String?{
        
            didSet{
            
                SCX_mid_imageView.sd_setImage(with: URL(string: songDetails.songs[index].artists[index].imglvlUrl!), completed: nil )
            
            }
        
        }
        var SCX_mid_text : String? = "告白气球"{
            
            didSet{
                
                SCX_mid_textLabel.text = songDetails.songs[index].name
                
            }
            
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(SCX_mid_imageView)
        addSubview(SCX_mid_textLabel)
        SCX_mid_textLabel.textColor = .white
        SCX_mid_textLabel.font = .systemFont(ofSize: 15)
        SCX_mid_imageView.layer.cornerRadius = (ScreenWidth - 20) / 2
        SCX_mid_imageView.layer.masksToBounds = true
        
    }
    func IconAnimation(rotationType: RotationType) {
        switch rotationType {
        case .begin:
            RotationAnimation.RotationAnimation(layer:  SCX_mid_imageView.layer)
        case .pause:
            RotationAnimation.PauseAnimation(layer:  SCX_mid_imageView.layer)
        default:
            RotationAnimation.ResumeAnimation(layer:  SCX_mid_imageView.layer)
        }
        
    }
    
    /// 实时更新歌词
    
    func SCX_UpdateCurrentLrc(model : WordsOfSong , progress : CGFloat)  {
        
        // 实时对应的歌词
        //SCX_mid_text = model.lrc.lyric
        SCX_mid_textLabel.text = model.lrc.lyric
        
        SCX_mid_textLabel.progress = progress
        
        
    }
    func SCX_SetUpView(model : SongDetail, withIndex index: Int)  {
        //SCX_musicModel = model
        //SCX_mid_imageName = model.icon;
        // 实时对应的歌词
        //SCX_mid_text = model.songs[index].name
        SCX_mid_textLabel.text = model.songs[index].name
        
        SCX_mid_imageView.sd_setImage(with: URL(string: model.songs[index].artists[index].imglvlUrl!), completed: nil )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        SCX_mid_imageView.snp.makeConstraints { (make) in
            make.width.equalTo(ScreenWidth - 20)
            make.left.equalTo(self).offset(10)
            make.height.equalTo(SCX_mid_imageView.snp.width)
            make.top.equalTo(self)
        }
        
        SCX_mid_textLabel.snp.makeConstraints { (make) in
            make.top.equalTo(SCX_mid_imageView.snp.bottom).offset(10)
            make.centerX.equalTo(self)
            
        }
        
    }
}




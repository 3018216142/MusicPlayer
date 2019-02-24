//
//  TopView.swift
//  RealPlayer
//
//  Created by 王申宇 on 2019/2/16.
//  Copyright © 2019 mac. All rights reserved.
//
import UIKit

class TopView: UIView {
    
    
    /// 头部歌曲名字Label
    lazy var TopMusicNameLabel : UILabel = UILabel()
    
    /// 头部作者名字Label
    lazy var TopNameLabel : UILabel = UILabel()
    
    /// 头部歌曲名字
    var TopMusicName : String?{
        didSet{
            TopMusicNameLabel.text = TopMusicName
            //layoutIfNeeded()
        }
        
    }
    
    /// 头部作者名字
    var TopName : String?{
        
        didSet{
            TopNameLabel.text = TopName
            //layoutIfNeeded()
        }
    }
    
    
    /// 重写init方法，设置默认设置的东西
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(TopMusicNameLabel)
        addSubview(TopNameLabel)
        SCX_CommonSetUp()
        
    }
    func XupdateTopView(byModel songDetails: SongDetail, withIndex index: Int)  {
        TopName = songDetails.songs[index].artists[index].name
        TopMusicName = songDetails.songs[index].name
        TopNameLabel.text = TopName
        TopMusicNameLabel.text = TopMusicName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        TopMusicNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(50)
            make.centerX.equalTo(self)
        }
        
        TopNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(TopMusicNameLabel.snp.bottom).offset(15
            )
            make.centerX.equalTo(self)
        }
        
    }
    
    
}

// MARK: - 头部试图配置
extension TopView{
    
    func SCX_CommonSetUp()  {
        TopMusicNameLabel.textColor = UIColor.white
        TopMusicNameLabel.font = UIFont.systemFont(ofSize: 20)
        TopNameLabel.textColor = UIColor.white
        TopNameLabel.font = UIFont.systemFont(ofSize: 17)
    }
    
}


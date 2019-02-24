//
//  songsCell.swift
//  Player
//
//  Created by 王申宇 on 2019/2/13.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import MJRefresh

class SongsCell: UITableViewCell {
    //    let titleLable = UILabel()
    //    let artistsLable = UILabel()
    //    let timeLable = UILabel()
    //
    private var nameLabel: UILabel!
    private var titleLabel: UILabel!
    private var timeLabel: UILabel!
    
    func configureCell(model: SongDetail,withIndex index: Int) {
        nameLabel.text = model.songs[index].name
        titleLabel.text = "\(model.songs[index].artists[index].name)•\(model.songs[index].album.name)"
        
        //MARK: -timelabel 还没弄
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        // 歌曲名
        nameLabel = UIMaker.label(frame: CGRect(x:8,y:5,width:Device.width - 16 - 60,height: 25),title: "")
        nameLabel.font = UIFont.systemFont(ofSize: 16.0)
        nameLabel.textColor = UIColor.black
        nameLabel.textAlignment = NSTextAlignment.left
        self.contentView.addSubview(nameLabel)
        
        // 标题
        titleLabel = UIMaker.label(frame:CGRect(x: nameLabel.frame.minX,
                                                y: nameLabel.frame.maxY + 5,
                                                width: nameLabel.frame.width,
                                                height: nameLabel.frame.height),
                                   title: "")
        titleLabel.font = UIFont.systemFont(ofSize: 14.0)
        titleLabel.textColor = UIColor.lightGray
        titleLabel.textAlignment = NSTextAlignment.left
        self.contentView.addSubview(titleLabel)
        
        // 时间
        timeLabel = UIMaker.label(frame:CGRect(x:nameLabel.frame.maxX,
                                               y:0,
                                               width:60,
                                               height:60),
                                  title: "")
        timeLabel.font = UIFont.systemFont(ofSize: 14.0)
        timeLabel.textColor = UIColor.lightGray
        timeLabel.textAlignment = NSTextAlignment.left
        self.contentView.addSubview(timeLabel)
    }
    
    convenience init() {
        self.init(style: .default, reuseIdentifier: "songsTableView")
        
        //        titleLable.frame = CGRect(x: 20, y: 20, width: Device.width - 100, height: 43)
        //        contentView.addSubview(titleLable)
        //        artistsLable.frame = CGRect(x: (titleLable.frame.maxX + 200), y: titleLable.frame.minY, width: 43, height: 43)
        //        contentView.addSubview(artistsLable)
    }
    
    convenience init(byModel songDetail: SongDetail, withIndex index: Int) {
        self.init(style: .default, reuseIdentifier: "songsTableView")
        //        //设置歌曲名
        //        titleLable.frame = CGRect(x: 20, y: 20, width: Device.width - 100, height: 43)
        //        titleLable.text = songDetail.songs[index].name
        //        contentView.addSubview(titleLable)
        //
        //        //设置歌手名
        //        artistsLable.frame = CGRect(x: (titleLable.frame.maxX + 20) , y: titleLable.frame.minY, width: 43, height: 43)
        //        artistsLable.text = songDetail.songs[index].artists[index].name
        //        contentView.addSubview(artistsLable)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//
//  MusicTableCell.swift
//  Player
//
//  Created by 王申宇 on 2019/2/11.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import MJRefresh
import SnapKit

struct Device {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
}

class LrcTableCell: UITableViewCell {
    var lrcCellTextLabel: BaseLabel? = BaseLabel()
    var lrcModel : LrcModel?{
        
        didSet{
            
            contentView.addSubview(lrcCellTextLabel!)
            lrcCellTextLabel?.progress = (lrcModel?.progress)!
            lrcCellTextLabel?.textAlignment = .center
            lrcCellTextLabel?.textColor = .white
            lrcCellTextLabel?.text = lrcModel?.LrcContent;
        }
        
    }
    // 更新歌词进度
    
    func UpdateLrc(progress : CGFloat)  {
        lrcCellTextLabel?.progress = progress
    }
    //FIXME: 设置位置和分行
    convenience init(byModel wordOfSongs: WordsOfSong, withIndex index: Int) {
        self.init(style: .default, reuseIdentifier: "lrcTableView")
        lrcCellTextLabel?.frame = CGRect(x: 20, y: 20, width: Device.width - 100, height: 43)
        lrcCellTextLabel?.text = wordOfSongs.lrc.lyric
    }
    
    class func CellForRowWithTableView(tableView : UITableView) -> LrcTableCell {
        
        let cellID = "lrccellID"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? LrcTableCell
        if cell == nil {
            cell = LrcTableCell(style: .default, reuseIdentifier: cellID)
            cell?.backgroundColor = .clear
        }
        return cell!
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        lrcCellTextLabel?.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(self)
        }
        
    }
}


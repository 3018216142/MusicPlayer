//
//  ViewController.swift
//  RealPlayer
//
//  Created by 王申宇 on 2019/2/17.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: BaseViewController , UITableViewDelegate , UITableViewDataSource {
    
    var songDetail: SongDetail!
    
    var music: LastestMusic!
    
    var wordOfSong: WordsOfSong!
    
    let tableView1 = UITableView(frame: .zero, style: .grouped)
    
    //  懒加载
    fileprivate var tableView : BaseView = BaseView()
    
    var detailVc : DetailViewController?
    
    lazy var SCX_PopAnimation = PopAnimation { (isPresent) in
        
    }
    
    var models = [MusicModel]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        automaticallyAdjustsScrollViewInsets = true
        loadData()
        
        SetUpTableView()
        monorEarphoneToggleControl()
        
        
    }
}

// MARK: - 加载数据
extension ViewController {
    func loadData() {
        SongDetailHelper.getLastestNews(success: { songDetail in
            self.songDetail = songDetail
            self.tableView1.reloadData()
        }, failure: { _ in
            
        })
    }
}


// MARK: - 搭建界面
extension ViewController {
    
    fileprivate func SetUpTableView (){
        
        tableView1.frame = self.view.bounds;
        
        tableView1.frame.origin.y = 0
        
        let imageView = UIImageView(image: UIImage(named: "ListBack.jpg"))
        
        tableView1.backgroundView = imageView
        
        tableView1.backgroundColor = UIColor.clear
        
        tableView1.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        tableView1.delegate = self;
        
        tableView1.dataSource = self;
        
        
        view.addSubview(tableView1)
        
    }
    
}

// MARK: - tableView代理方法
extension ViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return models.count;
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if songDetail == nil { return SongsCell() }
//        return SongsCell(byModel: songDetail, withIndex: indexPath.row)
        var  cell  = tableView1.dequeueReusableCell(withIdentifier: "cellID")
        
        if cell == nil {
            cell = TableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cellID")
        }
        MusicFigure.id = music.data[indexPath.row].id
        cell?.textLabel?.text = songDetail.songs[indexPath.row].name
        cell?.backgroundColor = UIColor.clear
        cell?.selectionStyle = .gray
        // 给cell添加动画
        cell?.addAnimation(animationType: .scale)
        return cell!
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        MusicFigure.id = music.data[indexPath.row].id
        
        tableView1.deselectRow(at: indexPath, animated: true )
        
        detailVc = DetailViewController.shareInstance
        
        
        detailVc?.XMusicModel = models[indexPath.row]
        
        detailVc?.modalPresentationStyle = .custom
        
        detailVc?.transitioningDelegate = SCX_PopAnimation
        
        MusicMidTool.shareInstance.PlayMusic(model: models[indexPath.row])
        
        PresentViewController(vc: detailVc)
        
        
    }
}

// MARK: - 监听耳机线控事件
extension ViewController{
    
    func monorEarphoneToggleControl()  {
        do{
            try AVAudioSession.sharedInstance().setActive(true)
            // 监听
            NotificationCenter.default.addObserver(self, selector: #selector(HandleToggle(note:)), name: AVAudioSession.routeChangeNotification, object: nil)
        }catch{
            
            print(error)
            
        }
    }
    @objc func HandleToggle(note : Notification)  {
        let userInfo = note.userInfo
        let key : AVAudioSession.RouteChangeReason = AVAudioSession.RouteChangeReason( rawValue: userInfo?[AVAudioSessionRouteChangeReasonKey] as! UInt)!
        
        
        let model = MusicMidTool.shareInstance.updatePlayModel()
        //SCX_Music_Model = model
        
        switch key {
        case AVAudioSession.RouteChangeReason.newDeviceAvailable:
            
            /// 必须在主线程中进行！！！！！！！！！！！！！！！！！坑死我了，基因为没有写主线程 ，所以一直崩溃，一直找原因没有找到，
            DispatchQueue.main.async {
                MusicMidTool.shareInstance.PlayMusic(model: model)
                self.detailVc?.XupdateDetailView(model: model, play: true, rotationType: .resume)
            }
            
        case AVAudioSession.RouteChangeReason.oldDeviceUnavailable:
            print("播出耳机了")
            DispatchQueue.main.async {
                MusicMidTool.shareInstance.PauseMusic()
                
                self.detailVc?.XupdateDetailView(model: model, play: false, rotationType: .pause)
            }
            
        default:
            break
            
        }
        
    }
    
}


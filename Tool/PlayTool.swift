//
//  PlayTool.swift
//  RealPlayer
//
//  Created by 王申宇 on 2019/2/14.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import AVFoundation
class PlayTool: NSObject , AVAudioPlayerDelegate {
    static let shareInstance = PlayTool()
    var player : AVAudioPlayer?
//    var player : AVAudioPlayer?  {
//        didSet{
//
//            let session = AVAudioSession.sharedInstance()
//            do{
//                try session.setCategory(AVAudioSession.Category.playback)
//                try session.setActive(true)
//            }
//            catch{
//
//                print(error);
//                return
//            }
//        }
//    }
    
    /// 播放
    func PlayMusic(name : String)  {
        
        guard let url = Bundle.main.url(forResource: name, withExtension: nil) else {
            return
        }
        
        if player?.url == url {
            player?.play()
            return
        }
        
        do {
            
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.prepareToPlay()
            player?.play()
            
        }
        catch{
            print(error)
            return
            
            
        }
    }
    
    /// 暂停
    func SCX_PauseMusic()  {
        player?.pause()
    }
    
    /// 定位到某个时间
    func SCX_SeekToTime(time : TimeInterval)  {
        player?.currentTime = time
    }
    
}
extension PlayTool {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PlayFinishNotificationKey"), object: nil)
    }
    
    
}



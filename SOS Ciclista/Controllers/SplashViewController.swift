//
//  SplashViewController.swift
//  SOS Ciclista
//
//  Created by John A. Cristobal on 5/28/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit
import AVFoundation

class SplashViewController: UIViewController {
    
    @IBOutlet var imagengif: UIView!
    var player: AVPlayer?
    //var playerLayer: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*guard let path = Bundle.main.path(forResource: "splash", ofType:".mp4") else {
            debugPrint("video.m4v not found")
            return
        }
        
        guard let videoURL = Bundle.main.url(forResource: "splash", withExtension:".mp4") else {
            debugPrint("video.m4v not found")
            return
        }
        player = AVPlayer(url: videoURL as URL)
        player?.actionAtItemEnd = .none
        player?.isMuted = true
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        //playerLayer.zPosition = -1
        
        playerLayer.frame = imagengif.frame
        
        self.imagengif.layer.addSublayer(playerLayer)
        
        player?.play()*/
        
        /*let vc = AVPlayerViewController()
        vc.player = player
        
        present(vc, animated: true) {
            vc.player?.play()
        }*/
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let videoURL = Bundle.main.url(forResource: "splash2", withExtension:".mp4") else {
            debugPrint("video.m4v not found")
            return
        }
        
        let player = AVPlayer(url: videoURL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.imagengif.bounds
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        self.imagengif.layer.addSublayer(playerLayer)
        player.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            // Put your code which should be executed with a delay here
            self.performSegue(withIdentifier: "reveal", sender: nil)
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

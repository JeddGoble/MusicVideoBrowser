//
//  PlayerView.swift
//  Krikey Jedd Goble
//
//  Created by Jedd Goble on 8/12/19.
//  Copyright © 2019 Free Range Robots. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerView: UIView {

    @IBOutlet weak var playerContainerView: UIView!
    
    var dismiss: ((Bool) -> Void)? = nil
    
    var url: URL? = nil
    
    private var playerLayer: AVPlayerLayer? = nil
    private var player: AVPlayer? = nil
    
    func configure(withURL url: URL, dismissCallback: @escaping (Bool) -> Void) {
        
        stop()
        
        dismiss = dismissCallback
        
        self.url = url
        
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        
        guard let playerLayer = playerLayer else {
            print("Error: Failed to instanciate Player")
            return
        }
        
        playerLayer.frame = bounds
        playerLayer.videoGravity = .resizeAspectFill
        playerContainerView.layer.addSublayer(playerLayer)
        
        player?.play()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        playerLayer?.frame = bounds
        CATransaction.commit()
    }
    
    func stop() {
        pause()
        player = nil
        playerLayer = nil
    }
    
    func pause() {
        if let player = player {
            player.pause()
        }
    }
    
    func play() {
        if let player = player {
            player.play()
        }
    }
    
    @IBAction func onExitButtonTapped(_ sender: UIButton) {
        dismiss?(false)
    }
    
    @IBAction func onFullScreenTapped(_ sender: UIButton) {
        dismiss?(true)
    }
    
}

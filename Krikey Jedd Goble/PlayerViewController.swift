//
//  PlayerViewController.swift
//  Krikey Jedd Goble
//
//  Created by Jedd Goble on 8/12/19.
//  Copyright © 2019 Free Range Robots. All rights reserved.
//

import UIKit
import AVKit

class PlayerViewController: AVPlayerViewController {

    var videoURL: URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = videoURL {
            player = AVPlayer(url: url)
            player?.play()
        }
    }
}

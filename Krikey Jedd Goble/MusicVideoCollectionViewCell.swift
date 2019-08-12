//
//  MusicVideoCollectionViewCell.swift
//  Krikey Jedd Goble
//
//  Created by Jedd Goble on 8/12/19.
//  Copyright © 2019 Free Range Robots. All rights reserved.
//

import UIKit
import AVKit

class MusicVideoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    static let reuseID = String(describing: MusicVideoCollectionViewCell.self)
    
    let networkingManager = NetworkingManager()
    
    func layoutCellWithModel(_ musicVideo: MusicVideo) {
        
        if let songName = musicVideo.title {
            songNameLabel.text = songName
        }
        
        if let artistName = musicVideo.artistName {
            artistNameLabel.text = artistName
        }
        
        if let urlString = musicVideo.artworkURLString, let url = URL(string: urlString) {
            networkingManager.downloadImageWithURL(url) { [weak self] (image) in
                self?.imageView.image = image
            }
        }
    }
}

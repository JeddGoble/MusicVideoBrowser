//
//  ViewController.swift
//  Krikey Jedd Goble
//
//  Created by Jedd Goble on 8/12/19.
//  Copyright © 2019 Free Range Robots. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var results: [MusicVideo] = []
    
    let networkingManager = NetworkingManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let nib = UINib(nibName: MusicVideoCollectionViewCell.reuseID, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: MusicVideoCollectionViewCell.reuseID)
        
        performDefaultSearch()
    }
    
    private func performDefaultSearch() {
        networkingManager.performSearch(term: "Lizzo") { [weak self] (musicVideos) in
            if let results = musicVideos {
                self?.results = results
                self?.collectionView.reloadData()
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MusicVideoCollectionViewCell.reuseID, for: indexPath) as? MusicVideoCollectionViewCell {
            cell.layoutCellWithModel(results[indexPath.item])
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let dimension = view.frame.width / 2.5
        return CGSize(width: dimension, height: dimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let insets = UIEdgeInsets(top: 30.0, left: 30.0, bottom: 30.0, right: 30.0)
        return insets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30.0
    }
    
}

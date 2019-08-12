//
//  ViewController.swift
//  Krikey Jedd Goble
//
//  Created by Jedd Goble on 8/12/19.
//  Copyright © 2019 Free Range Robots. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.attributedPlaceholder = NSAttributedString(string: "Search...",
                                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightText])
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var results: [MusicVideo] = []
    
    var selectedVideoURL: URL? = nil
    
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
        performSearch(withSearchTerm: "Lizzo")
    }
    
    private func performSearch(withSearchTerm term: String) {
        networkingManager.performSearch(term: term) { [weak self] (musicVideos) in
            if let results = musicVideos {
                self?.results = results
                self?.collectionView.reloadData()
            }
            self?.activityIndicator.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let playerVC = segue.destination as? PlayerViewController {
            playerVC.videoURL = selectedVideoURL
        }
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        activityIndicator.isHidden = false
        
        if let text = textField.text {
            performSearch(withSearchTerm: text)
        }
        
        textField.resignFirstResponder()
        
        return true
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let musicVideo = results[indexPath.item]
        if let urlString = musicVideo.videoPreviewURLString,
            let url = URL(string: urlString) {
            
            selectedVideoURL = url
            performSegue(withIdentifier: "SearchToFullScreenSegue", sender: self)
        }
        
    }
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

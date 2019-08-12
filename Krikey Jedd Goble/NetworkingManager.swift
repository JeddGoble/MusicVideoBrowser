//
//  NetworkingManager.swift
//  Krikey Jedd Goble
//
//  Created by Jedd Goble on 8/12/19.
//  Copyright © 2019 Free Range Robots. All rights reserved.
//

import Foundation
import UIKit

class NetworkingManager {
    
    var baseURL: URLComponents? = URLComponents(string: "https://itunes.apple.com/search")
    let mediaType = "musicVideo"
    let entityType = "musicVideo"
    
    func performSearch(term: String, completion: @escaping ([MusicVideo]?) -> Void) {
        
        URLSession.shared.invalidateAndCancel()
        
        guard var components = baseURL else {
            print("Error: Invalid Base URL")
            completion(nil)
            return
        }
        
        components.query = "media=\(mediaType)&entity=\(entityType)&term=\(term)"
        
        guard let url = components.url else {
            print("Error: Invalid URL Components")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                print("Error Fetching Search Results")
                print(error.localizedDescription)
                completion(nil)
                return
            }
            
            if let data = data {
                let musicVideos = self?.serializeResults(data: data)
                
                DispatchQueue.main.async {
                    completion(musicVideos)
                }
            }
        }
        
        task.resume()
        
    }
    
    private func serializeResults(data: Data) -> [MusicVideo]? {
        
        var response: [String : Any]?
        
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
        } catch let error {
            print("Error Parsing Results")
            print(error.localizedDescription)
            return nil
        }
        
        guard let results = response?["results"] as? [[String : Any]] else {
            print("Error Parsing Results")
            return nil
        }
        
        return mapResultsToModels(results)
    }
    
    private func mapResultsToModels(_ results: [[String : Any]]) -> [MusicVideo] {
        
        var musicVideos: [MusicVideo] = []
        
        for result in results {
            var musicVideo = MusicVideo()
            
            musicVideo.artistName = result["artistName"] as? String
            musicVideo.title = result["trackName"] as? String
            musicVideo.artworkURLString = result["artworkUrl100"] as? String
            musicVideo.videoPreviewURLString = result["previewUrl"] as? String
            
            musicVideos.append(musicVideo)
        }
        
        return musicVideos
    }
    
    func downloadImageWithURL(_ url: URL, completion: @escaping (UIImage?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Error Downloading Image")
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(nil)
                }
            } else if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
        
        task.resume()
    }
}

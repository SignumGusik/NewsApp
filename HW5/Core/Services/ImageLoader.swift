//
//  ImageLoader.swift
//  HW5
//
//  Created by Диана on 25/03/2026.
//

import UIKit

final class ImageLoader {
    static let shared = ImageLoader()

    private let cache = NSCache<NSURL, UIImage>()
    private let session: URLSession

    private init(session: URLSession = .shared) {
        self.session = session
    }

    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) -> URLSessionDataTask? {
        if let cachedImage = cache.object(forKey: url as NSURL) {
            // Cached images are returned immediately to avoid repeated network calls.
            completion(cachedImage)
            return nil
        }

        let task = session.dataTask(with: url) { [weak self] data, _, _ in
            guard
                let self,
                let data,
                let image = UIImage(data: data)
            else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            self.cache.setObject(image, forKey: url as NSURL)

            DispatchQueue.main.async {
                completion(image)
            }
        }

        task.resume()
        return task
    }
}

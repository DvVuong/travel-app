//
//  ImageCache.swift
//  Travel
//
//  Created by mr.root on 10/23/22.
//

import Foundation
import UIKit
open  class ImageCache: NSObject {
    static var share = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    
    private override init() {}
    
    public func fetchImage(_ url: String, completion: @escaping(UIImage?) -> Void) {
        let keyCache = url as NSString
        if let image = self.cache.object(forKey: keyCache) {
            completion(image)
            return
        }
        guard let url = URL(string: url) else {
            completion(nil)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data,  error == nil else {
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else  {
                    completion(nil)
                    return
                }
                self.cache.setObject(image, forKey: keyCache)
                completion(image)
            }
        }
        task.resume()
    }
    func convertImgaeToBase64(image: UIImage) -> String {
            let imageData: Data? = image.jpegData(compressionQuality: 0.4)
            let imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
            return imageStr
    }
    func convertBase64ToImage(_ imgStr: String)  -> UIImage {
        guard  let imageData = Data(base64Encoded: imgStr, options: .ignoreUnknownCharacters) else { return UIImage() }
        guard let image = UIImage(data: imageData) else { return UIImage() }
        return  image
    }
}

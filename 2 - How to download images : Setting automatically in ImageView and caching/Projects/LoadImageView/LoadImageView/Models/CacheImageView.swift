import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class CacheImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageFrom(urlString: String) {
        self.imageUrlString = urlString
        guard let url = URL(string: urlString) else { return }
        self.image = nil
        
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            
            DispatchQueue.main.async {
                guard let imageToCache = UIImage(data: data!) else { return }
                
                if self.imageUrlString == urlString {
                    imageCache.setObject(imageToCache, forKey: url.absoluteString as AnyObject)
                    self.image = imageToCache
                }
            }
        }.resume()
    }
}

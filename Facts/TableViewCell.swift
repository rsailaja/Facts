//
//  TableViewCell.swift
//  Facts
//
//  Created by Sailaja Rallapalli on 28/02/18.
//  Copyright © 2018 SoftSol. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var factRowImage: UIImageView!
    
}

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    func loadImageUsingCache(_ urlString: String) {
        
        guard let url = URL(string: urlString) else {
            print("Empty URL")
            self.image = (UIImage(named: "default.png"))
            return
        }
        self.image = nil
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        // if not, download image from url
        let task = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("error: \(String(describing: error))")
                self.image = (UIImage(named: "default.png"))
                return
            }
            guard response != nil else {
                print("no response")
                self.image = (UIImage(named: "default.png"))
                return
            }
            guard data != nil else {
                print("no data")
                self.image = (UIImage(named: "default.png"))
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                }
            }
        }; task.resume()
    }
}

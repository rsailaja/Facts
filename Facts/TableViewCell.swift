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
        
    internal var aspectConstraint : NSLayoutConstraint? {
        didSet {
            if oldValue != nil {
                factRowImage.removeConstraint(oldValue!)
            }
            if aspectConstraint != nil {
                aspectConstraint?.priority = UILayoutPriority(rawValue: 999)
                factRowImage.addConstraint(aspectConstraint!)
            }
        }
    }
}
   
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        aspectConstraint = nil
//    }
//
//    func setPostedImage(image : UIImage) {
//
//        let aspect = image.size.width / image.size.height
//
//        aspectConstraint = NSLayoutConstraint(item: factRowImage, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: factRowImage, attribute: NSLayoutAttribute.height, multiplier: aspect, constant: 0.0)
//
//        factRowImage.image = image
//    }
//
//}
//extension UIImageView {
//    public func imageFromServerURL(urlString: String, defaultImage : String?) {
//        if let di = defaultImage {
//            self.image = UIImage(named: di)
//        }
//
//        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
//
//            if error != nil {
//                print(error ?? "error")
//                return
//            }
//            DispatchQueue.main.async(execute: { () -> Void in
//                let image = UIImage(data: data!)
//                self.image = image
//            })
//
//        }).resume()
//    }
//
    let imageCache = NSCache<NSString, AnyObject>()
    
    extension UIImageView {
        func loadImageUsingCache(withUrl urlString : String) {
            let url = URL(string: urlString)
            self.image = nil
            
            // check cached image
            if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
                self.image = cachedImage
                return
            }
            
            // if not, download image from url
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                DispatchQueue.main.async {
                    if let image = UIImage(data: data!) {
                        imageCache.setObject(image, forKey: urlString as NSString)
                        self.image = image
                    }
                }
                
            }).resume()
        }
}

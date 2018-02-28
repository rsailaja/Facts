//
//  ViewController.swift
//  Facts
//
//  Created by Sailaja Rallapalli on 28/02/18.
//  Copyright © 2018 SoftSol. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    final let url = URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")
    private var rows = [Row]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadJson()
        
    }

    func downloadJson() {
        guard let downloadURL = url else { return }
        URLSession.shared.dataTask(with: downloadURL) { data, urlResponse, error in
            guard let data = data, error == nil, urlResponse != nil else {
                print("something is wrong")
                return
            }
            print("downloaded")
            print(data)
            do
            {
                let responseStrInISOLatin = String(data: data, encoding: String.Encoding.isoLatin1)
                guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8) else {
                    print("could not convert data to UTF-8 format")
                    return
                }
                do {
                    let responseJSONDict = try JSONSerialization.jsonObject(with: modifiedDataInUTF8Format)
                    print(responseJSONDict)
                    let json = try JSONSerialization.jsonObject(with: modifiedDataInUTF8Format) as? [String: Any]
                    let eventTitle = json!["title"] as? String
                    print(eventTitle)
                    let blogs = json!["rows"] as? [[String: Any]]
                    for blog in blogs!{
                        print(blog["title"])
                    }
                } catch {
                    print(error)
                }
            } catch let err{
                print("something wrong after downloaded")
                print(err)
            }
            }.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


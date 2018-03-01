//
//  ViewController.swift
//  Facts
//
//  Created by Sailaja Rallapalli on 28/02/18.
//  Copyright © 2018 SoftSol. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    final let url = URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")
    private var rows = [Row]()
    
    @IBOutlet weak var facesTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "factCell", for: indexPath) as! TableViewCell
        print("4")
        
        //getting the details for the specified row
        let row = self.rows[indexPath.row]
        print("5")
        //displaying values
        cell.titleLbl.text = row.title ?? ""
        cell.descLbl.text = row.description ?? ""
        
        if let imageUrl = row.imageHref {
            cell.factRowImage.loadImageUsingCache(withUrl: imageUrl)
        }else{
            cell.factRowImage.image = UIImage(named: "default.png")
            
        }
        //        let image = UIImage(named:row.imageHref!)
        //        cell.setPostedImage(image: image!)
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadJson()
        
        //        facesTableView.estimatedRowHeight = 200
        //        facesTableView.rowHeight = UITableViewAutomaticDimension
        //
        //displaying data in tableview
        self.facesTableView.reloadData()
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
                let responseStr = String(data: data, encoding: String.Encoding.isoLatin1)
                guard let newResponseInUTF8Format = responseStr?.data(using: String.Encoding.utf8) else {
                    print("could not convert data to UTF-8 format")
                    return
                }
                let responseJSONDict = try JSONSerialization.jsonObject(with: newResponseInUTF8Format)
                print(responseJSONDict)
                let json = try JSONSerialization.jsonObject(with: newResponseInUTF8Format) as? [String: Any]
                
                let eventTitle = json!["title"] as? String
                print(eventTitle as Any)
                
                let factRows = json!["rows"] as? [[String: Any]]
                if let unWrappedRows = factRows{
                    for factRow in unWrappedRows{
                        let newRow = Row.init(title: factRow["title"] as? String, description: factRow["description"] as? String, imageHref: factRow["imageHref"] as? String)
                        self.rows.append(newRow)
                    }
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    self.facesTableView.reloadData()
                })
                
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


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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "factCell", for: indexPath) as! TableViewCell
        print("4")
        
        //getting the details for the specified row
        let row = self.rows[indexPath.row]
        print("5")
        //displaying values
        cell.titleLbl?.text = row.title
        cell.descLbl.text = row.description
        //        cell.factRowImage?.image = UIImage(named: "Default.png")
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadJson()
        //traversing through all elements of the array
        for i in 0..<self.rows.count{
            //adding row values to the facts list
            self.rows.append(Row(
                title: ((self.rows[i] as AnyObject).value(forKey: "title") as? String)!,
                description: ((self.rows[i] as AnyObject).value(forKey: "description") as? String)!,
                imageHref: ((self.rows[i] as AnyObject).value(forKey: "imageHref") as? String)!
            ))
            
        }
        
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
                do {
                    let responseJSONDict = try JSONSerialization.jsonObject(with: newResponseInUTF8Format)
                    print(responseJSONDict)
                    let json = try JSONSerialization.jsonObject(with: newResponseInUTF8Format) as? [String: Any]
                    let eventTitle = json!["title"] as? String
                    print(eventTitle)
                    let factRows = json!["rows"] as? [[String: Any]]
                    for factRow in factRows!{
                        print(factRow["title"])
//                        let row = Row.init(title: factRow["title"] as! String, description: factRow["description"] as! String, imageHref: factRow["imaheHref"] as! String)
//                        self.rows.append(row)
                    }
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


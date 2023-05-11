//
//  ViewController.swift
//  swiftyjson
//
//  Created by Yogesh Patel on 16/04/18.
//  Copyright © 2018 Yogesh Patel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var arrData = [JsonModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jsonParsing()
    }

    func jsonParsing(){
        let url = URL(string: "https://itunes.apple.com/search?media=music&term=bollywood")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else { return }
            do{
                let json = try JSON(data:data)
                let results = json["results"]
                for arr in results.arrayValue{
                    self.arrData.append(JsonModel(json: arr))
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }catch{
                print(error.localizedDescription)
            }
        }.resume()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.lblArtist.text = arrData[indexPath.row].artistName
        cell.lblTrack.text = arrData[indexPath.row].trackCensoredName
        cell.img.kf.setImage(with: URL(string: arrData[indexPath.row].artworkUrl100))
        return cell
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableViewAutomaticDimension
    }
}

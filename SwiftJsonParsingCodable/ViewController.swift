//
//  ViewController.swift
//  SwiftJsonParsingCodable

//  Copyright © 2018 
//

import UIKit
import Alamofire


struct BusinessDetail:Codable{
    let status:String?
    let result:[BusinessData]
}
// Business Detail

struct BusinessData:Codable{
    let name: String?
    let address: String?
}


// https://jsoneditoronline.org/?id=4065720460124f86a7d1119a3fbd34de  HERE IS THE JSON Structure

class ViewController: UITableViewController {

    let cellIdentifier = "cell"
    
    let App_URL_IOS = "your_url"
    
    var arrayData = [BusinessData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register a tableview cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        jsonParse() // calling api
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        cell?.textLabel?.text = arrayData[indexPath.row].address
        return cell!
    }
    
    func jsonParse(){
        
        let parameters = [
            "author_id" :"1907",
            "get_deals_author":"1"
        ]
        
        Alamofire.upload(
            multipartFormData: { MultipartFormData in
                
                for (key, value) in parameters {
                    
                    MultipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
                
        }, to: App_URL_IOS) { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    let json = response.data
                    //print(response.result.value as Any)
                    do{
                        //created the json decoder
                        let decoder = JSONDecoder()
                        
                        do {
                            let status = try decoder.decode(BusinessDetail.self, from: json!)
                            
                            print("Status : \(String(describing: status.status))")
                            print("Result Array : \(status.result)")
                            
                            self.arrayData = status.result
                            //self.arrayData.reverse() // Used to reverse Array
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        } catch let error {
                            print("Error: \(error)")
                        }
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                break
            }
        }
    }
}


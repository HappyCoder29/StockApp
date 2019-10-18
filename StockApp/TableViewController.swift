//
//  TableViewController.swift
//  StockApp
//
//  Created by Ashish on 10/17/19.
//  Copyright © 2019 Ashish. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON
import Alamofire

class TableViewController: UITableViewController {

    var arr = [Stock]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do{
            let realm = try Realm()

        }catch{
            print("Error in initialiozing \(error)")
        }
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
                
        
        

    }



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as!  TableViewCell
        
        cell.lblSymbol.text = "\(arr[indexPath.row].symbol) : "
        cell.lblPrice.text = "\(arr[indexPath.row].price) $"
        
        return cell
    }
    


}

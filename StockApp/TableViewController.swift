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
        LoadValuesFromDB()
        
//        do{
//            let realm = try Realm()
//
//        }catch{
//            print("Error in initializing \(error)")
//        }
//
//        print(Realm.Configuration.defaultConfiguration.fileURL)
//
    
    }
    
    func LoadValuesFromDB(){
        do{
            let realm = try Realm()
            let stocks = realm.objects(Stock.self)
            
            for stock in stocks{
                arr.append(stock)
            }

        }catch{
            print("Error in Loading \(error)")
        }
    }
    
    
    
    
    func AddStockToDB(stock: Stock){
        do{
            let realm = try Realm()
            try realm.write {
                realm.add(stock, update: Realm.UpdatePolicy.all)
            }

        }catch{
            print("Error in Adding Stock to DB \(error)")
        }
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

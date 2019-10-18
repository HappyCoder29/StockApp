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
    
    var textField = UITextField()
    
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
    
    func IsStockAdded(symbol: String) -> Bool{
            let realm = try! Realm()
            if realm.object(ofType: Stock.self, forPrimaryKey: symbol) != nil{
                return true
            }
           return false
       }
    
    func GetStockValue(symbol: String){
        
        let url = "https://financialmodelingprep.com/api/v3/stock/real-time-price/\(symbol)"
        Alamofire.request(url, method: .get, parameters: nil).responseJSON { (response) in
            if response.result.isSuccess{
                let stockJSON: JSON = JSON(response.result.value!)
                print(stockJSON)
                let result = stockJSON["symbol"].rawString()
                if result! == "null" {
                    return
                }
                
                let stock = Stock()
                stock.symbol = stockJSON["symbol"].rawString()!
                stock.price = stockJSON["price"].floatValue
                stock.companyInfo = ""
                self.arr.append(stock)
                self.AddStockToDB(stock: stock)
                self.tableView.reloadData()
                
            
            }
            
        }
    }

    
    
    @IBAction func addStock(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Stock", message: "Type Stock Symbol", preferredStyle: .alert)
                   
        let OK = UIAlertAction(title: "OK", style: .default) { (action) in
            
            let symbol = self.textField.text!
            // if stock is already added
            if(self.IsStockAdded(symbol: symbol)){
                return
            }
            
            self.GetStockValue(symbol: symbol)
            
        }
                   
        let Cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Cancel Pressed")
        }
                   
        alert.addTextField { (addTextField) in
            addTextField.placeholder = "Stock Symbol"
            self.textField = addTextField
        }
        alert.addAction(Cancel)
        alert.addAction(OK)
               
                   
        self.present(alert, animated: true, completion: nil)
    }
    


}

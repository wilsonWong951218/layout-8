//
//  OrderManuViewController.swift
//  Layout-8
//
//  Created by Macintosh on 2018/5/24.
//  Copyright © 2018年 LAT. All rights reserved.
//

import UIKit
import Firebase

struct ShopItem{
    var itemName:String
    var itemPrice:String
    var count:String
}


class OrderManuViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource ,UITabBarDelegate{

    @IBOutlet weak var tabBar: UITabBarItem!
    @IBOutlet weak var tableView: UITableView!
    var ID:String = "MyTableViewCell"
    var shopName = [String]()
    var array = [[String]]()
    var totalAmountCount = Float()
    @IBOutlet weak var totalAmount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(getDataValue), for: .valueChanged)
        let nibCell = UINib(nibName:ID, bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: ID)
        print(NSHomeDirectory())
        
        
        
        Database.database().reference().child("shopFOOD").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            // print(snapshot.value ?? "")
            for food in (snapshot.children.allObjects as! [DataSnapshot]){
                
                self.shopName.append(food.key)
            }
            
        }) { (error) in
            print("Error:\(error)")
            
        }
        
    }


    
    @objc func getDataValue(){
        array.removeAll()
        totalAmountCount = 0
        for shop in 0..<shopName.count{
            if let orderData = UserDefaults.standard.object(forKey:shopName[shop]) as? [[String]]{
                
                array += orderData
                
                print("Shop:",shop)
                print("orderData:",orderData)
                
            }
        }
        var removeCount = 0
        for index in 0..<array.count{
            if array[index-removeCount][3] == "0" || array[index-removeCount][3] == ""{
                array.remove(at: index-removeCount)
                removeCount += 1
            }
        }
        
      
        tableView.reloadData()
        tableView.refreshControl!.endRefreshing()
         print("hallo",array)
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return array.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let indexCount = 0
        let cell = tableView.dequeueReusableCell(withIdentifier:ID, for: indexPath) as! MyTableViewCell
        
            cell.lbShop.text = array[indexPath.row][indexCount]
            cell.lbFood.text = array[indexPath.row][indexCount+1]
            cell.lbPrice.text = array[indexPath.row][indexCount+2]
            cell.lbOrdered.text = array[indexPath.row][indexCount+3]
        
        guard let lbPrice = cell.lbPrice.text else {return cell}
        guard let lbOrdered = cell.lbOrdered.text else {return cell}
        totalAmountCount += Float(lbOrdered)! * Float(lbPrice)!
        totalAmount.text = "總金額：NT$\(String(totalAmountCount))"
        return cell
    }
    
  
}

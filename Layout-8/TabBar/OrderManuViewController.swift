//
//  OrderManuViewController.swift
//  Layout-8
//
//  Created by Macintosh on 2018/5/24.
//  Copyright © 2018年 LAT. All rights reserved.
//

import UIKit
import Firebase
class OrderManuViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource ,UITabBarDelegate{

    @IBOutlet weak var tabBar: UITabBarItem!
    @IBOutlet weak var tableView: UITableView!
    var ID:String = "MyTableViewCell"
    var tableArray = NSArray()
    var tableArrayFinal = Array<String>()
    var shopFood = [String]()
    var shopName = [String]()
    var shopNameArray = [String]()
    var userDefualtsKey = String()
     var array = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
      tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(getDataValue), for: .valueChanged)
        tableArrayFinal.removeAll()
        let nibCell = UINib(nibName:ID, bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: ID)
        print(NSHomeDirectory())
        
    }


    
    @objc func getDataValue(){
       
        
        Database.database().reference().child("shopFOOD").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
           // print(snapshot.value ?? "")
            for food in (snapshot.children.allObjects as! [DataSnapshot]){
            
                self.shopName.append(food.key)
            }
            
        }) { (error) in
            print("Error:\(error)")
        }
        
        for shop in 0..<shopName.count{
            if let orderData = UserDefaults.standard.object(forKey:shopName[shop]) as? NSArray{
                for index in 0..<orderData.count{
                    array = orderData[index] as! [String]
                    
                }
            }
        }
        print(array)
        tableView.reloadData()
        tableView.refreshControl!.endRefreshing()
        
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArrayFinal.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:ID, for: indexPath) as! MyTableViewCell
       
        //print(arrayData)
            cell.lbShop.text = array[indexPath.row]
           // cell.lbFood.text =
    
        return cell
    }
    
  
   
}

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
      tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(addTableCell), for: .valueChanged)
        tableArrayFinal.removeAll()
        let nibCell = UINib(nibName:ID, bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: ID)
        
    }


    

    
   @objc func addTableCell(){
    var array = [String]()
    var shopArray = [String]()

        for index in 0..<shopName.count{
            if let orderData = UserDefaults.standard.object(forKey:shopName[index]){

                tableArray = orderData as! NSArray
                for index1 in 0..<tableArray.count{
                    if tableArray[index1] as! Int != 0{
                        shopArray.append(shopName[index1])

                        shopNameArray = shopArray
                        array.append(String(tableArray[index1] as! Int))
                        tableArrayFinal = array
                    }
                }
            }
        }
    tableView.reloadData()
    tableView.refreshControl!.endRefreshing()
    shopArray.removeAll()
    array.removeAll()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArrayFinal.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:ID, for: indexPath) as! MyTableViewCell
        if tableArrayFinal.count != 0{
            cell.lbShop.text = shopNameArray[indexPath.row]
           // cell.lbFood.text =
        }
        return cell
    }
    
  
   
}

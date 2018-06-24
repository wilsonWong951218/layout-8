//
//  HistoryPopVC.swift
//  Layout-8
//
//  Created by Macintosh on 2018/6/25.
//  Copyright © 2018年 LAT. All rights reserved.
//

import UIKit
import Firebase
class HistoryPopVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var backButton: UIButton!
    var ID:String = "MyTableViewCell"
    var UUid = String()
    var foodName = [String]()
    var foodNameCount = [Int]()
    var foodCount = [String]()
    var foodPrice = [String]()
    var shopName = [String]()
    var dictionary = [String:Any]()
    var indexCount = 0
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibCell = UINib(nibName:ID, bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: ID)
        getDB()
        backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        tableView.allowsSelection  = false
        // Do any additional setup after loading the view.
    }
    
    @objc func handleBackButton(){
        dismiss(animated: true, completion: nil)
    }
    
    func getDB(){
        let now = Date()
        let year = DateFormatter()
        let month = DateFormatter()
        let date = DateFormatter()
        let time = DateFormatter()
        year.dateFormat = "yyyy年"
        month.dateFormat = "MM月"
        date.dateFormat = "dd日"
        time.dateFormat = "HH:mm:ss"
        let isYear = year.string(from: now)
        let isMonth = month.string(from: now)
        let isDate = date.string(from: now)
        Database.database().reference().child("OrderList").child("\(isYear)").child("\(isMonth)").child("\(isDate)").child("Unserve").child("\(UUid)").observeSingleEvent(of: .value, with: { (dataSnap) in
            self.dictionary = dataSnap.value as! [String:Any]
            for shop in dataSnap.children.allObjects as! [DataSnapshot]{
                self.shopName.append(shop.key)
                self.foodNameCount.append(shop.children.allObjects.count)
                for food in shop.children.allObjects as! [DataSnapshot]{
                    self.foodName.append(food.key)
                    let isShopData = self.dictionary["\(shop.key)"] as! [String:Any]
                    let isFoodData = isShopData["\(food.key)"] as! [String:Any]
                    let isCountData = isFoodData["Count"] as! String
                    let isPriceData = isFoodData["Price"] as! String
                    self.foodCount.append(isCountData)
                    self.foodPrice.append(isPriceData)

                }
                
            }
            self.tableView.reloadData()
        }) { (error) in
            print("get table order list:",error)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        for index in 0 ..< foodNameCount.count{
            count += foodNameCount[index]
        }
        print(count)
        indexCount = 0
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:ID, for: indexPath) as! MyTableViewCell
        if indexPath.row  != foodNameCount[indexCount]{
            cell.lbShop.text = shopName[indexCount]
            cell.lbFood.text = foodName[indexPath.row]
            cell.lbPrice.text = foodPrice[indexPath.row]
            cell.lbOrdered.text = foodCount[indexPath.row]
        }else{
            if indexPath.count > indexCount{
                    indexCount += 1
            }else{
                indexCount = indexPath.count
            }
            cell.lbShop.text = shopName[indexCount]
            cell.lbFood.text = foodName[indexPath.row]
            cell.lbPrice.text = foodPrice[indexPath.row]
            cell.lbOrdered.text = foodCount[indexPath.row]
         
         }
       return cell
    }

}

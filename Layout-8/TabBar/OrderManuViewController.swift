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

    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var tabBar: UITabBarItem!
    @IBOutlet weak var tableView: UITableView!
    var updataOrderData = [OrderData]()
    
    var ID:String = "MyTableViewCell"
    var shopName = [String]()
    var array = [[String]]()
    var totalAmountCount = Float()
    var refreshControl = UIRefreshControl()
    let now = Date()
    let year = DateFormatter()
    let month = DateFormatter()
    let date = DateFormatter()
    let orderData = OrderData()
    @IBOutlet weak var totalAmount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButton.addTarget(self, action: #selector(handleUpdataButton), for: .touchUpInside)
        
        
        //table view refresh
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action:#selector(getDataValue), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)

        //table view cell connect
        let nibCell = UINib(nibName:ID, bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: ID)
        print("URL:",NSHomeDirectory())
        
        
        //get database foodName
        Database.database().reference().child("shopFOOD").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            for food in (snapshot.children.allObjects as! [DataSnapshot]){
                
                self.shopName.append(food.key)
            }
            
        }) { (error) in
            print("Error:\(error)")
            
        }
        
    }

    // after refresh UI-tableView get all UI-collectionView data in to array
    @objc func getDataValue(sender:AnyObject){
        array.removeAll()
        updataOrderData.removeAll()
        if array.count == 0{
            totalAmount.text = "總金額：NT$0"
        }
        for shop in 0..<shopName.count{
            if let orderData = UserDefaults.standard.object(forKey:shopName[shop]) as? [[String]]{
                
                array += orderData
                
                print("Shop:",shop)
                print("orderData:",orderData)
                
            }
        }
        print("hallo",array)
        //filter ordered data whice ordered count is 0 or "" else append value to updataOrderData array
        var removeCount = 0
        var updataCount = 0
        for index in 0..<array.count{
            if array[index-removeCount][3] == "0" || array[index-removeCount][3] == ""{
                array.remove(at: index-removeCount)
                removeCount += 1
            }else{
                orderData.shopNameData = array[index-removeCount][0]
                orderData.foodNameData = array[index-removeCount][1]
                orderData.foodPriceData = array[index-removeCount][2]
                orderData.orderedCount = array[index-removeCount][3]
                updataOrderData += [orderData]
//                updataOrderData[updataCount].shopNameData = array[index-removeCount][0]
//
//                updataOrderData[updataCount].foodNameData = array[index-removeCount][1]
//                print(updataOrderData[updataCount].foodNameData)
//                updataOrderData[updataCount].foodPriceData = array[index-removeCount][2]
//                updataOrderData[updataCount].orderedCount = array[index-removeCount][3]
                
                
               
                
            }
            
        }
        
        print(updataOrderData[0].foodNameData)
        tableView.reloadData()
        refreshControl.endRefreshing()
        
        totalAmountCount = 0
        
        
    }
    

    //updata ordered data to db
   @objc func handleUpdataButton(){
        year.dateFormat = "yyyy年"
        month.dateFormat = "MM月"
        date.dateFormat = "dd日"
     let isYear = year.string(from: now)
     let isMonth = month.string(from: now)
     let isDate = date.string(from: now)
    
    for index in 0..<updataOrderData.count{
        let value = updataOrderData[index].dictionaryCreate()
        print(value)
        let dataArray = [isDate:value]
        let monthArray = [isMonth:dataArray]
        let yearArray = [isYear:monthArray]
      
       // Database.database().reference().child("OrderList").child("\(isYear)").child("\(isMonth)").child("\(isDate)").childByAutoId().setValue(value)
    }
    
    
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

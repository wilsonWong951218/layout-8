
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
    let time = DateFormatter()
    var orderData = [OrderData]()
    
    @IBOutlet weak var totalAmount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButton.addTarget(self, action: #selector(handleUpdataButton), for: .touchUpInside)
        updateButton.layer.cornerRadius = 15
        
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.getDataValueRefreshNonObjc()
        }
        
    }
    // after refresh UI-tableView get all UI-collectionView data in to array
    @objc func getDataValue(sender:AnyObject){
        getDataValueRefreshNonObjc()
    }
    
    func getDataValueRefreshNonObjc(){
        array.removeAll()
        orderData.removeAll()
        if array.count == 0{
            totalAmount.text = "總金額：NT$0"
        }
        //array : value for cell display
        //orderData : value for userDefaults
        for shop in 0..<shopName.count{
            if let orderData = UserDefaults.standard.object(forKey:shopName[shop]) as? [[String]]{
                array += orderData
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
                let data = OrderData()
                orderData.append(data)
                orderData[updataCount].shopNameData = array[index-removeCount][0]
                orderData[updataCount].foodNameData = array[index-removeCount][1]
                orderData[updataCount].foodPriceData = array[index-removeCount][2]
                orderData[updataCount].orderedCount = array[index-removeCount][3]
                updataCount += 1
            }
        }
        tableView.reloadData()
        refreshControl.endRefreshing()
        totalAmountCount = 0
    }
    
    //updata ordered data to db
    @objc func handleUpdataButton(){
        var finalDataValue =  [[String : [String : String]]]()
        year.dateFormat = "yyyy年"
        month.dateFormat = "MM月"
        date.dateFormat = "dd日"
        time.dateFormat = "HH:mm:ss"
        let isYear = year.string(from: now)
        let isMonth = month.string(from: now)
        let isDate = date.string(from: now)
        //let isTime = time.string(from: now)
        let ref = Database.database().reference().child("OrderList").child("\(isYear)").child("\(isMonth)").child("\(isDate)").child("Unserve")
        let postRefKey = ref.childByAutoId()
        
        //sort shop/food data and update to firebase
        if orderData.count != 0{
         var myShop = orderData[0].shopNameData
        for index in 0..<orderData.count{
            if index == 0{
                postRefKey.updateChildValues(orderData[index].dictionaryCreateShop())
            }
            else if myShop == orderData[index].shopNameData{
                postRefKey.child(orderData[index].shopNameData).updateChildValues(orderData[index].dictionaryCreate())
            }
            else{
                myShop = orderData[index].shopNameData
                postRefKey.updateChildValues(orderData[index].dictionaryCreateShop())
            }
            finalDataValue.removeAll()
        }
        
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        array.removeAll()
        tableView.reloadData()
        totalAmount.text = "總金額：NT$0"
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
        for index in 0..<array.count{
        totalAmountCount += Float(array[index][indexCount+3])! * Float(array[index][indexCount+2])!
        //totalAmountCount += Float(lbOrdered)! * Float(lbPrice)!
        }
        totalAmount.text = "總金額：NT$\(String(totalAmountCount))"
        totalAmountCount = 0
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        tableView.reloadData()
        var countTable = 0
        
       let shopName = array[indexPath.row][0]
       let foodName = array[indexPath.row][1]
        array.remove(at: indexPath.row)
        
        var prefs = UserDefaults.standard.array(forKey:"\(shopName)") as! [[String]]
        for index_1 in 0 ..< prefs.count {
            if prefs[index_1][0] == "\(shopName)"
                && prefs[index_1][1] == "\(foodName)"{
                prefs[index_1][3] = "0"
                UserDefaults.standard.set(prefs, forKey: shopName)
                }
         
        }
        countTable += 1
        tableView.deleteRows(at: [indexPath], with: .fade)
        getDataValueRefreshNonObjc()
    }
    
    
}

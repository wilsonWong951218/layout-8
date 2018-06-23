//
//  ViewController.swift
//  Layout-8
//
//  Created by Macintosh on 2018/5/5.
//  Copyright © 2018年 LAT. All rights reserved.
//
import UIKit
import Firebase
class PopManuViewController: UIViewController {
    
    let MyCollectionViewCellId: String = "MyCollectionViewCell"
    var getOrderData = [OrderData]()
    
    
    var foodNameArray = [String]()
    var foodPriceArray = [String]()
    var foodName = [String]()
    var foodPrice = [String]()
    var myShopName = String()
    var foodNumberSelected = Int()
    var labelCount = UILabel()
    var counter = 0
    var counter1 = 0
    var myShopFoodCount = Int()
    var orderData = [Int]()
    var countValue = 0
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database()
        getFoodCount()
        backButton.addTarget(self, action: #selector(backToShop), for: .touchUpInside)
        let nibCell = UINib(nibName: MyCollectionViewCellId, bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: MyCollectionViewCellId)
        //print("SecondViewCount:",myShopFoodCount)
        confirmButton.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
        
        
    }
    
    func database(){
        Database.database().reference().child("shopFOOD").child(myShopName).observeSingleEvent(of: .value, with: { (snapshot) in
            self.foodNameArray = self.getFoodName(snapshot)
            self.foodPriceArray = self.getFoodPrice(snapshot)
   
        }) { (error) in
            print("Error get food detail:",error)
        }
    }
    @objc func handleConfirm(){
        print("Save data in userdefault")
        var dataArray = [[String]]()
        
        for index in 0..<getOrderData.count{
            dataArray.append([getOrderData[index].shopNameData,getOrderData[index].foodNameData,getOrderData[index].foodPriceData,getOrderData[index].orderedCount])

        }
        
        UserDefaults.standard.set(dataArray, forKey: myShopName)
       
        UserDefaults.standard.synchronize()
        dataArray.removeAll()
        
        let myAlert = UIAlertController(title: "Thank For Order!", message: nil, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Continue Shopping", style: .default) { (action:UIAlertAction) -> () in
            self.back()
        }
        myAlert.addAction(doneAction)
        self.present(myAlert,animated: true,completion: nil)
         
      
    }
    func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func getFoodCount(){
        print(myShopName)
        Database.database().reference().child("shopFOOD").child(myShopName).observeSingleEvent(of: .value) { (snapshot) in
            self.myShopFoodCount = Int(snapshot.childrenCount)
            print("third:",self.myShopFoodCount)
            self.collectionView.reloadData()
        }
        
    }
    
    @objc func backToShop(){
        navigationController?.popViewController(animated: true)
    }
    
    
    func getFoodPrice(_ snapshot:DataSnapshot)->[String]{
        guard let dictionary = snapshot.value as? [String:Any] else {return[""]}
        for food in snapshot.children.allObjects as! [DataSnapshot]{
            let name  = food.key
            foodPrice += [dictionary["\(name)"] as! String]
        }
        // print(foodPrice)
        
        return foodPrice
    }
    
    func getFoodName(_ snapshot:DataSnapshot)->[String]{
        for food in snapshot.children.allObjects as! [DataSnapshot]{
            foodName += [food.key]
            
        }
        // print(foodName)
        return foodName
    }
    
    @objc func touchAddButton(_ sender:UIButton){
        for index in orderData.indices{
            if index == sender.tag{
                let value = orderData[index]
                orderData[index] = value + 1
            }
        }
        collectionView.reloadData()
    }
    
    @objc func touchSubButton(_ sender:UIButton){
        for index in orderData.indices{
            if index == sender.tag{
                let value = orderData[index]
                if value > 0 {
                    orderData[index] = value - 1
                }else{
                    orderData[index] = 0
                }
            }
        }
        collectionView.reloadData()
    }
    
}



extension PopManuViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if counter <= 1{
            for _ in 0..<myShopFoodCount{
                orderData.append(0)
                let test = OrderData()
                getOrderData += [test]
            }
            counter += 1
        }
        
        return myShopFoodCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCellId, for: indexPath) as! MyCollectionViewCell
       
        cell.lbName.text = foodNameArray[indexPath.row]
        cell.lbPrice.text = "Price:\(foodPriceArray[indexPath.row])"
        
        self.getOrderData[indexPath.row].shopNameData = self.myShopName
        
        
        var name = cell.lbName.text!
        self.getOrderData[indexPath.row].foodNameData = name
        
        let price = foodPriceArray[indexPath.row]
        self.getOrderData[indexPath.row].foodPriceData = price
        
        cell.addButton.tag = indexPath.row
        cell.addButton.addTarget(self, action: #selector(touchAddButton), for: .touchUpInside)
        cell.subButton.tag = indexPath.row
        cell.subButton.addTarget(self, action: #selector(touchSubButton), for: .touchUpInside)
        cell.countLabel.text = String(orderData[indexPath.row])
        
        if let count = cell.countLabel.text{
            self.getOrderData[indexPath.row].orderedCount = count
        }
        
        return cell
    }
    
    
    
    
}

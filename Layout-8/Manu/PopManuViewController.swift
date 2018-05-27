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
    
    var foodName = [String]()
    var foodPrice = [String]()
    var myShopName = String()
    var foodNumberSelected = Int()
    var labelCount = UILabel()
    var counter = 0
    var counter1 = 0
    lazy var myShopFoodCount = Int()
    var orderData = [Int]()
    var countValue = 0
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFoodCount()
        backButton.addTarget(self, action: #selector(backToShop), for: .touchUpInside)
        let nibCell = UINib(nibName: MyCollectionViewCellId, bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: MyCollectionViewCellId)
        //print("SecondViewCount:",myShopFoodCount)
        confirmButton.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
        
        
    }
    
    
    @objc func handleConfirm(){
        print("Save data in userdefault")
        var dataArray = [[String]]()
        
        for index in 0..<getOrderData.count{
            let array = [getOrderData[index].foodPriceData,getOrderData[index].orderedCount]
            let dictionary = [[getOrderData[index].foodNameData],array]
            dataArray += dictionary
        }
        
        UserDefaults.standard.set(dataArray, forKey: myShopName)
//        UserDefaults.standard.removeObject(forKey:myShopName)
//        UserDefaults.standard.set(orderData, forKey:myShopName)
        UserDefaults.standard.synchronize()
        dataArray.removeAll()
        
    }
    
    func getFoodCount(){
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
        if countValue < 1 {
            for _ in 0...myShopFoodCount+1 {
                orderData.append(0)
                let test = OrderData()
                getOrderData += [test]
            }
            countValue += 1
        }
        
        return myShopFoodCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCellId, for: indexPath) as! MyCollectionViewCell
        
        cell.addButton.tag = indexPath.row
        cell.addButton.addTarget(self, action: #selector(touchAddButton), for: .touchUpInside)
        cell.subButton.tag = indexPath.row
        cell.subButton.addTarget(self, action: #selector(touchSubButton), for: .touchUpInside)
        cell.countLabel.text = String(orderData[indexPath.row])
        
        if let count = cell.countLabel.text{
            self.getOrderData[indexPath.row].orderedCount = count
        }
        
        
        
        Database.database().reference().child("shopFOOD").child(myShopName).observeSingleEvent(of: .value, with: { (snapshot) in
            var foodNameArray = self.getFoodName(snapshot)
            var foodPriceArray = self.getFoodPrice(snapshot)
            cell.lbName.text = foodNameArray[indexPath.row]
            cell.lbPrice.text = "Price:\(foodPriceArray[indexPath.row])"
            
            self.getOrderData[indexPath.row].shopNameData = self.myShopName
            

            guard let name = cell.lbName.text else {return}
            self.getOrderData[indexPath.row].foodNameData = name
            
            guard let price = cell.lbPrice.text else {return}
            self.getOrderData[indexPath.row].foodPriceData = price
            
        }) { (error) in
            print("Error get food detail:",error)
        }
        
        return cell
    }
    
   
    
    
}

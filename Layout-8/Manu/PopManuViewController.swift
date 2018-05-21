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
    var foodName = [String]()
    var foodPrice = [String]()
    var myShopName = String()
    var foodNumberSelected = Int()
    var labelCount = UILabel()
    var counter = 0
    var counter1 = 0
    lazy var myShopFoodCount = Int()
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFoodCount()
        backButton.addTarget(self, action: #selector(backToShop), for: .touchUpInside)
        let nibCell = UINib(nibName: MyCollectionViewCellId, bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: MyCollectionViewCellId)
        //print("SecondViewCount:",myShopFoodCount)
        
        
        
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
        print(foodPrice)

        return foodPrice
    }
    
    func getFoodName(_ snapshot:DataSnapshot)->[String]{
        for food in snapshot.children.allObjects as! [DataSnapshot]{
            foodName += [food.key]
            
        }
        print(foodName)
        return foodName
    }
    
    @objc func touchAddButton(sender:Int){
        foodNumberSelected += 1
        print("4")
        collectionView.reloadData()
        
    }
    
}



extension PopManuViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return myShopFoodCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCellId, for: indexPath) as! MyCollectionViewCell
        
        if indexPath.row == 0{
            cell.addButton.addTarget(self, action: #selector(touchAddButton), for: .touchUpInside)
            
            counter += foodNumberSelected
            cell.countLabel.text = String(counter)
            foodNumberSelected = 0
            print("1")
           
        }
        
        if indexPath.row == 1{
            cell.addButton.addTarget(self, action: #selector(touchAddButton), for: .touchUpInside)
            counter1 += foodNumberSelected
            cell.countLabel.text = String(counter1)
            print("2")
            
        }
        
        Database.database().reference().child("shopFOOD").child(myShopName).observeSingleEvent(of: .value, with: { (snapshot) in
            var foodNameArray = self.getFoodName(snapshot)
            var foodPriceArray = self.getFoodPrice(snapshot)
            cell.lbName.text = foodNameArray[indexPath.row]
            cell.lbPrice.text = "Price:\(foodPriceArray[indexPath.row])"
        }) { (error) in
            print("Error get food detail:",error)
        }
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCellId, for: indexPath) as! MyCollectionViewCell
       
      
//        if indexPath.section == 1{
//            print("1")
////        labelCount = cell.countLabel
////        cell.addButton.addTarget(self, action: #selector(touchAddButton), for: .touchUpInside)
//        }
//        if indexPath.section == 2{
//            print("2")
//        }
     
    }
    

}


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
    var test = [Int]()
    var countValue = 0
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
        for index in test.indices{
            if index == sender.tag{
                let value = test[index]
                test[index] = value + 1
            }
        }
        
        collectionView.reloadData()
        
    }
    
    @objc func touchSubButton(_ sender:UIButton){
        for index in test.indices{
            if index == sender.tag{
                let value = test[index]
                if value > 0 {
                    test[index] = value - 1
                }else{
                    test[index] = 0
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
                test.append(0)
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
        cell.countLabel.text = String(test[indexPath.row])
        
        
        
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
    
    
    
    
}

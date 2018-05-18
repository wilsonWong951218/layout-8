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
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.addTarget(self, action: #selector(backToShop), for: .touchUpInside)
        
        let nibCell = UINib(nibName: MyCollectionViewCellId, bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: MyCollectionViewCellId)
       
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
    
}

extension PopManuViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyCollectionViewCellId, for: indexPath) as! MyCollectionViewCell
        Database.database().reference().child("shopFOOD").child("Shop1").observeSingleEvent(of: .value, with: { (snapshot) in
            var foodNameArray = self.getFoodName(snapshot)
            var foodPriceArray = self.getFoodPrice(snapshot)
            cell.lbName.text = foodNameArray[indexPath.row]
            cell.lbPrice.text = foodPriceArray[indexPath.row]
        }) { (error) in
                print("Error get food detail:",error)
        }
        
        return cell
    }
    
}


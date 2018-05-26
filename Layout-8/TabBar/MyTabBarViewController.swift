//
//  MyTabBarViewController.swift
//  Layout-8
//
//  Created by Macintosh on 2018/5/25.
//  Copyright © 2018年 LAT. All rights reserved.
//

import UIKit
import Firebase
class MyTabBarViewController: UITabBarController {
    var orderClass = OrderManuViewController()
   var shopName = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1{
            print("a")
            
            Database.database().reference().child("shopFOOD").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                print(snapshot.value ?? "")
                for food in (snapshot.children.allObjects as! [DataSnapshot]){
                    
                    print("Food:", food.key)
                    self.shopName.append(food.key)
                }
            }) { (error) in
                print("Error:\(error)")
            }
            orderClass.tableArrayFinal = shopName
           
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

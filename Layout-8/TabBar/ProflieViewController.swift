//
//  ProflieViewController.swift
//  Layout-8
//
//  Created by Macintosh on 2018/5/16.
//  Copyright © 2018年 LAT. All rights reserved.
//

import UIKit
import Firebase
class ProflieViewController: UIViewController, UITableViewDelegate ,UITableViewDataSource{
    

    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var tableViewShop: UITableView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    var shopName = [String]()
   lazy var shopFoodCount = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePic.layer.cornerRadius = 160/2
        profilePic.clipsToBounds = true
        logoutButton.addTarget(self, action: #selector(handleLogOut), for: .touchUpInside)
        getDBvalueUser()
        getDBvalueShop()
        getCount()
        
  
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addShopName = segue.destination as! PopManuViewController
        guard let shopNumber = tableViewShop.indexPathForSelectedRow?.row else {return}
        addShopName.myShopName = shopName[shopNumber]

    }
    
    
    fileprivate func getCount(){
        guard let shopNumberCount = tableViewShop.indexPathForSelectedRow?.row else {return}
        Database.database().reference().child("shopFOOD").child(shopName[shopNumberCount]).observeSingleEvent(of: DataEventType.value) { (snapshot) in
            self.shopFoodCount = Int(snapshot.childrenCount)
        }
    }
    @objc func handleLogOut(){
        try! Auth.auth().signOut()
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UIViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    fileprivate func getDBvalueShop(){
        Database.database().reference().child("shopFOOD").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            print(snapshot.value ?? "")
            for food in (snapshot.children.allObjects as! [DataSnapshot]){
                
                //print("Food:", food.key)
                self.shopName.append(food.key)
            }
            self.tableViewShop.reloadData()
         
        }) { (error) in
            print("Error:\(error)")
        }
    }
    
   fileprivate func getDBvalueUser(){
        guard let uid = Auth.auth().currentUser?.uid else{return}
        Database.database().reference().child("User:").child(uid).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            print(snapshot.value ?? "")
            self.setProfileImage(snapshot)
            self.setUsername(snapshot)
        }) { (error) in
            print("Error:\(error)")
        }
    }
    
    fileprivate func setUsername(_ snapshot:DataSnapshot){
        guard let dictionart = snapshot.value as? [String:Any] else {return}
        guard let profileUserName = dictionart["Username"] as? String else {return}
        self.userName.text = profileUserName
    }
    
    
    fileprivate func setProfileImage(_ snapshot:DataSnapshot){
        guard let dictionary = snapshot.value as? [String: Any] else {return}
        guard let profileImageURL = dictionary["ProfileImage"] as? String else {return}
        guard let url = URL(string: profileImageURL) else {return}
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let err = error{
                print("get proflie image error:\(err)")
                return
            }
            
            guard let data = data else {return}
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.profilePic.image = image
            }
        }).resume()
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = shopName[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getCount()
     performSegue(withIdentifier: "shopOneManu", sender: nil)
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("cc")
    }
    
}

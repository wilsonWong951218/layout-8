//
//  Shop1ManuViewController.swift
//  Layout-8
//
//  Created by Macintosh on 2018/5/17.
//  Copyright © 2018年 LAT. All rights reserved.
//

import UIKit

class Shop1ManuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFoodDetail()
        // Do any additional setup after loading the view.
    }

    fileprivate func getFoodDetail(){
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        
        
        return cell
    }

}


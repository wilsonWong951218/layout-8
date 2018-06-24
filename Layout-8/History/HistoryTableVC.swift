//
//  HistoryTableVC.swift
//  Layout-8
//
//  Created by Macintosh on 2018/6/25.
//  Copyright © 2018年 LAT. All rights reserved.
//

import UIKit

class HistoryTableVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrayId:[String]? = nil
    var UUid = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let id = UserDefaults.standard.array(forKey: "OrderID") as? [String]{
            arrayId = id
        }else{
            arrayId = nil
        }
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

            self.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let popView = segue.destination as! HistoryPopVC
        popView.UUid = UUid
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = arrayId?.count else {return 0}
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        cell.textLabel?.text = arrayId?[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UUid = arrayId![indexPath.row]
        performSegue(withIdentifier: "HistoryPop", sender: nil)
    }

}

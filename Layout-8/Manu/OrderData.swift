//
//  OrderData.swift
//  Layout-8
//
//  Created by Macintosh on 2018/5/27.
//  Copyright © 2018年 LAT. All rights reserved.
//

import Foundation

class OrderData{
    var shopNameData = String()
    var foodNameData = String()
    var foodPriceData = String()
    var orderedCount = String()
    let uuid = UUID().uuidString
 
   
    func dictionaryCreate() -> [String:[String:String]]{
        let dictionary = [self.foodNameData:["Price":self.foodPriceData,"Count":self.orderedCount]]
        return dictionary
    }
    
    func dictionaryCreateShop() -> [String:[String:[String:String]]]{
        
        let dictionary = [self.shopNameData:[self.foodNameData:["Price":self.foodPriceData,"Count":self.orderedCount]]]
        return dictionary
    }
}

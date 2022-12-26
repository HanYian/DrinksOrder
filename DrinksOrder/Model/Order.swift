//
//  Menu.swift
//  DrinksOrder
//
//  Created by HanYuan on 2022/12/25.
//

import Foundation

struct Order : Codable {
    var records : [Records]
    
    struct Records : Codable {
        var fields : Fields
        var id : String?
        
        struct Fields : Codable {
            var name : String
            var drink : String
            var size : String
            var sugar : String
            var ice : String
            var toppings : String
            var price : Int
        }
    }
}


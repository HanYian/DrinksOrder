//
//  Menu.swift
//  DrinksOrder
//
//  Created by HanYuan on 2022/12/25.
//

import Foundation

struct Menu : Codable {
    var records : [Records]
    
    struct Records : Codable {
        var fields : Fields
        
        struct Fields : Codable {
            var drinks : String
            var priceM : Int
            var priceL : Int
        }
    }
}

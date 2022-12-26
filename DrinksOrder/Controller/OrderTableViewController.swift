//
//  OrderTableViewController.swift
//  DrinksOrder
//
//  Created by HanYuan on 2022/12/25.
//

import UIKit

class OrderTableViewController: UITableViewController {
    
    var orderArray = [Order.Records]()
    var deleteID = ""
    var totalPrice = 0
    
    @IBOutlet weak var totalNumLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    func total(counts: Int) {
        totalPrice = 0
        if counts == 0 {
            totalPrice = 0
        } else {
            for i in 0 ... counts - 1 {
                totalPrice += orderArray[i].fields.price
            }
        }
    }
    func fetchData(){
        let url = URL(string: "https://api.airtable.com/v0/appTs6qymQkFO6Zh5/Order?sort[][field]=createdtime")!
        var request = URLRequest(url: url)
        request.setValue("Bearer keypk9v3DoqGzBIeu", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, response, error in
            let decoder = JSONDecoder()
            if let data = data{
                do{
                    let Order = try decoder.decode(Order.self, from: data)
                    DispatchQueue.main.async {
                        self.orderArray = Order.records
                        self.total(counts: self.orderArray.count)
                        self.tableView.reloadData()
                        self.totalNumLabel.text = "\(self.orderArray.count)"
                        self.totalPriceLabel.text = "\(self.totalPrice)"
                    }
                }catch{
                    print(error)
                }
            }
        }.resume()
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        deleteID = orderArray[indexPath.row].id!
        orderArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        self.totalNumLabel.text = "\(self.orderArray.count)"
        self.totalPriceLabel.text = "\(self.totalPrice)"
        deleteOrder()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(OrderTableViewCell.self)", for: indexPath) as! OrderTableViewCell
        
        cell.name.text = "姓名：\(orderArray[indexPath.row].fields.name)"
        cell.drink.text = "飲品：\(orderArray[indexPath.row].fields.drink)"
        cell.size.text = "大小：\(orderArray[indexPath.row].fields.size)"
        cell.sugar.text = "甜度：\(orderArray[indexPath.row].fields.sugar)"
        cell.ice.text = "冰塊：\(orderArray[indexPath.row].fields.ice)"
        cell.toppings.text = "加料：\(orderArray[indexPath.row].fields.toppings)"
        cell.price.text = "金額：\(orderArray[indexPath.row].fields.price)"
        
        return cell
    }
    
    
    func deleteOrder(){
        
        let url = URL(string: "https://api.airtable.com/v0/appTs6qymQkFO6Zh5/Order/\(deleteID)")!
        var request = URLRequest(url: url)
        
        // 刪除該筆資料，httpMethod為DELETE
        request.setValue("Bearer keypk9v3DoqGzBIeu", forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        let confirmOrder = orderArray
        request.httpBody = try? encoder.encode(confirmOrder)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            do{
                DispatchQueue.main.async {
                    self.total(counts: self.orderArray.count)
                    self.totalNumLabel.text = "\(self.orderArray.count)"
                    self.totalPriceLabel.text = "\(self.totalPrice)"
                }
            }
        }.resume()
    }
}

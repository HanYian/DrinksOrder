//
//  TableViewController.swift
//  DrinksOrder
//
//  Created by HanYuan on 2022/12/25.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    var menuArray = [Menu.Records]()
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    @IBAction func unwindToMenuTableView(_ unwindSegue: UIStoryboardSegue) {
    }
    
    func fetchData(){
        let url = URL(string: "https://api.airtable.com/v0/appTs6qymQkFO6Zh5/Menu?sort[][field]=createdtime")!
        
        var request = URLRequest(url: url)
        request.setValue("Bearer keypk9v3DoqGzBIeu", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, response, error in
            let decoder = JSONDecoder()
            if let data = data{
                do{
                    let Menu = try decoder.decode(Menu.self, from: data)
                    DispatchQueue.main.async {
                        self.menuArray = Menu.records
                        self.tableView.reloadData()
                    }
                }catch{
                    print(error)
                }
            }
        }.resume()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(MenuTableViewCell.self)", for: indexPath) as! MenuTableViewCell
        cell.drinkLabel.text = menuArray[indexPath.row].fields.drinks
        
        
        
        return cell
    }
    
    
    @IBSegueAction func orderSegueAction(_ coder: NSCoder) -> OrderViewController? {
        let controller = OrderViewController(coder: coder)
        controller?.drink = menuArray[tableView.indexPathForSelectedRow!.row].fields.drinks
        controller?.priceM = menuArray[tableView.indexPathForSelectedRow!.row].fields.priceM
        controller?.priceL = menuArray[tableView.indexPathForSelectedRow!.row].fields.priceL
        return controller
    }
    
    
}

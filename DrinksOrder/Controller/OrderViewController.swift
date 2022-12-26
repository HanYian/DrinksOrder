//
//  OrderViewController.swift
//  DrinksOrder
//
//  Created by HanYuan on 2022/12/25.
//

import UIKit

class OrderViewController: UIViewController {
    
    //    var orderList = [Order.Records.Fields]()
    
    @IBOutlet weak var toppingsTextField: UITextField!
    @IBOutlet weak var iceSegmentedControl: UISegmentedControl!
    @IBOutlet weak var toppingsPickerView: UIPickerView!
    @IBOutlet weak var sugarSegmentedControl: UISegmentedControl!
    @IBOutlet weak var sizeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var drinkLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet var toppingsToolbar: UIToolbar!
    
    var name = String()
    var drink = String()
    var size = String()
    var sugar =  String()
    var ice = String()
    var toppings = String()
    var priceM = Int()
    var priceL = Int()
    var totalPrice = Int()
    
    let toppingsArray = ["無", "白玉 + $10","水玉 + $10","椰玉 + $10"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toppingsTextField.inputView = toppingsPickerView
        toppingsTextField.inputAccessoryView = toppingsToolbar
        drinkLabel.text = drink
        priceLabel.text = "\(priceL)"
    }
    
    //上傳訂單
    func uploadOrder(){
        
        let url = URL(string: "https://api.airtable.com/v0/appTs6qymQkFO6Zh5/order")!
        var request = URLRequest(url: url)
        
        request.setValue("Bearer keypk9v3DoqGzBIeu", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        let confirmOrder = Order.Records(fields: Order.Records.Fields(name: name, drink: drink, size: size, sugar: sugar, ice: ice, toppings: toppings, price: totalPrice))
        
        request.httpBody = try? encoder.encode(confirmOrder)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data{
                do {
                    let decoder = JSONDecoder()
                    let order = try decoder.decode(Order.self, from: data)
                    print(order)
                }catch{
                    print(error)
                }
            }
        }.resume()
    }
    //計算金額
    func total(row: Int) {
        if sizeSegmentedControl.selectedSegmentIndex == 0 {
            totalPrice = priceL
        } else {
            totalPrice = priceM
        }
        if row != 0 {
            totalPrice += 10
            priceLabel.text = "\(totalPrice)"
        } else {
            priceLabel.text = "\(totalPrice)"
        }
    }
    // 送出
    @IBAction func finishOrder(_ sender: UIButton) {
        name = nameTextField.text!
        total(row: toppingsPickerView.selectedRow(inComponent: 0))
        size = sizeSegmentedControl.titleForSegment(at: sizeSegmentedControl.selectedSegmentIndex)!
        sugar = sugarSegmentedControl.titleForSegment(at: sugarSegmentedControl.selectedSegmentIndex)!
        ice = iceSegmentedControl.titleForSegment(at: iceSegmentedControl.selectedSegmentIndex)!
        toppings = toppingsTextField.text ?? "無 + $0"
        if name == "" {
            let controller = UIAlertController(title: "請輸入姓名", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .default)
            controller.addAction(action)
            present(controller, animated: true, completion: nil)
        } else {
            let controller = UIAlertController(title: "訂單成功", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .default) { action in
                self.uploadOrder()
                self.performSegue(withIdentifier: "backToMenu", sender: nil)
            }
            controller.addAction(action)
            present(controller, animated: true, completion: nil)
        }
    }
    
    
    //加料
    @IBAction func selectDone(_ sender: UIBarButtonItem) {
        let row = toppingsPickerView.selectedRow(inComponent: 0)
        toppingsTextField.text = toppingsArray[row]
        total(row: row)
        view.endEditing(true)
    }
    
    @IBAction func selectCancel(_ sender: UIBarButtonItem) {
        view.endEditing(true)
    }
    
    //大杯小杯
    @IBAction func changeSize(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            totalPrice = priceL
            toppingsTextField.text = "無"
            priceLabel.text = "\(priceL)"
        } else {
            totalPrice = priceM
            toppingsTextField.text = "無"
            priceLabel.text = "\(priceM)"
        }
    }
    
}

extension OrderViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return toppingsArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return toppingsArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        toppingsTextField.text = toppingsArray[row]
    }
}

extension OrderViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

//
//  OrderTableViewCell.swift
//  DrinksOrder
//
//  Created by HanYuan on 2022/12/25.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var toppings: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var ice: UILabel!
    @IBOutlet weak var sugar: UILabel!
    @IBOutlet weak var drink: UILabel!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

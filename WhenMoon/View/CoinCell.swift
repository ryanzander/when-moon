//
//  CoinCell.swift
//  WhenMoon
//
//  Created by Ryan Zander on 1/25/18.
//  Copyright © 2018 Ryan Zander. All rights reserved.
//

import UIKit

class CoinCell: UITableViewCell {
    
    @IBOutlet var coinLogo: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var valueLbl: UILabel!
    @IBOutlet var amountLbl: UILabel!
    @IBOutlet var priceLbl: UILabel!
    @IBOutlet var changeLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  Top100Cell.swift
//  WhenMoon
//
//  Created by Ryan Zander on 5/13/18.
//  Copyright © 2018 Ryan Zander. All rights reserved.
//

import UIKit

class Top100Cell: UITableViewCell {
    
    @IBOutlet var coinLogo: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var symbolLbl: UILabel!
    @IBOutlet var rankLbl: UILabel!
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

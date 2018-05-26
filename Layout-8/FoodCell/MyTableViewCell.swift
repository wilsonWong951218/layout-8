//
//  MyTableViewCell.swift
//  Layout-8
//
//  Created by Macintosh on 2018/5/26.
//  Copyright © 2018年 LAT. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var lbFood: UILabel!
    @IBOutlet weak var lbShop: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

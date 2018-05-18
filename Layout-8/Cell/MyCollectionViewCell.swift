//
//  MyCollectionViewCell.swift
//  uicollectionviewcell-from-xib
//
//  Created by bett on 8/18/17.
//  Copyright © 2017 bett. All rights reserved.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var lbName: UILabel!
    
    @IBOutlet weak var lbPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

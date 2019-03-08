//
//  MenuTableViewCell.swift
//  SOS Ciclista
//
//  Created by i7 on 3/7/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var nameText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

        // Configure the view for the selected state
    }

}

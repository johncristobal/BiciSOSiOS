//
//  TipTableViewCell.swift
//  SOS Ciclista
//
//  Created by John A. Cristobal on 4/22/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit

class TipTableViewCell: UITableViewCell {

    @IBOutlet var tipText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

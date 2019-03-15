//
//  celdaBiciCollectionViewCell.swift
//  SOS Ciclista
//
//  Created by John A. Cristobal on 3/14/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit

class celdaBiciCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var biciImage: UIImageView!
    
    override var isSelected: Bool{
        didSet{
            self.contentView.backgroundColor = isSelected ? UIColor.lightGray : UIColor.white            
        }
    }
}

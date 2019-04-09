//
//  Custompin.swift
//  SOS Ciclista
//
//  Created by John A. Cristobal on 3/11/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit
import MapKit

class Custompin: MKAnnotationView {

    @IBOutlet var imageOutel: UIImageView!
    var id: String!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

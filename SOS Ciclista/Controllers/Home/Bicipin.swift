//
//  Bicipin.swift
//  SOS Ciclista
//
//  Created by John A. Cristobal on 5/14/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit
import MapKit

protocol MapMarkerDelegate: class {
    func didTapInfoButton(data: NSDictionary)
}

class Bicipin: NSObject, MKAnnotation {

    @IBOutlet var biciimage: UIImageView!
    var id: String!
    
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    var markerTintColor: UIColor  {
        switch discipline {
        case "Monument":
            return .red
        case "Mural":
            return .cyan
        case "Plaque":
            return .blue
        case "Sculpture":
            return .purple
        default:
            return .green
        }
    }
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

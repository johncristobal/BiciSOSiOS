//
//  Bicipinview.swift
//  SOS Ciclista
//
//  Created by i7 on 5/14/19.
//  Copyright © 2019 i7. All rights reserved.
//

import Foundation
import MapKit

@available(iOS 11.0, *)
class Bicipinview: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            // 1
            guard let artwork = newValue as? Bicipin else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            // 2
            markerTintColor = artwork.markerTintColor
            glyphText = String(artwork.discipline.first!)
        }
    }
}

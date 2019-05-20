//
//  Biker.swift
//  SOS Ciclista
//
//  Created by John A. Cristobal on 5/20/19.
//  Copyright © 2019 i7. All rights reserved.
//

import Foundation

struct Biker: Codable{
    var id: String
    var name: String
    var bici: Int
    var latitud: Double
    var longitude: Double
    
    init(id: String, name:String, bici:Int, latitud: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.bici = bici
        self.latitud = latitud
        self.longitude = longitude
    }
}

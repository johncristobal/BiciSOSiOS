//
//  Report.swift
//  SOS Ciclista
//
//  Created by John A. Cristobal on 3/20/19.
//  Copyright © 2019 i7. All rights reserved.
//

import Foundation

struct Report: Codable{
    var id: String
    var name: String
    var serie: String
    var description: String
    var estatus: Int
    var date: String
    var fotos: String
    var tipo: Int
    var latitude: Double
    var longitude: Double

    init(id: String, name:String, serie:String, description:String, estatus: Int, date: String, fotos: String, tipo:Int, latitude: Double, longitude:Double) {
        self.id = id
        self.name = name
        self.serie = serie
        self.description = description
        self.estatus = estatus
        self.date = date
        self.fotos = fotos
        self.tipo = tipo
        self.latitude = latitude
        self.longitude = longitude
    }
}

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
    var title: String
    var description: String
    var estatus: String
    
    init(id: String, title:String, description:String, estatus: String) {
        self.id = id
        self.title = title
        self.description = description
        self.estatus = estatus
    }
}

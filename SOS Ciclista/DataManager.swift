//
//  DataManager.swift
//  SOS Ciclista
//
//  Created by i7 on 3/10/19.
//  Copyright © 2019 i7. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DataManager{
    
    static let shared = DataManager()
    
    func getTalleres(api: String, completion: @escaping (([String]) -> Void )) {
        var ip = "http://xatsaautopartes.xyz/Api/Api/productos"
        
        Alamofire.request(
            ip,
            method: .get,
            parameters: nil,
            headers: nil).responseJSON(completionHandler: { (response) in
                //print(response.result.value)
                var datos = JSON(response.result.value)
                print(datos)
            })
        
        completion([])
    }
}

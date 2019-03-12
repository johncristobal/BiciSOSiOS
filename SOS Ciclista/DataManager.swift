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
    var ip = "http://xatsaautopartes.xyz/soscilistaapi/"
    
    func getTalleres(api: String, completion: @escaping (([Taller]) -> Void )) {
        let ip = "\(self.ip)api/talleres"
        let jsonDecoder = JSONDecoder()
        
        Alamofire.request(
            ip,
            method: .get,
            parameters: nil,
            headers: nil).responseJSON(completionHandler: { (response) in
                //print(response.result.value)
                //var datos = JSON(response.result.value)
                //print(datos)
                let tallers = try! jsonDecoder.decode([Taller].self, from: response.data!)

                //print(tallers)
                completion(tallers)
            })
    }
}

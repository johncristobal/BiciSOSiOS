//
//  AveriaViewController.swift
//  SOS Ciclista
//
//  Created by i7 on 6/1/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import CoreLocation

class AveriaViewController: UIViewController {

    @IBOutlet weak var detallesText: UITextField!
    @IBOutlet weak var averiaIcon: UIButton!
    var location : CLLocation? = nil
    
    let nameNot = Notification.Name("gracias")

    @IBOutlet var backButton: UIButton!
    @IBOutlet var sendButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.7)

        self.hero.isEnabled = true
        averiaIcon.hero.id = "averia"
        
      addToolBar(textField: detallesText)
        
        backButton.borderButton()
        sendButton.borderButton()
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendReportAction(_ sender: Any) {
        
        if detallesText.text == ""{
            showmessage(message: "Describe tu averia...", controller: self)
        }else{
            let name = UserDefaults.standard.string(forKey: "nombre")
            let serie = UserDefaults.standard.string(forKey: "serie")
            let desc = detallesText.text
            
            let fecha = Date()
            let formatted = DateFormatter()
            formatted.dateFormat = "dd/MM/yyy"
            let fechaString = formatted.string(from: fecha)
            
            let ref = Database.database().reference()
            let thisUsersGamesRef = ref.child("reportes").childByAutoId()
            thisUsersGamesRef.setValue(
                [
                    "id":thisUsersGamesRef.key,
                    "name":name!,
                    "serie":serie!,
                    "description":desc!,
                    "estatus": 1,
                    "date":fechaString,
                    "fotos": "sinfotos",
                    "tipo": 2,
                    "latitude": location?.coordinate.latitude,
                    "longitude": location?.coordinate.longitude
                ]
            ){(error:Error?, ref:DatabaseReference) in
                if let error = error {
                    print("Data could not be saved: \(error).")
                } else {
                    print("Data saved successfully!")
                    self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: {
                            NotificationCenter.default.post(name: self.nameNot, object: nil)
                        
                    })
                    //self.performSegue(withIdentifier: "gracias", sender: nil)

                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

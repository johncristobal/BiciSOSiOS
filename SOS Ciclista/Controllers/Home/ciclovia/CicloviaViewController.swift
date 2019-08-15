//
//  CicloviaViewController.swift
//  SOS Ciclista
//
//  Created by John A. Cristobal on 6/3/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import CoreLocation

class CicloviaViewController: UIViewController {

    @IBOutlet var textDetails: UITextField!
    @IBOutlet var cicloviaIcon: UIButton!
    var location : CLLocation? = nil
    let nameNot = Notification.Name("gracias")

    @IBOutlet var backButton: UIButton!
    @IBOutlet var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.7)
        
        self.hero.isEnabled = true
        cicloviaIcon.hero.id = "ciclovia"
        // Do any additional setup after loading the view.
        
        addToolBar(textField: textDetails)
        
        backButton.borderButton()
        sendButton.borderButton()
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func sendAction(_ sender: Any) {
        if textDetails.text == ""{
            showmessage(message: "Describe la ciclovía brevemente...", controller: self)
        }else{
            let name = UserDefaults.standard.string(forKey: "nombre")
            let serie = UserDefaults.standard.string(forKey: "serie")
            let desc = textDetails.text
            
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
                    "tipo": 3,
                    "latitude": location?.coordinate.latitude,
                    "longitude": location?.coordinate.longitude
                ]
            ){(error:Error?, ref:DatabaseReference) in
                if let error = error {
                    print("Data could not be saved: \(error).")
                } else {
                    print("Data saved successfully!")
                    //self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
                    self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: {
                        NotificationCenter.default.post(name: self.nameNot, object: nil)
                        
                    })
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

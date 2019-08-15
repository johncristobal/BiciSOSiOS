//
//  ContactoViewController.swift
//  SOS Ciclista
//
//  Created by John A. Cristobal on 4/23/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit
import SafariServices

class ContactoViewController: UIViewController {

    @IBOutlet var textMessage: UITextField!
    @IBOutlet var vistaAmarilla: UIView!
    @IBOutlet var vistaContacto: UIView!
    @IBOutlet var buttonSend: UIButton!
    
    @IBOutlet var textoContacto: UITextField!
    @IBOutlet var faceIcon: UIImageView!
    @IBOutlet var twitterIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        vistaAmarilla.borderAmarillo()
        vistaContacto.borderButton()
        buttonSend.borderButton()
        
        addToolBar(textField: textMessage)
        
        let gestureFace = UITapGestureRecognizer(target: self, action: #selector(showFace))
        let gestureTwit = UITapGestureRecognizer(target: self, action: #selector(showTwitter))
        
        faceIcon.isUserInteractionEnabled = true
        twitterIcon.isUserInteractionEnabled = true

        faceIcon.addGestureRecognizer(gestureFace)
        twitterIcon.addGestureRecognizer(gestureTwit)
    }
    
    @objc func showFace(){
        
        let appURL = URL(string: "fb://profile/266612746861233/")!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            if let url = URL(string: "https://www.facebook.com/groups/266612746861233/") {
                let vc = SFSafariViewController(url: url)
                present(vc, animated: true)
            }
        }
    }

    @objc func showTwitter(){
        let appURL = URL(string: "twitter://user?screen_name=BiciRobos_SOSmx")!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            
            if let url = URL(string: "https://twitter.com/BiciRobos_SOSmx?lang=es") {
                let vc = SFSafariViewController(url: url)
                present(vc, animated: true)
            }
        }

    }

    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionSend(_ sender: Any) {
        
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

//
//  RegisterViewController.swift
//  SOS Ciclista
//
//  Created by John A. Cristobal on 7/29/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet var loadingRegister: UIActivityIndicatorView!
    @IBOutlet var nameText: UITextField!
    @IBOutlet var mailText: UITextField!
    @IBOutlet var passText: UITextField!
    @IBOutlet var passDosText: UITextField!
    @IBOutlet var buttonRegister: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registrarAction(_ sender: Any) {
        
        //recupèramos datos de los campos, validamos y hacemos el auth fikrebasde
        if datosCorrectos(){
            
        }
        print("acces firebase with enail and pass")
        UserDefaults.standard.set("1", forKey: "sesion")
        UserDefaults.standard.set("register", forKey: "from")
        UserDefaults.standard.set("registro prueba", forKey: "nombre")
        
        //NotificationCenter.default.post(name: self.namelog, object: nil)
        
        //self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "personaliza", sender: nil)
    }
    
    func datosCorrectos() -> Bool{
        if nameText.text == ""{
            showmessage(message: "Coloca un nombre de usuario...", controller: self)
            return false
        }
        if mailText.text == ""{
            return false
        }
        if passText.text == ""{
            return false
        }
        if passDosText.text == ""{
            return false
        }
        if passText.text != passDosText.text{
            return false
        }
        
        return true
    }
    
    @IBAction func closeWdinow(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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

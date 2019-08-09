//
//  RegisterViewController.swift
//  SOS Ciclista
//
//  Created by John A. Cristobal on 7/29/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit
import FirebaseAuth

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
        addToolBar(textField: nameText)
        addToolBar(textField: mailText)
        addToolBar(textField: passText)
        addToolBar(textField: passDosText)
    }
    
    @IBAction func registrarAction(_ sender: Any) {
        
        loadingRegister.isHidden = false
        buttonRegister.setTitle("", for: .normal)
        
        //recupèramos datos de los campos, validamos y hacemos el auth fikrebasde
        if datosCorrectos(){
            Auth.auth().fetchProviders(forEmail: mailText.text!) { (providers, error) in
                if providers == nil {
                    // user doesn't exist
                    Auth.auth().createUser(withEmail: self.mailText.text!, password: self.passText.text!) { (user, error) in
                        if let e = error{
                            //callback?(e)
                            self.loadingRegister.isHidden = true
                            self.buttonRegister.setTitle("Registrar", for: .normal)
                            showmessage(message: "Error al crear usuario, intente más tarde...", controller: self)
                            return
                        }
                        //callback?(nil)
                        print("acces firebase with email and pass")
                        UserDefaults.standard.set("1", forKey: "sesion")
                        UserDefaults.standard.set("register", forKey: "from")
                        UserDefaults.standard.set(self.nameText.text!, forKey: "nombre")
                        
                        //NotificationCenter.default.post(name: self.namelog, object: nil)
                        
                        //self.dismiss(animated: true, completion: nil)
                        self.performSegue(withIdentifier: "personaliza", sender: nil)
                    }
                } else {
                    self.loadingRegister.isHidden = true
                    self.buttonRegister.setTitle("Registrar", for: .normal)
                    // user does exist
                    showmessage(message: "El correo ya existe, inicia sesión...", controller: self)
                }
            }
        }
    }
    
    func datosCorrectos() -> Bool{
        if nameText.text == ""{
            showmessage(message: "Favor de colocar nombre de usuario...", controller: self)
            return false
        }
        if mailText.text == ""{
            showmessage(message: "Favor de colocar correo...", controller: self)
            return false
        }
        if passText.text == ""{
            showmessage(message: "Favor de colocar contraseña...", controller: self)
            return false
        }
        if passDosText.text == ""{
            showmessage(message: "Favor de colocar contraseña...", controller: self)
            return false
        }
        if passText.text != passDosText.text{
            showmessage(message: "Las contraseñas no coinciden...", controller: self)
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

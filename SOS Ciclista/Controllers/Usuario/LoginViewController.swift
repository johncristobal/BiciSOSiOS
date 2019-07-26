//
//  LoginViewController.swift
//  SOS Ciclista
//
//  Created by John A. Cristobal on 3/19/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet var faceButton: UIButton!
    @IBOutlet var loadingFace: UIActivityIndicatorView!
    @IBOutlet weak var ingresarButton: UIButton!
    
    let namelog = Notification.Name("loggin")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ingresarButton.borderButton()
        
        if UserDefaults.standard.string(forKey: "sesion") == "1"{
             faceButton.setTitle("Salir", for: .normal)
        }else{
             faceButton.setTitle("Continuar con facebook", for: .normal)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /*if AccessToken.current != nil{
            self.performSegue(withIdentifier: "personaliza", sender: nil)
        }else{
            print("no")
        }*/
    }
    
    @IBAction func closeWindow(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func faceAction(_ sender: Any) {
        
        faceButton.setTitle("", for: .normal)
        loadingFace.isHidden = false
        
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.email, .publicProfile], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                print(grantedPermissions)
                print(declinedPermissions)
                print(accessToken)
                
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)

                //Now lets authenticate firebase
                Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                        if let error = error {
                            // ...
                            print("erorr \(error)")
                            return
                        }
                        // User is signed in
                        // ...
                        print("acces firebase with facebook")
                        UserDefaults.standard.set("1", forKey: "sesion")
                        UserDefaults.standard.set("login", forKey: "from")
                        print(authResult?.user.displayName!)
                        UserDefaults.standard.set(authResult?.user.displayName!, forKey: "nombre")
                    
                    NotificationCenter.default.post(name: self.namelog, object: nil)

                        //self.dismiss(animated: true, completion: nil)
                        self.performSegue(withIdentifier: "personaliza", sender: nil)
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

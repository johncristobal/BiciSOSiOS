//
//  DetalleReporteViewController.swift
//  SOS Ciclista
//
//  Created by i7 on 4/13/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

import Alamofire
import AlamofireImage

class DetalleReporteViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var reporteDoneLabel: UILabel!
    @IBOutlet weak var nameOutlet: UILabel!
    @IBOutlet weak var fotosCollection: UICollectionView!
    @IBOutlet weak var vistaAmarilla: UIView!
    @IBOutlet weak var serieOutlet: UILabel!
    @IBOutlet weak var descriptionOutlet: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var reportarButton: UIButton!
    
    var report: Report? = nil
    var fotosArray: [String] = []
    
    var reporteRef: StorageReference? = nil
    let nameNot = Notification.Name("tabla")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(white: 0.0, alpha: 0.7)

        // Do any additional setup after loading the view.
        vistaAmarilla.borderAmarillo()
        
        nameOutlet.text = report?.name
        serieOutlet.text = report?.serie
        descriptionOutlet.text = report?.description
        
        let fotos = report?.fotos.components(separatedBy: ",")
        for word in fotos!{
            if word != ""{
                fotosArray.append(word)
            }
        }
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        reporteRef = storageRef.child("reportes")
        
        fotosCollection.reloadData()
        
        cancelButton.borderButton()
        reportarButton.borderButton()

        let reportado = UserDefaults.standard.string(forKey: "fromAlerta")
        
        if reportado != nil{
            if reportado == "1"{
                UserDefaults.standard.set("0", forKey: "fromAlerta")
                reporteDoneLabel.isHidden = false
            }else{
                reporteDoneLabel.isHidden = true
            }
        }else{
            reporteDoneLabel.isHidden = true
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        NotificationCenter.default.post(name: nameNot, object: nil)

        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reportarAction(_ sender: Any) {
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fotosArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let celda = collectionView.dequeueReusableCell(withReuseIdentifier: "celdaBicidos", for: indexPath) as! DetalleCeldaCollectionViewCell
        
        let refFinal = reporteRef!.child(report!.id).child(fotosArray[indexPath.row])
        
        refFinal.downloadURL { (url, error) in
            if error != nil{
                print("error")
            }else{
                Alamofire.request(url!).responseImage { response in
                    if let image = response.result.value {
                        let finalimage = image.pngData()//(compressionQuality: 0.25)
                        celda.fotobici.image = UIImage(data: finalimage!)
                    }
                }
            }
        }
        return celda
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

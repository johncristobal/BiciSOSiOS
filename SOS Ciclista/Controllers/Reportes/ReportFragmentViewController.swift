//
//  ReportFragmentViewController.swift
//  SOS Ciclista
//
//  Created by i7 on 4/6/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit
import MobileCoreServices
import BSImagePicker
import BSImageView
import Photos

import Firebase
import FirebaseDatabase
import CoreLocation

class ReportFragmentViewController: UIViewController {
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var serieText: UITextField!
    @IBOutlet weak var detailsText: UITextField!
    @IBOutlet weak var viewData: UIView!
    @IBOutlet weak var cancelarButton: UIButton!
    
    @IBOutlet weak var reportarButton: UIButton!
    
    var flag = false
    
    var ancho : CGFloat!
    var alto : CGFloat!
    var selected : [UIImage]! = [UIImage(named: "cameraicon")!,UIImage(named: "cameraicon")!,UIImage(named: "cameraicon")!,UIImage(named: "cameraicon")!]
    
    var flags : [Bool] = [false,false,false,false]
    var index = -1

    let name = Notification.Name("tabla")

    var location : CLLocation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.7)

        let name = UserDefaults.standard.string(forKey: "nombre")
        if name != nil{
            nameText.text = name
        }
        let serie = UserDefaults.standard.string(forKey: "serie")
        if serie != nil{
            serieText.text = serie
        }
        let desc = UserDefaults.standard.string(forKey: "desc")
        if desc != nil{
            detailsText.text = desc
        }
        
        addToolBar(textField: nameText)
        addToolBar(textField: serieText)
        addToolBar(textField: detailsText)
        
        cancelarButton.borderButton()
        reportarButton.borderButton()
    }

    override func donePressed() {
        view.endEditing(true)
    }
    
    @IBAction func cancelReport(_ sender: Any) {
        NotificationCenter.default.post(name: name, object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveReport(_ sender: Any) {
        
        //antes de dismiss...tenemos que guarda datos
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        let name = "bici"
        var fotos = ""
        for index in 0...3 {
            let complete = path.appending("/\(name)_\(index).png")
            if FileManager.default.fileExists(atPath: complete){
                fotos += "\(name)_\(index).png,"
            }
        }
        
        //1. guardar json con reporte: nombre, serie, descripcion, id, estatus, fecha
        let fecha = Date()
        let formatted = DateFormatter()
        formatted.dateFormat = "dd/MM/yyy"
        let fechaString = formatted.string(from: fecha)
        
        let ref = Database.database().reference()
        let thisUsersGamesRef = ref.child("reportes").childByAutoId()
        thisUsersGamesRef.setValue(
            [
                "id":thisUsersGamesRef.key,
                "name":nameText.text!,
                "serie":serieText.text!,
                "description":detailsText.text!,
                "estatus": 1,
                "date":fechaString,
                "fotos": fotos,
                "tipo": 1,
                "latitude": location?.coordinate.latitude,
                "longitude": location?.coordinate.longitude
            ]
        ){(error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
                UserDefaults.standard.set("1", forKey: "reportado")
                UserDefaults.standard.set(thisUsersGamesRef.key, forKey: "llavereporte")
            }
        }

        //2. guardar fotos en storage con id json
        //recuperamos fotos en arreglo
        //referencia a stoarge
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let reporteRef = storageRef.child("reportes").child(thisUsersGamesRef.key!)
        
        for index in 0...3 {
            let complete = path.appending("/\(name)_\(index).png")
            if FileManager.default.fileExists(atPath: complete){
                
                let iamgeBici = UIImage(contentsOfFile: complete)!
                let data = iamgeBici.pngData()
                let finalRef = reporteRef.child("/\(name)_\(index).png")
                finalRef.putData(data!, metadata: nil) { (meta, error) in
                    guard let metadata = meta else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    
                    // Metadata contains file metadata such as size, content-type.
                    let size = meta!.size
                    // You can also access to download URL after upload.
                    finalRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            // Uh-oh, an error occurred!
                            return
                        }
                    }
                }
            }
        }
        
        performSegue(withIdentifier: "finalReporte", sender: nil)
        //dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPhotos(_ sender: Any) { 
        let fotos = UserDefaults.standard.string(forKey: "fotos")
        
        if fotos == "1"{
            //photos saved, launch same images
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path
            
            let name = "bici"
            for index in 0...3 {
                let complete = path.appending("/\(name)_\(index).png")
                if FileManager.default.fileExists(atPath: complete){
                    selected[index] = UIImage(contentsOfFile: complete)!
                }else{
                    selected[index] = UIImage(named: "cameraicon")!
                }
            }
            
            performSegue(withIdentifier: "fotosReporte", sender: selected)
        }else{
            let vc = BSImagePickerViewController()
            vc.maxNumberOfSelections = 4
            bs_presentImagePickerController(vc,animated: true, select: { (asset: PHAsset) -> Void in
                                                
            }, deselect: { (asset: PHAsset) -> Void in
                // User deselected an assets.
                // Do something, cancel upload?
            }, cancel: { (assets: [PHAsset]) -> Void in
                // User cancelled. And this where the assets currently selected.
                
            }, finish: { (assets: [PHAsset]) -> Void in
                // User finished with these assets
                //self.dismiss(animated: true, completion: nil)
                var ii = 0
                assets.forEach { (asset) in
                    self.selected[ii]=(self.getAssetThumbnail(asset: asset))
                    ii += 1
                }
                self.flag = true
                
            }, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if flag{
            flag = false
            performSegue(withIdentifier: "fotosReporte", sender: selected)
        }
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 150, height:  150), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return UIImage(data: thumbnail.jpeg(.low)!)!
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "fotosReporte"{
            let vc = segue.destination as! PhotosBiciViewController
            vc.selected = sender as? [UIImage]
        }
    }
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


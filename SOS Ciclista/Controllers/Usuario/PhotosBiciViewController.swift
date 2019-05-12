//
//  PhotosViewController.swift
//  SOS Ciclista
//
//  Created by John A. Cristobal on 3/22/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit
import Photos
import BSImagePicker
import BSImageView

class PhotosBiciViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var biciA: UIImageView!
    @IBOutlet var biciB: UIImageView!
    @IBOutlet var biciC: UIImageView!
    @IBOutlet var biciD: UIImageView!
    @IBOutlet weak var botonAceptar: UIButton!
    @IBOutlet var vistaAmarilla: UIView!
    var flag = false
    
    var ancho : CGFloat!
    var alto : CGFloat!
    var selected : [UIImage]! = []
    var flags : [Bool] = [false,false,false,false]
    var index = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ancho = biciA.frame.width
        alto = biciA.frame.height
        
        //view.backgroundColor = UIColor(white: 0.0, alpha: 0.2)

        let yellow : UIColor = UIColor( red: 255.0/255.0, green: 216.0/255.0, blue:0, alpha: 1.0)
        vistaAmarilla.layer.masksToBounds = true
        vistaAmarilla.layer.borderColor = yellow.cgColor
        vistaAmarilla.layer.borderWidth = 3.0
        vistaAmarilla.layer.cornerRadius = 15.0

        botonAceptar.borderButton()

        let gestureA = TapGesture(target: self,action: #selector(self.updatePhoto))
        gestureA.title = 0
        let gestureB = TapGesture(target: self,action: #selector(self.updatePhoto))
        gestureB.title = 1
        let gestureC = TapGesture(target: self,action: #selector(self.updatePhoto))
        gestureC.title = 2
        let gestureD = TapGesture(target: self,action: #selector(self.updatePhoto))
        gestureD.title = 3
        biciA.isUserInteractionEnabled = true
        biciB.isUserInteractionEnabled = true
        biciC.isUserInteractionEnabled = true
        biciD.isUserInteractionEnabled = true
        
        biciA.addGestureRecognizer(gestureA)
        biciB.addGestureRecognizer(gestureB)
        biciC.addGestureRecognizer(gestureC)
        biciD.addGestureRecognizer(gestureD)
        
        showPhotos()

        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)

    }
    
    @objc func updatePhoto(sender: TapGesture){
        print(sender.title)
        index = sender.title
        
        if flags[sender.title]{
            //true => alert con opciones
            let alert = UIAlertController(title: "Tu bici", message: "", preferredStyle: .actionSheet)
            
            let actionFoto = UIAlertAction(title: "Elegir otra foto", style: .default) { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .savedPhotosAlbum
                    imagePicker.allowsEditing = false
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }
            let actionBorrar = UIAlertAction(title: "Borrar foto", style: .default) { (action) in
                
                let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path
                let complete = path.appending("/bici_\(self.index).png")
                if FileManager.default.fileExists(atPath: complete){
                    do{
                        try FileManager.default.removeItem(atPath: complete)
                    } catch {
                        print("Error al elimiar foto")
                    }
                }

                self.selected[self.index] = UIImage(named: "cameraicon")!
                
                switch(self.index){
                case 0:
                    self.flags[0] = false
                    self.biciA.image = UIImage(named: "cameraicon")
                    break
                case 1:
                    self.flags[1] = false
                    self.biciB.image = UIImage(named: "cameraicon")
                    break
                case 2:
                    self.flags[2] = false
                    self.biciC.image = UIImage(named: "cameraicon")
                    break
                case 3:
                    self.flags[3] = false
                    self.biciD.image = UIImage(named: "cameraicon")
                    break
                default: break
                }
            }
            let action = UIAlertAction(title: "Cancelar", style: .cancel) { (action) in
                
            }
            
            alert.addAction(action)
            alert.addAction(actionFoto)
            alert.addAction(actionBorrar)
            
            present(alert,animated: true)
            

        }else{
            //abrismo galeria
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .savedPhotosAlbum
                imagePicker.allowsEditing = false
                
                present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            let dato = UIImage(data: image.jpeg(.low)!)!
            self.selected[index] = dato
            showPhotos()
        }
    }
    
    @objc func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismiss(animated: true, completion: nil)
        let dato = UIImage(data: image.jpeg(.low)!)!
        self.selected[index] = dato
        
        showPhotos()
    }
    
    class TapGesture: UITapGestureRecognizer {
        var title = Int()
    }
    
    @IBAction func savePhotos(_ sender: Any) {
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path

        let name = "bici"
        var i = 0
        selected.forEach { (image) in
            
            if image != UIImage(named: "cameraicon"){
                let data = image.jpegData(compressionQuality: 0.9)
                let complete = path.appending("/\(name)_\(i).png")
                if FileManager.default.fileExists(atPath: complete){
                    do{
                        try FileManager.default.removeItem(atPath: complete)
                        
                        FileManager.default.createFile(atPath: complete,contents:data, attributes: nil)
                    } catch {
                        print("Error al elimiar foto")
                    }
                    
                }else{
                    FileManager.default.createFile(atPath: complete,contents:data, attributes: nil)
                }
                
                i += 1
                UserDefaults.standard.set("1", forKey: "fotos")
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func showPhotos() {
        var i = 0
        if selected != nil {
            selected.forEach { (asset) in
                
                if asset != UIImage(named: "cameraicon"){
                    switch(i){
                    case 0:
                        flags[0] = true
                        biciA.image = asset
                        break
                    case 1:
                        flags[1] = true
                        biciB.image = asset
                        break
                    case 2:
                        flags[2] = true
                        biciC.image = asset
                        break
                    case 3:
                        flags[3] = true
                        biciD.image = asset
                        break
                    default: break
                    }
                }
                i += 1
            }
        }
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: ancho, height:  alto), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return UIImage(data: thumbnail.jpeg(.low)!)!
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



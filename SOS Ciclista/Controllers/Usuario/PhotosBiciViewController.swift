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
        
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)

        let yellow : UIColor = UIColor( red: 255.0/255.0, green: 216.0/255.0, blue:0, alpha: 1.0)
        vistaAmarilla.layer.masksToBounds = true
        vistaAmarilla.layer.borderColor = yellow.cgColor
        vistaAmarilla.layer.borderWidth = 3.0
        vistaAmarilla.layer.cornerRadius = 15.0

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
    }
    
    @objc func updatePhoto(sender: TapGesture){
        print(sender.title)
        index = sender.title
        
        if flags[sender.title]{
            //true => alert con opciones
            
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
    
    /*override func viewDidAppear(_ animated: Bool) {
        if !flag{
            flag = true
            let vc = BSImagePickerViewController()
            vc.maxNumberOfSelections = 4
            bs_presentImagePickerController(vc,animated: true,
            select: { (asset: PHAsset) -> Void in
                                                
            }, deselect: { (asset: PHAsset) -> Void in
                // User deselected an assets.
                // Do something, cancel upload?
            }, cancel: { (assets: [PHAsset]) -> Void in
                // User cancelled. And this where the assets currently selected.
                
            }, finish: { (assets: [PHAsset]) -> Void in
                // User finished with these assets
                //self.dismiss(animated: true, completion: nil)
                assets.forEach { (asset) in
                    var ii = 0
                    self.selected.append(self.getAssetThumbnail(asset: asset))
                    ii += 1
                }
            }, completion: nil)
        }else{
            showPhotos()
        }
    }*/
    
    @IBAction func savePhotos(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func showPhotos() {
        var i = 0
        if selected != nil {
            selected.forEach { (asset) in
                
                if asset != UIImage(named: "bicia"){
                
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

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}

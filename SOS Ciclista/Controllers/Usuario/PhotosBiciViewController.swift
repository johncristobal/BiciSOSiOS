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

class PhotosBiciViewController: UIViewController {
    
    @IBOutlet var biciA: UIImageView!
    @IBOutlet var biciB: UIImageView!
    @IBOutlet var biciC: UIImageView!
    @IBOutlet var biciD: UIImageView!
    
    @IBOutlet var vistaAmarilla: UIView!
    var flag = false
    
    var ancho : CGFloat!
    var alto : CGFloat!
    var selected : [PHAsset]!
    
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
    }
    
    @objc func updatePhoto(sender: TapGesture){
        print(sender.title)
    }
    
    class TapGesture: UITapGestureRecognizer {
        var title = Int()
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
                self.selected = assets
            }, completion: nil)
        }else{
            showPhotos()
        }
    }
    
    @IBAction func savePhotos(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func showPhotos() {
        var i = 0
        if selected != nil {
            selected.forEach { (asset) in
                switch(i){
                case 0:
                    biciA.image = getAssetThumbnail(asset: asset)
                    break
                case 1:
                    biciB.image = getAssetThumbnail(asset: asset)
                    break
                case 2:
                    biciC.image = getAssetThumbnail(asset: asset)
                    break
                case 3:
                    biciD.image = getAssetThumbnail(asset: asset)
                    break
                default: break
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
        return thumbnail
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

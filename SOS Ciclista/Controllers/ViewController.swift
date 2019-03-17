//
//  ViewController.swift
//  SOS Ciclista
//
//  Created by i7 on 3/3/19.
//  Copyright © 2019 i7. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FacebookCore
import FacebookLogin
import Firebase

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var mapview: MKMapView!
    let location: CLLocationManager = CLLocationManager()
    var flagLocation = false
    var puntosArray : [MKAnnotation] = []
    var talleres : [Taller] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        flagLocation = true
        setMenu()
        setLocation()
        getTalleres()
    }
    
    func setLocation(){
        location.delegate = self
        location.requestWhenInUseAuthorization()
        location.startUpdatingLocation()
        location.desiredAccuracy = kCLLocationAccuracyBest
        location.distanceFilter = 2
        
        mapview.delegate = self
        mapview.showsUserLocation = true
    }
    
    func setMenu(){
        if self.revealViewController() != nil {
            
            self.revealViewController().rearViewRevealWidth = self.view.frame.width - 64
            menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func getTalleres(){
        DataManager.shared.getTalleres(api: "") { (datos) in
            
            self.talleres = datos
            
            datos.forEach({ (taller) in
                let punto = MKPointAnnotation()
                punto.title = taller.name
                //punto.subtitle = taller.description
                let coordinates = taller.coordinates.split(separator: ",")
                let long = coordinates[0]
                let lat = coordinates[1]
                
                punto.coordinate = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)

                self.puntosArray.append(punto)
                
                self.mapview.addAnnotations([punto])
            })
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        /*print(view.annotation)
        if let annotation = view.annotation as? Custompin {
            print("Your annotation title: \(annotation)");
        }*/
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
            
        } else {
            let viewFromNib = Bundle.main.loadNibNamed("customPin", owner: self, options: nil)?.first as! Custompin
            
            var annotationView: Custompin?
            let annotationIdentifier = "pin"
            
            // puntos visibles
            if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? Custompin {
                
                if dequeuedAnnotationView.subviews.isEmpty {
                    dequeuedAnnotationView.addSubview(viewFromNib)
                }
                annotationView = dequeuedAnnotationView
                annotationView?.annotation = annotation
                
            } else {
                // puntos no visibles
                let custompin = Custompin(annotation: annotation, reuseIdentifier: annotationIdentifier)
                custompin.addSubview(viewFromNib)
                
                // extend scope to be able to return at the end of the func
                annotationView = custompin
            }
            
            // configuramos el punto
            if let annotationView = annotationView {
                annotationView.canShowCallout = true
                
                // callout bubble
                annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                
                annotationView.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
                
                let customView = annotationView.subviews.first as! Custompin
                customView.frame = annotationView.frame
                customView.imageOutel.image = #imageLiteral(resourceName: "llaveicono")
                customView.id = ""
            }
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let theAnnotation = view.annotation
            for (index, value) in (puntosArray.enumerated()) {
                if value === theAnnotation {
                    print("The annotation's array index is \(index)")
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loca = locations.last{
            if flagLocation {
                flagLocation = false
                let point: CLLocationCoordinate2D = CLLocationCoordinate2DMake(loca.coordinate.latitude,loca.coordinate.longitude)
                let span : MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 15000.0/111000.0,longitudeDelta: 15000.0/110000)
                self.mapview.setRegion(MKCoordinateRegion(center: point,span: span),animated:true)
            }
        }
    }
    
    @IBAction func showMenu(_ sender: Any) {
    }
    
    @IBAction func faceAction(_ sender: Any) {
        
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
                Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                    if let error = error {
                        // ...
                        print("erorr \(error)")
                        return
                    }
                    // User is signed in
                    // ...
                    print("acces firebase with facebook")
                }
            }
        }
    }
    
    
}

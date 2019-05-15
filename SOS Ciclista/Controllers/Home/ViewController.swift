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
    
    var lastlocation : CLLocation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        //mapview.register(Bicipinview.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)

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

                let coordinates = taller.coordinates.split(separator: ",")
                let long = coordinates[0]
                let lat = coordinates[1]
                let coordinate = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)
                
                let punto = Bicipin()
                punto.pinCustomImageName = "iconomapa"
                punto.coordinate = coordinate
                punto.title = taller.name
                punto.subtitle = taller.description
                
                let pinAnnotationView = MKPinAnnotationView(annotation: punto, reuseIdentifier: "pin")
                
                self.mapview.addAnnotation(pinAnnotationView.annotation!)
                /*
                /*let punto = Bicipin(title: taller.name, locationName: taller.description, discipline: "Sculpture", coordinate: coordinate)*/

                let punto = MKPointAnnotation()
                punto.title = taller.name
                //punto.subtitle = taller.description
                //let coordinates = taller.coordinates.split(separator: ",")
                //let long = coordinates[0]
                //let lat = coordinates[1]
                punto.coordinate = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)*/

                self.puntosArray.append(punto)
                
                //self.mapview.addAnnotations([punto])
            })
        }
    }
    
    func initListenerBike(){
        
        //primero enviar mi bike para que este en fierbase
        //si y solo si estoy logueado
        //mando nombre, bike, ubication
        let reportado = UserDefaults.standard.string(forKey: "sesion")
        if reportado != nil{
            if reportado == "1"{
                let punto = Bicipin()
                punto.pinCustomImageName = "bicif"
                let name = UserDefaults.standard.string(forKey: "nombre")
                if name != nil{
                    punto.title = name
                }else{
                    punto.title = "SOS Ciclista"
                }
                
                //punto.subtitle = taller.description
                //let coordinates = taller.coordinates.split(separator: ",")
                let long = lastlocation?.coordinate.longitude
                let lat = lastlocation?.coordinate.latitude
                
                punto.coordinate = CLLocationCoordinate2D(latitude: Double(lat!), longitude: Double(long!))
                
                //self.puntosArray.append(punto)
                let pinAnnotationView = MKPinAnnotationView(annotation: punto, reuseIdentifier: "pin")
                
                self.mapview.addAnnotation(pinAnnotationView.annotation!)
                //self.mapview.addAnnotations([punto])
            }else{
                print(reportado!)
            }
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
            let reuseIdentifier = "pin"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }
            
            let customPointAnnotation = annotation as! Bicipin
            annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            //annotationView!.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
            annotationView?.image = UIImage(named: customPointAnnotation.pinCustomImageName)
            
            return annotationView
            
            /*let viewFromNib = Bundle.main.loadNibNamed("customPin", owner: self, options: nil)?.first as! Custompin
            
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
                
                annotationView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
                
                let customView = annotationView.subviews.first as! Custompin
                customView.frame = annotationView.frame
                customView.imageOutel.image = #imageLiteral(resourceName: "llaveicono")
                customView.id = ""
            }
            
            return annotationView*/
            
            /*guard let annotation = annotation as? Bicipin else { return nil }
            // 3
            let identifier = "marker"
            var view: MKMarkerAnnotationView
            // 4
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKMarkerAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // 5
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            return view*/
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let theAnnotation = view.annotation
            for (index, value) in (puntosArray.enumerated()) {
                if value === theAnnotation {
                    print("The annotation's array index is \(index)")
                    
                    let taller = talleres[index]
                    let coordinates = taller.coordinates.split(separator: ",")
                    let long = coordinates[0]
                    let lat = coordinates[1]
                    if  UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL) {
                        UIApplication.shared.openURL(NSURL(string:
                            "comgooglemaps://?saddr=&daddr=\(lat),\(long)&directionsmode=driving")! as URL)
                    } else {
                        NSLog("Can't use comgooglemaps://");
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loca = locations.last{
            if flagLocation {
                flagLocation = false

                lastlocation = loca

                let point: CLLocationCoordinate2D = CLLocationCoordinate2DMake(loca.coordinate.latitude,loca.coordinate.longitude)
                let span : MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 2000.0/111000.0,longitudeDelta: 2000.0/110000.0)
                self.mapview.setRegion(MKCoordinateRegion(center: point,span: span),animated:true)
                
                 initListenerBike()
            }
        }
    }
    
    @IBAction func showMenu(_ sender: Any) {
    }
}

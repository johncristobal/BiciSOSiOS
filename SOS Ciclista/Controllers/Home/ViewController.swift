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
    
    var puntosArray : [MKAnnotation] = []
    var talleres : [Taller] = []
    
    var lastlocation : CLLocation? = nil
    
    var reportIdS : [String] = []
    var bikers : [Biker] = []
    
    var hashMapMarker: [String : Bicipin] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        //mapview.register(Bicipinview.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)

        flagLocation = true
        setMenu()
        setLocation()
        getTalleres()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if mapaListo{
            initListenerBikeOnce()
        }
        //flagLocation = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let bici = UserDefaults.standard.string(forKey: "keySelf")
        if bici != nil{
            
            UserDefaults.standard.set("null", forKey: "keySelf")
            
            let ref = Database.database().reference()
            let thisUsersGamesRef = ref.child("bikers")
            thisUsersGamesRef.child(bici!).removeValue()
        }else{
            print("no hay bici")
            //punto.title = "SOS Ciclista"
        }
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
    
    func listenerBikers(){
        
        var ref: DatabaseReference!
        ref = Database.database().reference().child("bikers")
        ref.observe(.value, with: { (data) in
            
            self.bikers.removeAll()
            //self.reportIdS.removeAll()
            var newIds : [String] = []
            
            var keySelf = UserDefaults.standard.string(forKey: "keySelf")
            if keySelf != nil{
                print(keySelf!)
            }else{
                keySelf = "null"
            }
            for child in data.children {
                let snap = child as! DataSnapshot
                let datos = snap.value as! [String: Any]
                let id = datos["id"] as! String
                let name = datos["name"] as! String
                let bici = datos["bici"] as! Int
                let latitud = datos["latitud"] as! Double
                let longitude = datos["longitude"] as! Double
                
                self.bikers.append(Biker(id: id, name: name, bici: bici, latitud: latitud, longitude: longitude))
            }
            
            self.bikers.forEach({ (biker) in
                
                newIds.append(biker.id)
                
                if !self.reportIdS.contains(biker.id)
                {
                    self.reportIdS.append(biker.id)
                
                    //if biker.id != keySelf && keySelf != "null"{
                    
                    let punto = Bicipin()
                    var bici = ""
                    switch biker.bici{
                        case 0:bici = "bicia"; break;
                        case 1:bici = "bicib"; break;
                        case 2:bici = "bicic"; break;
                        case 3:bici = "bicid"; break;
                        case 4:bici = "bicie"; break;
                        case 5:bici = "bicif"; break;
                        default: break
                    }
                    punto.pinCustomImageName = bici
                    punto.title = biker.name
                    
                    punto.coordinate = CLLocationCoordinate2D(latitude: biker.latitud, longitude: biker.longitude)
                     
                     //self.puntosArray.append(punto)
                     let pinAnnotationView = MKPinAnnotationView(annotation: punto, reuseIdentifier: "pin")
                     
                     self.mapview.addAnnotation(pinAnnotationView.annotation!)
                    
                    self.hashMapMarker[biker.id] = punto
                //}
                }
                
                //los puntos que se eliminaran
                let justids = Array(Set(self.reportIdS).subtracting(newIds))
                
                self.hashMapMarker.forEach({ (arg0) in
                    
                    let (key, value) = arg0
                    if justids.contains(key){
                        let punto = self.hashMapMarker[key]
                        self.mapview.removeAnnotation(punto!)
                        self.hashMapMarker.removeValue(forKey: key)
                        if let index = self.reportIdS.index(of: key) {
                            self.reportIdS.remove(at: index)
                        }

                        print(self.reportIdS)
                    }
                })
            })
        }) { (error) in
            print(error)
        }
    }
    
    func initListenerBikeOnce(){
        
        //primero enviar mi bike para que este en fierbase
        //si y solo si estoy logueado
        //mando nombre, bike, ubication
        let reportado = UserDefaults.standard.string(forKey: "sesion")
        if reportado != nil{
            if reportado == "1"{
                
                let long = lastlocation?.coordinate.longitude
                let lat = lastlocation?.coordinate.latitude
                var name = UserDefaults.standard.string(forKey: "nombre")
                let bici = UserDefaults.standard.integer(forKey: "bici")
                if name != nil{
                    name = ""
                }else{
                    name = "SOS Ciclista"
                }
                //enviar mi ubiaciaon al mapa
                let ref = Database.database().reference()
                let thisUsersGamesRef = ref.child("bikers").childByAutoId()
                thisUsersGamesRef.setValue(
                    [
                        "id":thisUsersGamesRef.key,
                        "name":name,
                        "bici":bici,
                        "latitud":lat,
                        "longitude":long
                    ]
                ){(error:Error?, ref:DatabaseReference) in
                    if let error = error {
                        print("Data could not be saved: \(error).")
                    } else {
                        print("Data saved successfully!")
                        UserDefaults.standard.set("1", forKey: "enviado")
                        UserDefaults.standard.set(thisUsersGamesRef.key, forKey: "keySelf")
                        
                    }
                }
            }else{
                print(reportado!)
            }
        }
    }
    
    func initListenerBike(){
        
        //primero enviar mi bike para que este en fierbase
        //si y solo si estoy logueado
        //mando nombre, bike, ubication
        let reportado = UserDefaults.standard.string(forKey: "sesion")
        if reportado != nil{
            if reportado == "1"{

                let long = lastlocation?.coordinate.longitude
                let lat = lastlocation?.coordinate.latitude
                var name = UserDefaults.standard.string(forKey: "nombre")
                let bici = UserDefaults.standard.integer(forKey: "bici")
                if name != nil{
                    name = ""
                }else{
                    name = "SOS Ciclista"
                }
                //enviar mi ubiaciaon al mapa
                let ref = Database.database().reference()
                let thisUsersGamesRef = ref.child("bikers").childByAutoId()
                thisUsersGamesRef.setValue(
                    [
                        "id":thisUsersGamesRef.key,
                        "name":name,
                        "bici":bici,
                        "latitud":lat,
                        "longitude":long
                    ]
                ){(error:Error?, ref:DatabaseReference) in
                    if let error = error {
                        print("Data could not be saved: \(error).")
                    } else {
                        print("Data saved successfully!")
                        UserDefaults.standard.set("1", forKey: "enviado")
                        UserDefaults.standard.set(thisUsersGamesRef.key, forKey: "keySelf")
                        
                        self.listenerBikers()
                    }
                }
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
                
                mapaListo = true
            }
        }
    }
    
    @IBAction func showMenu(_ sender: Any) {
    }
}

//
//  MapasViewController
//  LocaisFavoritos
//
//  Created by Fernando Augusto de Marins on 16/02/16.
//  Copyright © 2016 Fernando Augusto de Marins. All rights reserved.
//

import UIKit
import MapKit

class MapasViewController: UIViewController,
    MKMapViewDelegate,
    CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if Array.sharedInstance.activePlace == -1 {
            
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            
        } else {
            
            let latitude = NSString(string: Array.sharedInstance.places[Array.sharedInstance.activePlace]["lat"]!).doubleValue
            let longitude = NSString(string: Array.sharedInstance.places[Array.sharedInstance.activePlace]["long"]!).doubleValue
            
            setMap(latitude: latitude, longitude: longitude)
            setAnnotation(CLLocationCoordinate2DMake(latitude, longitude), title: Array.sharedInstance.places[Array.sharedInstance.activePlace]["name"]!)
            
        }
        
        let longPress = UILongPressGestureRecognizer(target: self, action: "addPin:")
        longPress.minimumPressDuration = 1
        
        mapView.addGestureRecognizer(longPress)
    }
    
    func addPin(gestureRecognizer: UIGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            
            let touchPoint = gestureRecognizer.locationInView(mapView)
            let newCoordinate = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
            
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                var title = ""
                
                if (error == nil) {
                    
                    if let p = placemarks?[0] {
                        var address: String = ""
                        var address2: String = ""
                        
                        if p.subThoroughfare != nil {
                            address2 = p.subThoroughfare!
                        }
                        
                        if p.thoroughfare != nil {
                            address = p.thoroughfare!
                        }
                        
                        title = "\(address2) \(address)"
                    }
                    
                }
                
                if title.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "" {
                    title = "Adicionado em \(NSDate())"
                }
                
                Array.sharedInstance.places.append(["name" : title, "lat" : "\(newCoordinate.latitude)", "long" : "\(newCoordinate.longitude)"])
                
                print(Array.sharedInstance.places)
                
                self.setAnnotation(newCoordinate, title: title)

            })
            
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0]
        
        setMap(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        setAnnotation(CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude), title: "Eu estou aqui")
    }
    
    func setMap(latitude latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        let latitude = latitude
        let longitude = longitude
        
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        
        let latDelta: CLLocationDegrees = 0.01
        let longDelta: CLLocationDegrees = 0.01
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        let region: MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        
        mapView.setRegion(region, animated: true)
    }
    
    func setAnnotation(coordinate: CLLocationCoordinate2D, title: String) {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        
        mapView.addAnnotation(annotation)
        
    }

}


//
//  MapViewController.swift
//  Delvo
//
//  Created by Apple on 12/02/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController ,GMSMapViewDelegate ,Address,CLLocationManagerDelegate{

    
    
    @IBOutlet weak var Pointer: UIImageView!
    @IBOutlet weak var MapView: GMSMapView!
    
    var placesClient: GMSPlacesClient!
    var lat: CLLocationDegrees = 24.8838999
    var long: CLLocationDegrees = 67.0546788
    var controller:String = "PickUpVc"
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    var appDelegate = AppDelegate()
    let GeocodingObj = Geocoding()
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        self.setLocationManager()
        GetMap(a: lat, b: long)
        self.setMapView()
    }
    
    // MArk ~ LocationManagerDelegates
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status:  CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            MapView.isMyLocationEnabled = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        self.MapView?.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
    }
    
    // MArk ~ MapViewDelegates
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        MapView.camera=position
        MapView.isMyLocationEnabled = true
        self.getAddress(coordinates: position.target)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
        MapView.isMyLocationEnabled = true
        
        if(gesture){
            
            MapView.selectedMarker = nil
        }
    }
    
    // Mark ~ GetAddressFromCorrdinate
    
    func getAddress(coordinates: CLLocationCoordinate2D){
        
        GeocodingObj.getAddressFromGeocodeCoordinate(coordinate: coordinates ,controller: self.controller , success: { (success) -> () in
            
        }, failure: { (error) -> () in
            
            print(error)
        })
    }

    // Mark ~ SetMapPointerToCorrdinate
    
    func GetLatLng(lat: CLLocationDegrees, lng: CLLocationDegrees) {
        
        GetMap(a: lat, b: lng)
    }
    
    public func GetMap(a:CLLocationDegrees , b:CLLocationDegrees){
        
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: a, longitude: b, zoom: 17)
        MapView.camera = camera
        MapView.isMyLocationEnabled = true
        MapView.settings.myLocationButton=false
        MapView.settings.compassButton=false
    }
    
    // Mark ~ Class Methods
    
    func setMapView(){
        
        self.Pointer.frame=MapView.camera.accessibilityFrame
        MapView.settings.myLocationButton=false
        MapView.settings.compassButton=false
        self.MapView?.isMyLocationEnabled = true
        MapView.delegate = self
    }
    
    func setLocationManager(){
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        self.locationManager.delegate = self
        
    }

}

//
//  Geocoding.swift
//  Delvo
//
//  Created by Apple on 12/02/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import GoogleMaps

class Geocoding: NSObject {

    let ApiObj = ApiParsing()
    
    func getResults(place:String , success:@escaping ([SearchResult]) -> (), failure: @escaping (NSError) -> ())     {
        
        ApiObj.SearchLocations(place: place, Success: {(SearchArray) -> () in
            
            success(SearchArray)
        }
        , Failure: {(error) -> () in
                
                failure(error)
        })
    }
    
    func GetCorrdinates(Placeid:String , success:@escaping ( _ latitude:CLLocationDegrees ,_ longitude:CLLocationDegrees ) -> (), failure: @escaping (NSError) -> ()){
        
        ApiObj.GetLatLng(placeID: Placeid, Success: { (response) -> Void in
            
            let results = response["result"] as? NSDictionary
            let names = ((results?["geometry"] as AnyObject).value(forKey: "location") as?  Dictionary<String, AnyObject>)
            
            let lat = names?["lat"] as! CLLocationDegrees
            let lng = names?["lng"] as! CLLocationDegrees
            
            success(lat,lng)
            
        }, Failure: { (error) -> Void in
            
             failure(error)
        })
    
     }
    
    func getAddressFromGeocodeCoordinate(coordinate: CLLocationCoordinate2D , controller:String, success:@escaping (Bool) -> (), failure: @escaping (NSError) -> ()) {
        
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            if response != nil{
                
                if let Address = response!.firstResult() {
                    let lines = Address.lines! as [String]
                    let address = lines.joined(separator: ",")

                    if controller == "PickUpVc"{
                        
                        Location.PickLocation = address
                        Location.PickLat = coordinate.latitude
                        Location.PickLng = coordinate.longitude
                    }
                        
                    else{
                        
                        Location.DropLocation = address
                        Location.DropLat = coordinate.latitude
                        Location.DropLng = coordinate.longitude
                    }
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetArea"), object: nil)
                    success(true)
                }
            }
                
            else {
                
                failure(error as! NSError)
            }
            
        }
    }
}

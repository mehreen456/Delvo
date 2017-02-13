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

    var PlaceArray:[(name:String,id:String)] = []
    let ApiObj = ApiParsing()
    
    func getResults(place:String , success:@escaping ( Array <(name:String,id:String)>) -> (), failure: @escaping (NSError) -> ())     {
        
        ApiObj.SearchLocations(place: place, Success: {(SearchArray) -> () in
            
            success(SearchArray)
            
        }
            , Failure: {(error) -> () in
                
                failure(error)
                
        })
    }
    
    func GetCorrdinates(Placeid:String , success:@escaping ( _ latitude:CLLocationDegrees ,_ longitude:CLLocationDegrees ) -> (), failure: @escaping (NSError) -> ())
    {
        
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
}

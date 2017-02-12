//
//  Geocoding.swift
//  Delvo
//
//  Created by Apple on 12/02/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire

class Geocoding: NSObject {

    var PlaceArray:[(name:String,id:String)] = []
    
    func getResults(place:String , success:@escaping ( Array <(name:String,id:String)>) -> (), failure: @escaping (NSError) -> ())     {
        
        PlaceArray.removeAll()
        Alamofire.request(
            URL(string: "https://maps.googleapis.com/maps/api/place/autocomplete/json")!,
            method: .get,
            parameters: [
                
                "input": place,
                "types": "geocode|establishment",
                "key" : "AIzaSyBsWLDDGbaaf042Y0yr1zktCbR4BrEWTFk"
            ])
            .validate()
            .responseJSON { (response) -> Void in
                
                guard response.result.isSuccess else {
                    
                    failure(response.result.error as! NSError)
                    return
                }
                
                guard let value = response.result.value as? Dictionary<String, AnyObject> ,
                    let results = value["predictions"] as? [[String: Any]] else {
                        
                        print("Data received")
                        return
                }
                
                for i in 0 ..< results.count
                {
                    let dic = results[i]
                    let name = dic["description"] as? String
                    let placeid = dic["place_id"] as? String
                    
                    let tuple:(String,String) = (name! , placeid!)
                    
                    self.PlaceArray.append(tuple)
                }
                
                success(self.PlaceArray)
                
        }
        
    }
    
    func GetCorrdinates(Placeid:String , success:@escaping ( _ latitude:CLLocationDegrees ,_ longitude:CLLocationDegrees ) -> (), failure: @escaping (NSError) -> ())
    {
        
        Alamofire.request(
            
            URL(string: "https://maps.googleapis.com/maps/api/place/details/json")!,
            method: .get,
            parameters: [
                
                "placeid": Placeid,
                "key" : "AIzaSyB0e-ht_K-H6bSDUMeTTK8J72rO_UdigK0"
            ])
            .validate()
            .responseJSON { (response) -> Void in
                
                guard response.result.isSuccess else {
                    failure(response.result.error as! NSError)
                    return
                }
                
                let values = response.result.value as? NSDictionary
                let results = values?["result"] as? NSDictionary
                
                let names = ((results?["geometry"] as AnyObject).value(forKey: "location") as?  Dictionary<String, AnyObject>)
                
                let lat = names?["lat"] as! CLLocationDegrees
                let lng = names?["lng"] as! CLLocationDegrees
                
                success(lat,lng)
        }
    }
}

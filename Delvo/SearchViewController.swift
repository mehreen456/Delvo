//
//  SearchViewController.swift
//  Delvo
//
//  Created by Apple on 12/02/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Alamofire
import GooglePlaces

protocol Address {
    func GetLatLng(lat: CLLocationDegrees , lng: CLLocationDegrees)
}

class SearchViewController: UIViewController , UITableViewDataSource,UITableViewDelegate ,UITextFieldDelegate{

    @IBOutlet weak var ResultsTable: UITableView!
    @IBOutlet weak var searchField: UITextField!

    var delegate:Address?
    
    var place : String = " "
    var array:[(name:String,id:String)] = []
    var lat: CLLocationDegrees?
    var long: CLLocationDegrees?
    var geocodingClass = Geocoding()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.SearchPlaces(place: place)
        searchField.delegate = self
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    func SearchPlaces(place:String)
    {
        geocodingClass.getResults(place: place, success: { (places) -> () in
            
            self.array = places
            self.ResultsTable.reloadData()
        },
                                  
        failure: { (error) -> () in
            
            print(error) })
    }
    
    func numberOfSections(in ResultsTable: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ ResultsTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func tableView(_ ResultsTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = ResultsTable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = self.array[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let Placeid = self.array[indexPath.row].id
        
        geocodingClass.GetCorrdinates(Placeid: Placeid, success: { (latitude,longitude) -> () in
            
            if self.delegate != nil
            {
                self.lat = latitude
                self.long = longitude
                self.delegate?.GetLatLng(lat: self.lat!, lng: self.long!)
            }
            self.navigationController?.popViewController(animated: true)
        },
                                      
         failure: { (error) -> () in
                print(error)
        })
        
    }
    
    func textField(_ searchField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if ((searchField.text)?.characters.count)! > 2
        {
            self.array.removeAll()
            self.SearchPlaces(place: searchField.text! + " karachi")
        }
        else
        {
            self.array.removeAll()
            self.ResultsTable.reloadData()
        }
        return true
    }
}

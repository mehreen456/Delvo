//
//  SearchViewController.swift
//  Created by Apple on 12/02/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Alamofire
import GooglePlaces
import NVActivityIndicatorView

protocol Address {
    
    func GetLatLng(lat: CLLocationDegrees , lng: CLLocationDegrees)
}

class SearchViewController: UIViewController , UITableViewDataSource,UITableViewDelegate ,UITextFieldDelegate , NVActivityIndicatorViewable{

    @IBOutlet weak var LoaderView: UIView!
    @IBOutlet weak var ResultsTable: UITableView!
    @IBOutlet weak var searchField: UITextField!

    var delegate:Address?
    var place : String = " "
    var array:[(name:String,id:String)] = []
    var geocodingClass = Geocoding()
    var cellHeight:CGFloat = 25
    let obj = DelvoMethods()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.SearchPlaces(place: place)
        searchField.delegate = self
        self.LoaderView.isHidden=true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title="Search Location"
        obj.AddImageTextfield(textField: self.searchField)
    }

    func SearchPlaces(place:String){
        
        startAnimating(CGSize(width:50 ,height:50) , message: "Searching ..." , messageFont: UIFont.boldSystemFont(ofSize: 15) , type:.ballClipRotatePulse , color: UIColor.DarkBlueColor()
            , backgroundColor: UIColor.clear)
        self.LoaderView.isHidden=false
        self.array.removeAll()
        geocodingClass.getResults(place: place, success: { (places) -> () in

            self.array = places
            
            if self.array.count == 0{
                self.ResultsTable.isHidden=true}
            else{
                self.ResultsTable.isHidden=false}
            
            self.ResultsTable.reloadData()
            self.stopAnimating()
            self.LoaderView.isHidden=true
        },
                                  
        failure: { (error) -> () in
            
            print(error) })
    }
    
    // Mark ~ TableView Delegate Methods
    func numberOfSections(in ResultsTable: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ ResultsTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return cellHeight+25
    }
    
    func tableView(_ ResultsTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = ResultsTable.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchTableViewCell
        
        cell.LocationLabel?.text = self.array[indexPath.row].name
        cellHeight = obj.heightForView(text: (cell.LocationLabel?.text)!, frame:cell.LocationLabel.frame)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let Placeid = self.array[indexPath.row].id
        
        geocodingClass.GetCorrdinates(Placeid: Placeid, success: { (latitude,longitude) -> () in
            
            if self.delegate != nil{
                
                self.delegate?.GetLatLng(lat: latitude, lng: longitude)
            }
            self.navigationController?.popViewController(animated: true)
        },
                                      
         failure: { (error) -> () in
                print(error)
        })
    }
    
    // Mark ~ TextField Delegate Methods
    func textField(_ searchField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if ((searchField.text)?.characters.count)! > 3{
            
            self.SearchPlaces(place: searchField.text! + " karachi")
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
}

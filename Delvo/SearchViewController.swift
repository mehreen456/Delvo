//
//  SearchViewController.swift
//  Created by Apple on 12/02/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Alamofire
import GooglePlaces
import NVActivityIndicatorView
import RxSwift
import RxCocoa

protocol Address {
    
    func GetLatLng(lat: CLLocationDegrees , lng: CLLocationDegrees)
}

class SearchViewController: UIViewController ,UITextFieldDelegate , NVActivityIndicatorViewable{

    @IBOutlet weak var LoaderView: UIView!
    @IBOutlet weak var ResultsTable: UITableView!
    @IBOutlet weak var searchField: UITextField!

    var delegate:Address?
    var place : String = " "
    var array:[SearchResult] = []
    var geocodingClass = Geocoding()
    var cellHeight:CGFloat = 25
    let DMobj = DelvoMethods()
    let obj = OrderDescClassMethods()
    let disposeBag = DisposeBag()
    let dataSource = Variable<[SearchResult]>([])
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.SearchPlaces(place: place)
        searchField.delegate = self
        self.LoaderView.isHidden=true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title="Search Location"
        DMobj.AddImageTextfield(textField: self.searchField)
        self.searchResultTabel()
        self.SearchTextField()
        _ = self.ResultsTable.rx.setDelegate(self)
        dataSource.value = self.array
        
    }
    
    func searchResultTabel(){
        
        dataSource.asObservable().bindTo(ResultsTable.rx.items(cellIdentifier: "SearchCell")){ row,Searchplace,cell in
            
            if let C_cell = cell as? SearchTableViewCell{
                
                C_cell.LocationLabel.text = Searchplace.place
                self.cellHeight = self.DMobj.heightForView(text: (C_cell.LocationLabel?.text)!, frame:C_cell.LocationLabel.frame,size: 17.0)
               
            }
            
            }.addDisposableTo(disposeBag)

        ResultsTable.rx.modelSelected(SearchResult.self).subscribe(onNext:{ menuItem in
            
            let Placeid = menuItem.placeId
            
            _ = self.navigationController?.popViewController(animated: true)
            
            
            self.geocodingClass.GetCorrdinates(Placeid: Placeid, success: { (latitude,longitude) -> () in
                
                if self.delegate != nil{
                    
                    self.delegate?.GetLatLng(lat: latitude, lng: longitude)
                
                }
            },
                                               
              failure: { (error) -> () in
                
                self.obj.alert(message:error.description ,title: "Faliure" ,controller: self)
            })
            
        }).addDisposableTo(disposeBag)
        
        ResultsTable.alwaysBounceVertical = false
    }
    
    func SearchTextField(){
        
        self.searchField.rx.text.asObservable().subscribe(onNext: {
            text in
            
            if (text?.characters.count)! > 3{
                
                self.SearchPlaces(place: text! + " karachi")
            }
            
        }).addDisposableTo(disposeBag)
    }
    
    func SearchPlaces(place:String){
        
        startAnimating(CGSize(width:50 ,height:50) , message: "Searching ..." , messageFont: UIFont.boldSystemFont(ofSize: 15) , type:.ballClipRotatePulse , color: UIColor.DoneButtonColor()
            , backgroundColor: UIColor.clear)
        self.LoaderView.isHidden=false
        self.array.removeAll()
       
        geocodingClass.getResults(place: place, success: { (places) -> () in

            self.array = places
            self.dataSource.value = self.array
            if self.array.count == 0{
                self.ResultsTable.isHidden=true}
            else{
                self.ResultsTable.isHidden=false}
            
            self.stopAnimating()
            self.LoaderView.isHidden=true
        },
        failure: { (error) -> () in
            
           self.obj.alert(message:error.description ,title: "Faliure" ,controller: self) })
    }
}

extension SearchViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        return cellHeight+30
    }
}

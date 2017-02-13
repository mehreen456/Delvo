//
//  OrderDescriptionViewController.swift
//  Delvo
//
//  Created by Apple on 12/02/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Alamofire

class OrderDescriptionViewController: UIViewController , UITextViewDelegate{
    
    @IBOutlet weak var ContactField: UITextField!
    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var PickupLabel: UILabel!
    @IBOutlet weak var DropLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.DescriptionLabel.delegate=self
        DropLabel.text = MapViewController.Location.DropLocation
        PickupLabel.text = MapViewController.Location.PickLocation
        self.navigationItem.title = "Place Order"
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if DescriptionLabel.text == "Enter your description here ..."
        {
            DescriptionLabel.text = " "
        }
    }
    
    @IBAction func GoDelivoButton(_ sender: Any) {
        
        let myobj = ApiParsing()
        
        myobj.PlaceOrder(name: self.NameField.text!, phone: self.ContactField.text!, detail: self.DescriptionLabel.text!, Success: { (json) -> () in
            
                 print(json)
            
        }
        , Failure: { (error) -> () in
        
                 print(error)
        })
        }
}

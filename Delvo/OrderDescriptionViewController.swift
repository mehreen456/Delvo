//
//  OrderDescriptionViewController.swift
//  Delvo
//
//  Created by Apple on 12/02/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Alamofire

class OrderDescriptionViewController: UIViewController , UITextViewDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var EditIcon: UIImageView!
    @IBOutlet weak var DoneButton: UIButton!
    @IBOutlet weak var ContactField: UITextField!
    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var PickupLabel: UILabel!
    @IBOutlet weak var DropLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UITextView!
    
    var frameorigin:CGRect?
    let obj = DelvoMethods()
    var status:NSInteger = 100
    var origin:CGFloat?
    let Description = "\n Enter your order description here ..."
    override func viewDidLoad() {
        super.viewDidLoad()

        self.DescriptionLabel.delegate=self
        DropLabel.text = MapViewController.Location.DropLocation
        PickupLabel.text = MapViewController.Location.PickLocation
        EditIcon.ChangeTintColor(color:UIColor.DarkBlueColor())
        EditIcon.backgroundColor = UIColor.clear
        self.ContactField.inputAccessoryView = obj.AddDoneButton(controller: self)
        self.navigationItem.title = "Place Order"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        obj.AddGesture(controller: self)
        origin = self.view.frame.origin.y
        self.frameorigin = self.view.frame
        NameField.delegate = self
        ContactField.delegate = self
        self.DoneButton.backgroundColor = UIColor.ButtonColor()
        DescriptionLabel.text = Description
        obj.AddBorder(textview: self.DescriptionLabel)
    }
    
    @IBAction func GoDelivoButton(_ sender: Any) {
        
        self.view.frame.origin.y = self.origin!
        if !obj.validate(phoneNumber: self.ContactField.text!) && !self.ContactField.text!.isEmpty {
            self.obj.alert(message: "Invalid PhoneNo", controller: self)
            return
        }
        
        let myobj = ApiParsing()
        
        myobj.PlaceOrder(name: self.NameField.text!, phone: self.ContactField.text!, detail: self.DescriptionLabel.text!, Success: { (json) -> () in
            
            if json{
               
                self.obj.ShowAlert(controller: self)}
        }
            
        , failure: { (message) -> () in
                
            self.obj.alert(message:message ,title: "Failed",controller: self)}
            
        , Failure: { (error) -> () in
        
            print(error)
        })
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.NameField{
            
            frameorigin?.origin.y = self.origin!-30
            self.ContactField.becomeFirstResponder()}
        
         else if textField == self.ContactField {
            
            frameorigin?.origin.y = (frameorigin?.origin.y)!-40
            self.DescriptionLabel.becomeFirstResponder()}
        
        self.view.frame = frameorigin!
        return true
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        self.view.frame.origin.y =  (frameorigin?.origin.y)! - 170
        if DescriptionLabel.text == Description{
            DescriptionLabel.text = "\n "
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if DescriptionLabel.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty{
            DescriptionLabel.text = Description
        }
        self.view.frame.origin.y = self.origin!
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n"{
            
            frameorigin?.origin.y = self.origin!
            self.view.frame = frameorigin!
            DescriptionLabel.resignFirstResponder()
            return false
        }
        return true
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
           return false
    }
}

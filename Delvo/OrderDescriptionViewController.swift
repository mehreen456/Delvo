//
//  OrderDescriptionViewController.swift
//  Delvo
//
//  Created by Apple on 12/02/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa

class OrderDescriptionViewController: UIViewController , UITextViewDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var GreenCircle: UIImageView!
    @IBOutlet weak var RedCircle: UIImageView!
    @IBOutlet weak var DoneButton: UIButton!
    @IBOutlet weak var ContactField: UITextField!
    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var PickupLabel: UILabel!
    @IBOutlet weak var DropLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UITextView!
    
    @IBOutlet weak var LineView: UIView!
    
    var frameorigin:CGRect?
    let obj = OrderDescClassMethods()
    let delvoMethods = DelvoMethods()
    var status:NSInteger = 100
    var origin:CGFloat?
    let Description = "\n Enter your order description here ..."
    let PhoneValidationError = "Invalid PhoneNo"
    let FailureMsg = "Failed"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navController()
        self.setOrigin()
        self.setOutlets()
        self.setDelegate()
        delvoMethods.AddGesture(controller: self)
        
        delvoMethods.drawLine(startPoint: CGPoint(x:GreenCircle.frame.size.width/2+GreenCircle.frame.origin.x, y:GreenCircle.frame.size.height/2+GreenCircle.frame.origin.y), endPoint:  CGPoint(x:RedCircle.frame.size.width/2+RedCircle.frame.origin.x, y:RedCircle.frame.size.height/2+RedCircle.frame.origin.y),view: self.view)

    }
    
    @IBAction func GoDelivoButton(_ sender: Any) {
        
        self.view.frame.origin.y = self.origin!
        if !obj.validate(phoneNumber: self.ContactField.text!) && !self.ContactField.text!.isEmpty {
            self.obj.alert(message: PhoneValidationError, controller: self)
            return
        }
        var details = ""
        let myobj = ApiParsing()
        if self.DescriptionLabel.text != Description{
            details = self.DescriptionLabel.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        else{
            details = "No description"
        }
        myobj.PlaceOrder(name: self.NameField.text!, phone: self.ContactField.text!, detail:details, Success: { (json) -> () in
            
            if json{
               
                self.obj.ShowAlert(controller: self,identifier: "Done", message:"Your order has been placed. You will soon recive a conformation call")
            }
        }
            
        , failure: { (message) -> () in
                
            self.obj.alert(message:message ,title: self.FailureMsg ,controller: self)}
            
        , Failure: { (error) -> () in
        
            print(error)
        })
        
    }
    
    // Mark ~ Textfiels Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.NameField{
            
            frameorigin?.origin.y = self.origin! - 30
            self.ContactField.becomeFirstResponder()}
        
         else if textField == self.ContactField {
            
            frameorigin?.origin.y = (frameorigin?.origin.y)! - 40
            self.DescriptionLabel.becomeFirstResponder()}
        
        self.view.frame = frameorigin!
        return true
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
    
    // Mark ~ Controller's Method
    
    func setDelegate(){
        
        NameField.delegate = self
        ContactField.delegate = self
        self.DescriptionLabel.delegate=self
    }
    
    func setOrigin(){
        
        origin = self.view.frame.origin.y
        self.frameorigin = self.view.frame
    }
    
    func navController(){
        
        self.navigationItem.title = "Place Order"
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    func setOutlets(){
        
        DropLabel.text = Location.DropLocation
        PickupLabel.text = Location.PickLocation
        self.ContactField.inputAccessoryView = obj.AddDoneButton(controller: self)
        DescriptionLabel.text = Description
        obj.AddBorder(textview: self.DescriptionLabel)
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
        self.view.frame.origin.y = origin!
    }
}

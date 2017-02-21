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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.DescriptionLabel.delegate=self
        DropLabel.text = MapViewController.Location.DropLocation
        PickupLabel.text = MapViewController.Location.PickLocation

        EditIcon.ChangeTintColor(color:UIColor.DarkBlueColor())
        EditIcon.backgroundColor = UIColor.clear
        self.navigationItem.title = "Place Order"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PickUpViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        origin = self.view.frame.origin.y
        self.frameorigin = self.view.frame
        NameField.delegate = self
        ContactField.delegate = self
        self.DoneButton.backgroundColor = UIColor.ButtonColor()
        DescriptionLabel.text = "\n Enter your order description here ..."
        obj.AddBorder(textview: self.DescriptionLabel)
    }
    
    @IBAction func GoDelivoButton(_ sender: Any) {
        
        let myobj = ApiParsing()
        
        myobj.PlaceOrder(name: self.NameField.text!, phone: self.ContactField.text!, detail: self.DescriptionLabel.text!, Success: { (json) -> () in
            
             let meta = json["meta"] as! NSDictionary
             self.status = meta["status"] as! NSInteger
            
             if self.status == 200{
                self.ShowAlert()
             }
             else{
             
                let Message = meta["message"]
                let alertview = self.obj.alert(message:Message as! String, title: "Failed")
                self.present(alertview, animated: true, completion: nil)
                self.obj.DismissAlertView(alertview: alertview as! UIAlertController)
             }
            
            }
        , Failure: { (error) -> () in
        
                 print(error)
        })
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.NameField{
            frameorigin?.origin.y = self.origin!-30
            self.ContactField.becomeFirstResponder()}
        
        else if textField == self.ContactField{
            frameorigin?.origin.y = (frameorigin?.origin.y)!-40
            self.DescriptionLabel.becomeFirstResponder()}
        
        self.view.frame = frameorigin!
        return true
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if DescriptionLabel.text == "\n Enter your order description here ..."{
            DescriptionLabel.text = "\n "
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if DescriptionLabel.text == "\n " || DescriptionLabel.text == "\n" {
            DescriptionLabel.text = "\n Enter your order description here ..."
        }
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
    
    func ShowAlert()
    {
        let alertController = UIAlertController(title: "Success" , message: "Your order has been placed. You will soon recive a conformation call", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style:.default) { (_) -> Void in
            
            self.performSegue(withIdentifier: "Done", sender: self)
            
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
        
        let when = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: when){
            alertController.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "Done", sender: self)
        }
    }
}

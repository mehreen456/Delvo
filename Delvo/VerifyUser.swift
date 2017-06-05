


//
//  VerifyUser.swift
//  Delvo
//
//  Created by Apple on 21/04/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class VerifyUser: UIViewController ,UITextFieldDelegate , NVActivityIndicatorViewable{

   
    @IBOutlet weak var EnterButton: UIButton!
    @IBOutlet weak var CodeView: UIView!
    @IBOutlet weak var LoaderView: UIView!
    @IBOutlet weak var PinTextField: UITextField!
    @IBOutlet weak var TimerLabel: UILabel!
   
    let obj = OrderDescClassMethods()
    let myobj = ApiParsing()
    let DMobj = DelvoMethods()
    var seconds = 60
    var timer = Timer()
    var isTimerRunning = false
    var origin:CGFloat?
    
    @IBOutlet weak var ResendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.PinTextField.delegate = self
        self.PinTextField.inputAccessoryView = obj.AddDoneButton(controller: self)
        self.LoaderView.isHidden = true
        self.TimerLabel.isHidden = true
        self.origin = self.view.frame.origin.y
        self.CodeView.SetCorners(radius: 5)
        self.ResendButton.SetCorners(radius: 5)
        self.EnterButton.SetCorners(radius: 5)
        DMobj.AddGesture(controller:self)
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false    }

    @IBAction func Login(_ sender: Any) {
        
        startAnimating(CGSize(width:60 ,height:60) , message: "Verifying Pin ..." , messageFont: UIFont.boldSystemFont(ofSize: 17) , type:.ballClipRotatePulse , color: UIColor.white
            , backgroundColor: UIColor.clear
        )
        self.LoaderView.isHidden=false
      
        myobj.VerifyPin( phone: UserInfo.Phone, password: UserInfo.Password, pin: self.PinTextField.text!, Success: { (token,message) -> () in
            self.removeLoader()
            let UserToken = token
            self.getProfile(U_token:token)
            UserDefaults.standard.setValue(UserToken, forKey: "UserToken")
            
            self.performSegue(withIdentifier: "SignUp", sender: self)
        }
            , failure: { (message) -> () in
                 self.removeLoader()
                self.obj.alert(message:message ,title: "Failed" ,controller: self)
        }
            , Failure: { (error) -> () in
                 self.removeLoader()
                self.obj.alert(message:"Can't get respose" ,title: "Failed" ,controller: self)
        })

    }
    
    func removeLoader(){
        
        self.stopAnimating()
        self.LoaderView.isHidden=true
    }
    
    @IBAction func ResendCodeButton(_ sender: Any) {
        
        startAnimating(CGSize(width:60 ,height:60) , message: "Sending Request ..." , messageFont: UIFont.boldSystemFont(ofSize: 17) , type:.ballClipRotatePulse , color: UIColor.white
            , backgroundColor: UIColor.clear
        )
        self.LoaderView.isHidden=false
        
        myobj.ResendPin( phone: UserInfo.Phone, password: UserInfo.Password, Success: { (message) -> () in
             self.removeLoader()
            self.obj.alert(message:message ,title: "Sent" ,controller: self)
            self.ResendButton.isEnabled = false
            self.TimerLabel.isHidden = false
            self.seconds = 60
            self.TimerLabel.text = "You can resend request after \(self.seconds) seconds"
            self.runTimer()
        }
            , failure: { (message) -> () in
                 self.removeLoader()
                self.obj.alert(message:message ,title: "Failed" ,controller: self)
        }
            , Failure: { (error) -> () in
                 self.removeLoader()
                self.obj.alert(message:"Can't get response" ,title: "Failed" ,controller: self)
        })
    }
    
    func runTimer(){
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func updateTimer(){
        
        if seconds == 0{
            
            self.timer.invalidate()
            self.ResendButton.isEnabled = true
            self.TimerLabel.isHidden = true
        }
            
        else{
        seconds -= 1
        TimerLabel.text = "You can resend request after \(seconds) seconds"}
    }
    
    @IBAction func GoBack(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    func getProfile(U_token:String){
        
        myobj.MyProfile(token: U_token , Success: { (json) -> () in
            
            if json{
                
                
            }
        }
            , failure: { (message) -> () in
                
                self.obj.alert(message:message ,title: "Faliure" ,controller: self)}
            
            , Failure: { (error) -> () in
                
                self.obj.alert(message:error.description ,title: "Faliure" ,controller: self)        })
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.PinTextField {
            
            self.view.frame.origin.y = self.origin! - 100
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.dismissKeyboard()
        self.view.frame.origin.y = self.origin!
        return true
        
    }

}

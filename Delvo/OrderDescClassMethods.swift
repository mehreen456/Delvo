//
//  OrderDescClassMethods.swift
//  Delvo
//
//  Created by Apple on 01/03/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class OrderDescClassMethods: NSObject {

    func alert(message: String, title: String = "" , controller:UIViewController) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler:nil)
        alertController.addAction(OKAction)
        controller.present(alertController, animated: true, completion: nil)
        self.DismissAlertView(alertview: alertController)
    }
    
    func DismissAlertView(alertview:UIAlertController)
    {
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when){
            alertview.dismiss(animated: true, completion: nil)}
    }

    func AddBorder(textview:UITextView){
        
        textview.layer.borderColor = UIColor.lightGray.cgColor
        textview.layer.borderWidth = 1
        textview.layer.cornerRadius = 5
    }
    
    func ShowAlert(controller:UIViewController, identifier:String, message:String){
        
        let alertController = UIAlertController(title: "Success" , message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style:.default,handler:{ action in controller.performSegue(withIdentifier: identifier, sender: self)})
        alertController.addAction(OKAction)
        controller.present(alertController, animated: true, completion: nil)
        
    }
    
    func validate(phoneNumber: String) -> Bool {
        
        let PHONE_REGEX = "^[0-9]{10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: phoneNumber)
        return result
    }
    
    func isValidEmail(email:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func isValidPassword(password:String) -> Bool {
        
       
        return true
    }

    
    func AddDoneButton(controller: UIViewController) -> UIToolbar{
        
        let keyboardDoneButtonView = UIToolbar.init()
        keyboardDoneButtonView.sizeToFit()
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.done,
                                              target: controller,
                                            action:#selector(PickUpViewController.dismissKeyboard))
        doneButton.tintColor = UIColor.DoneButtonColor()
        keyboardDoneButtonView.items = [doneButton]
        return keyboardDoneButtonView
    }

    func EmptyUserDefaults(){
        
         UserDefaults.standard.removeObject(forKey: "MyOrder")
    }
}

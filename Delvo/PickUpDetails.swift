
//
//  PickUpDetails.swift
//  Delvo
//
//  Created by Apple on 19/04/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PickUpDetails: UIViewController  {

    @IBOutlet weak var ContactView: UIView!
    @IBOutlet weak var SenderName: UITextField!
    @IBOutlet weak var SenderAddress: UITextField!
    @IBOutlet weak var SenderContact: UITextField!
    @IBOutlet weak var PickUpTime: UITextField!
    @IBOutlet weak var PickUpDate: UITextField!
    @IBOutlet weak var PickUpDetail: UITextView!
    @IBOutlet weak var PickUpAmount: UITextField!
    @IBOutlet weak var AmountView: UIView!
    @IBOutlet weak var ToastView: UIView!
    @IBOutlet weak var CheckButton: UIButton!
    @IBOutlet weak var PickUpButtonView: UIView!
  
    let DatePicker = UIDatePicker()
    let TimePicker = UIDatePicker()
    let DefaultText = "PickUp Details"
    let obj = OrderDescClassMethods()
    let PhoneValidationError = "Invalid PhoneNo"
    let DMobj = DelvoMethods()
    let diposeBag = DisposeBag()
    let Description = "PickUp Details"
    var frameorigin:CGRect?
    var origin:CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        PickUpDetail.delegate = self
        self.ToastView.isHidden = true
        self.AmountView.isHidden = true
        self.PickUpAmount.isHidden = true
        self.setDelegate()
        self.setOrigin()
        DMobj.AddGesture(controller: self)
        self.SenderContact.inputAccessoryView = obj.AddDoneButton(controller: self)
        self.PickUpAmount.inputAccessoryView = obj.AddDoneButton(controller: self)
        self.TimePickerMethod()
        self.DatePickerMethod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.SenderName.text = Pick_Detail.PickName
        self.SenderContact.text = Pick_Detail.PickContact
        self.SenderAddress.text = Pick_Detail.PickAddress
        self.PickUpTime.text = Pick_Detail.PickUpTime
        self.PickUpDate.text = Pick_Detail.PickUpDate
        
        if Pick_Detail.PickUpDetail != ""{
            self.PickUpDetail.text = Pick_Detail.PickUpDetail
        }
        if Pick_Detail.PickUpAmount != ""{
            self.AmountView.isHidden = false
            self.PickUpAmount.isHidden = false
            self.CheckButton.setImage(UIImage(named:"PayCheck"), for: .normal)
            self.PickUpAmount.text = Pick_Detail.PickUpAmount
        }
        self.setTextFields()
    }
       
    @IBAction func CheckButton(_ sender: Any) {
        
        if CheckButton.image(for: .normal) == UIImage(named:"PayUncheck"){
            self.AmountView.isHidden = false
            self.PickUpAmount.isHidden = false
            self.CheckButton.setImage(UIImage(named:"PayCheck"), for: .normal)
        }
            
        else{
            self.CheckButton.setImage(UIImage(named:"PayUncheck"), for: .normal)
            self.AmountView.isHidden = true
            self.PickUpAmount.isHidden = true
            Pick_Detail.PickUpAmount = ""
            PickUpAmount.text = ""
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        guard PickUpDetail.text != DefaultText && PickUpDetail.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != "" && SenderAddress.text != "" && SenderContact.text != "" && PickUpTime.text != "" && PickUpDate.text != "" && SenderName.text != "" else {
            
            DMobj.Toast(view: self.view, ToastView: self.ToastView, message:"Please fill the fields.")
            return false
        }
                
        if !obj.validate(phoneNumber: self.SenderContact.text!) {
            self.obj.alert(message: PhoneValidationError, controller: self)
            ContactView.addRedBorder()
            return false
        }
        else{
            ContactView.removeBorder()
        }
        return true
    }
    
    func setOrigin(){
        
        origin = self.view.frame.origin.y
        self.frameorigin = self.view.frame
    }

    func setTextFields(){
        
        self.SenderName.rx.text.asObservable().subscribe(onNext: {
            text in
            
            Pick_Detail.PickName = self.SenderName.text!
            
        }).addDisposableTo(diposeBag)
        
        self.SenderAddress.rx.text.asObservable().subscribe(onNext: {
            text in
            
            Pick_Detail.PickAddress = self.SenderAddress.text!
            
            
        }).addDisposableTo(diposeBag)
        
        self.SenderContact.rx.text.asObservable().subscribe(onNext: {
            text in
            
            Pick_Detail.PickContact = self.SenderContact.text!
            
        }).addDisposableTo(diposeBag)
        
        self.PickUpTime.rx.text.asObservable().subscribe(onNext: {
            text in
            
            Pick_Detail.PickUpTime = self.PickUpTime.text!
            
        }).addDisposableTo(diposeBag)
        
        self.PickUpDate.rx.text.asObservable().subscribe(onNext: {
            text in
            
            Pick_Detail.PickUpDate = self.PickUpDate.text!
            
        }).addDisposableTo(diposeBag)
        
        self.PickUpAmount.rx.text.asObservable().subscribe(onNext: {
            text in
            
            Pick_Detail.PickUpAmount = self.PickUpAmount.text!
            
        }).addDisposableTo(diposeBag)
        
        self.PickUpDetail.rx.text.asObservable().subscribe(onNext: {
            text in
            
            Pick_Detail.PickUpDetail = self.PickUpDetail.text!
            
        }).addDisposableTo(diposeBag)
    }
    
    func setDelegate(){
        
        self.SenderName.delegate = self
        self.SenderAddress.delegate = self
        self.SenderContact.delegate = self
        self.PickUpDate.delegate = self
        self.PickUpTime.delegate = self
        self.PickUpDetail.delegate = self
        self.PickUpAmount.delegate = self
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
        self.view.frame.origin.y = origin!
    }
    
    func TimePickerMethod(){
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        TimePicker.datePickerMode = .time
        TimePicker.minimumDate = NSDate() as Date
        TimePicker.backgroundColor = UIColor.PrimaryBlueColor()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(DonePressedTime))
        toolbar.setItems([doneButton], animated: false)
        PickUpTime.inputAccessoryView = toolbar
        PickUpTime.inputView = TimePicker
    }
    
    func DonePressedTime(){
        
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .none
        dateFormater.timeStyle = .medium
        dateFormater.dateFormat = "h:mm a"
        PickUpTime.text = dateFormater.string(for: TimePicker.date)
        self.view.endEditing(true)
    }
    
    func DatePickerMethod(){
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        DatePicker.datePickerMode = .date
        DatePicker.backgroundColor = UIColor.PrimaryBlueColor()
        DatePicker.minimumDate = NSDate() as Date

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(DonePressedDate))
        toolbar.setItems([doneButton], animated: false)
        PickUpDate.inputAccessoryView = toolbar
        PickUpDate.inputView = DatePicker
    }
    
    func DonePressedDate(){
        
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .medium
        dateFormater.timeStyle = .none
        dateFormater.dateFormat = "MM-dd-yyyy"
        PickUpDate.text = dateFormater.string(for: DatePicker.date)
        self.view.endEditing(true)
    }
    @IBAction func GoToPickLoc(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }

}

extension PickUpDetails: UITextFieldDelegate, UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        self.view.frame.origin.y = self.origin! - 130
        if PickUpDetail.text == DefaultText{
            PickUpDetail.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if PickUpDetail.text == ""{
            PickUpDetail.text = DefaultText
        }
        Pick_Detail.PickUpDetail = self.PickUpDetail.text!
        self.view.frame.origin.y = self.origin!
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.PickUpAmount {
            
            self.view.frame.origin.y = self.origin! - 190
        }
        
        if textField == self.PickUpDate {
            
            self.view.frame.origin.y = self.origin! - 100
        }
        
            return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        self.view.frame.origin.y = self.origin!
        return true

    }
    
}



//
//  DropDetailsVc.swift
//  Delvo
//
//  Created by Apple on 20/04/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DropDetailsVc: UIViewController  {
   
    @IBOutlet weak var DropName: UITextField!
    @IBOutlet weak var DropContact: UITextField!
    @IBOutlet weak var DropAddress: UITextField!
    @IBOutlet weak var DropDate: UITextField!
    @IBOutlet weak var DropTime: UITextField!
    @IBOutlet weak var DropAmount: UITextField!
    @IBOutlet weak var AmountView: UIView!
    @IBOutlet weak var ToastView: UIView!
    @IBOutlet weak var DropDetail: UITextView!
    @IBOutlet weak var DropButtonView: UIView!
    @IBOutlet weak var ContactView: UIView!
    @IBOutlet weak var CheckButton: UIButton!
   
    var frameorigin:CGRect?
    var origin:CGFloat?
    let DMobj = DelvoMethods()
    let diposeBag = DisposeBag()
    let DefaultText = "Drop Details"
    let obj = OrderDescClassMethods()
    let PhoneValidationError = "Invalid PhoneNo"
    let DatePicker = UIDatePicker()
    let TimePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DropDetail.delegate = self
        self.ToastView.isHidden = true
        self.AmountView.isHidden = true
        self.DropAmount.isHidden = true
        self.setDelegate()
        self.setOrigin()
        DMobj.AddGesture(controller: self)
        self.DropContact.inputAccessoryView = obj.AddDoneButton(controller: self)
        self.DropAmount.inputAccessoryView = obj.AddDoneButton(controller: self)
        self.TimePickerMethod()
        self.DatePickerMethod()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.DropName.text = Drop_Detail.DropName
        self.DropContact.text = Drop_Detail.DropContact
        self.DropAddress.text = Drop_Detail.DropAddress
        self.DropTime.text = Drop_Detail.DropTime
        self.DropDate.text = Drop_Detail.DropDate
        
        if Drop_Detail.DropDetail != ""{
            self.DropDetail.text = Drop_Detail.DropDetail
        }
        if Drop_Detail.DropAmount != ""{
            self.AmountView.isHidden = false
            self.DropAmount.isHidden = false
            self.CheckButton.setImage(UIImage(named:"PayCheck"), for: .normal)
            self.DropAmount.text = Drop_Detail.DropAmount
        }
        self.setTextFields()
    }
    
    @IBAction func CheckButton(_ sender: Any) {
        
        if CheckButton.image(for: .normal) == UIImage(named:"PayUncheck"){
            self.AmountView.isHidden = false
            self.DropAmount.isHidden = false
            self.CheckButton.setImage(UIImage(named:"PayCheck"), for: .normal)
        }
            
        else{
            self.CheckButton.setImage(UIImage(named:"PayUncheck"), for: .normal)
            self.AmountView.isHidden = true
            self.DropAmount.isHidden = true
            Pick_Detail.PickUpAmount = ""
            DropAmount.text = ""
        }
    }
    
    func setTextFields(){
        
        self.DropName.rx.text.asObservable().subscribe(onNext: {
            text in
            
            Drop_Detail.DropName = self.DropName.text!
            
        }).addDisposableTo(diposeBag)
        
        self.DropAddress.rx.text.asObservable().subscribe(onNext: {
            text in
            
            Drop_Detail.DropAddress = self.DropAddress.text!
            
        }).addDisposableTo(diposeBag)
        
        self.DropContact.rx.text.asObservable().subscribe(onNext: {
            text in
            
            Drop_Detail.DropContact = self.DropContact.text!
            
        }).addDisposableTo(diposeBag)
        
        self.DropDate.rx.text.asObservable().subscribe(onNext: {
            text in
            
            Drop_Detail.DropDate = self.DropDate.text!
            
        }).addDisposableTo(diposeBag)
        
        self.DropTime.rx.text.asObservable().subscribe(onNext: {
            text in
            
            Drop_Detail.DropTime = self.DropTime.text!
            
        }).addDisposableTo(diposeBag)
        
        self.DropAmount.rx.text.asObservable().subscribe(onNext: {
            text in
            
            Drop_Detail.DropAmount = self.DropAmount.text!
            
        }).addDisposableTo(diposeBag)
        
        self.DropDetail.rx.text.asObservable().subscribe(onNext: {
            text in
            
            Drop_Detail.DropDetail = self.DropDetail.text!
            
        }).addDisposableTo(diposeBag)
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        guard DropDetail.text != DefaultText  && DropDetail.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != "" && DropAddress.text != "" && DropContact.text != "" && DropTime.text != "" && DropDate.text != "" && DropName.text != "" else {
            
            DMobj.Toast(view: self.view, ToastView: self.ToastView, message:"Please fill the fields.")
            return false
        }
        
        if !obj.validate(phoneNumber: self.DropContact.text!) {
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
    
    func setDelegate(){
        
        self.DropName.delegate = self
        self.DropAddress.delegate = self
        self.DropContact.delegate = self
        self.DropTime.delegate = self
        self.DropDate.delegate = self
        self.DropDetail.delegate = self
        self.DropAmount.delegate = self
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
        self.view.frame.origin.y = origin!
    }
    func TimePickerMethod(){
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        TimePicker.datePickerMode = .time
        TimePicker.backgroundColor = UIColor.PrimaryBlueColor()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(DonePressedTime))
        toolbar.setItems([doneButton], animated: false)
        DropTime.inputAccessoryView = toolbar
        DropTime.inputView = TimePicker
    }
    
    func DonePressedTime(){
        
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .none
        dateFormater.timeStyle = .medium
        DropTime.text = dateFormater.string(for: TimePicker.date)
        self.view.endEditing(true)
    }
    
    func DatePickerMethod(){
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        DatePicker.datePickerMode = .date
        DatePicker.minimumDate = NSDate() as Date
        DatePicker.backgroundColor = UIColor.PrimaryBlueColor()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(DonePressedDate))
        toolbar.setItems([doneButton], animated: false)
        DropDate.inputAccessoryView = toolbar
        DropDate.inputView = DatePicker
    }
    
    func DonePressedDate(){
        
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .medium
        dateFormater.timeStyle = .none
        DatePicker.minimumDate = Date()
        DropDate.text = dateFormater.string(for: DatePicker.date)
        self.view.endEditing(true)
    }

}

extension DropDetailsVc: UITextFieldDelegate, UITextViewDelegate{
    

    func textViewDidBeginEditing(_ textView: UITextView) {
        
        self.view.frame.origin.y = self.origin! - 130
        if DropDetail.text == DefaultText{
            DropDetail.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if DropDetail.text == ""{
            DropDetail.text = DefaultText
        }
        Drop_Detail.DropDetail = self.DropDetail.text!
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
        
        if textField == self.DropAmount {
            
            self.view.frame.origin.y = self.origin! - 190
        }
        
        if textField == self.DropDate {
            
            self.view.frame.origin.y = self.origin! - 100
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.view.frame.origin.y = self.origin!
        return true
        
    }

}


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
    
    @IBOutlet weak var DetailView: UIView!
    @IBOutlet weak var EditAmount: UIButton!
    @IBOutlet weak var AmountButton: UIButton!
    @IBOutlet weak var PickDateLabel: UILabel!
    @IBOutlet weak var PickTimeLabel: UILabel!
    @IBOutlet weak var NameView: UIView!
    @IBOutlet weak var AddressView: UIView!
    @IBOutlet weak var DateView: UIView!
    @IBOutlet weak var ContactView: UIView!
    @IBOutlet weak var TimeView: UIView!
    @IBOutlet weak var SenderName: UITextField!
    @IBOutlet weak var SenderAddress: UITextField!
    @IBOutlet weak var SenderContact: UITextField!
    @IBOutlet weak var PickUpTime: UITextField!
    @IBOutlet weak var PickUpDate: UITextField!
    @IBOutlet weak var PickUpDetail: UITextView!
    @IBOutlet weak var ToastView: UIView!
    @IBOutlet weak var CheckButton: UIButton!
    @IBOutlet weak var PickUpButtonView: UIView!
    @IBOutlet weak var DDButton: UIButton!
    @IBOutlet weak var DDLine: UIView!
    @IBOutlet weak var DLocLine: UIView!
    @IBOutlet weak var DropLocButton: UIButton!
    
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
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.DateView.setBottomBorder()
        self.TimeView.setBottomBorder()
        MoveToVc.visitPD=true
        PickUpDetail.delegate = self
        self.ToastView.isHidden = true
        self.setDelegate()
        self.setOrigin()
        DMobj.AddGesture(controller: self)
        EditAmount.isHidden = true
        self.SenderContact.inputAccessoryView = obj.AddDoneButton(controller: self)
        //   self.PickUpAmount.inputAccessoryView = obj.AddDoneButton(controller: self)
        self.TimePickerMethod()
        self.DatePickerMethod()
        self.setViews()
    }
    
    func setViews(){
        
        self.NameView.SetCorners(radius: 5)
        self.ContactView.SetCorners(radius: 5)
        self.AddressView.SetCorners(radius: 5)
        self.DetailView.SetCorners(radius: 5)
        //   self.AmountView.SetCorners(radius: 5)
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
            
            self.AmountButton.setImage(UIImage(named:"PayCheck"), for: .normal)
            EditAmount.isHidden = false
            
            //            self.AmountView.isHidden = false
            //            self.PickUpAmount.isHidden = false
            //            self.CheckButton.setImage(UIImage(named:"PayCheck"), for: .normal)
            //            self.PickUpAmount.text = Pick_Detail.PickUpAmount
        }
        if Pick_Detail.timeCritical {
            
            setDateTime(enable:false , color:UIColor.gray , labelColor:UIColor.gray , image: UIImage(named:"PayCheck")! )
        }
        
        self.setTextFields()
        
        if MoveToVc.PD_visitDD {
            
            DDLine.backgroundColor = UIColor.white
            self.DDButton.setImage(UIImage(named:"bagEnable"), for: .normal)
            DDButton.isUserInteractionEnabled = true
        }
        
        if MoveToVc.PD_visitDL{
            
            DLocLine.backgroundColor = UIColor.white
            self.DropLocButton.setImage(UIImage(named:"DropEnable"), for: .normal)
            DropLocButton.isUserInteractionEnabled = true
            
        }
        
    }
    
    @IBAction func CheckButton(_ sender: Any) {
        
        if CheckButton.image(for: .normal) == UIImage(named:"PayUncheck"){
            
            //            self.AmountView.isHidden = false
            //            self.PickUpAmount.isHidden = false
            
            setDateTime(enable:false , color:UIColor.gray , labelColor:UIColor.gray , image: UIImage(named:"PayCheck")! )
            Pick_Detail.timeCritical = true
        }
            
        else{
            
            setDateTime(enable:true , color:UIColor.DoneButtonColor() ,labelColor:UIColor.black , image: UIImage(named:"PayUncheck")! )
            Pick_Detail.timeCritical = false
            
            //            self.AmountView.isHidden = true
            //            self.PickUpAmount.isHidden = true
            //            Pick_Detail.PickUpAmount = ""
            //            PickUpAmount.text = ""
        }
    }
    
    func setDateTime(enable:Bool , color:UIColor , labelColor:UIColor , image:UIImage ){
        
        PickUpTime.isEnabled = enable
        PickUpDate.isEnabled = enable
        self.PickDateLabel.textColor = labelColor
        self.PickTimeLabel.textColor = labelColor
        PickUpTime.textColor = color
        PickUpDate.textColor = color
        PickUpTime.attributedPlaceholder = NSAttributedString(string:"h:mm a", attributes: [NSForegroundColorAttributeName: color])
        PickUpDate.attributedPlaceholder = NSAttributedString(string:"dd-MM-yyyy", attributes: [NSForegroundColorAttributeName: color])
        self.CheckButton.setImage(image, for: .normal)
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "Drop"{
            
            guard PickUpDetail.text != DefaultText && PickUpDetail.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != "" && SenderAddress.text != "" && SenderContact.text != "" && SenderName.text != "" else {
                
                DMobj.Toast(view: self.view, ToastView: self.ToastView, message:"Please fill the fields.")
                return false
            }
            if !Pick_Detail.timeCritical{
                
                if PickUpTime.text == "" && PickUpDate.text == "" {
                    
                    DMobj.Toast(view: self.view, ToastView: self.ToastView, message:"Please fill the fields.")
                    return false
                    
                }
                return checkDate()
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
        return false
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
            
            Pick_Detail.PickContact =  self.SenderContact.text!
            
        }).addDisposableTo(diposeBag)
        
        //        self.PickUpAmount.rx.text.asObservable().subscribe(onNext: {
        //            text in
        //
        //            Pick_Detail.PickUpAmount = self.PickUpAmount.text!
        //
        //        }).addDisposableTo(diposeBag)
        //
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
        //   self.PickUpAmount.delegate = self
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
        self.view.frame.origin.y = origin!
    }
    
    func TimePickerMethod(){
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        TimePicker.datePickerMode = .time
        TimePicker.backgroundColor = UIColor.white
        TimePicker.setValue(UIColor.ToastViewColor()
            , forKeyPath: "textColor")
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(DonePressedTime))
        doneButton.tintColor = UIColor.DoneButtonColor()
        toolbar.setItems([doneButton], animated: false)
        PickUpTime.inputAccessoryView = toolbar
        PickUpTime.inputView = TimePicker
    }
    
    func DonePressedTime(){
        
        let PickTime = obj.formatDate(format: "h:mm a" , date:TimePicker.date)
        Pick_Detail.PickUpTime = PickTime
        PickUpTime.text = PickTime
        self.view.endEditing(true)
    }
    
    func DatePickerMethod(){
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        DatePicker.datePickerMode = .date
        DatePicker.backgroundColor = UIColor.white
        DatePicker.setValue(UIColor.ToastViewColor()
            , forKeyPath: "textColor")
        DatePicker.minimumDate = Date()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(DonePressedDate))
        doneButton.tintColor = UIColor.DoneButtonColor()
        toolbar.setItems([doneButton], animated: false)
        PickUpDate.inputAccessoryView = toolbar
        PickUpDate.inputView = DatePicker
    }
    
    func DonePressedDate(){
        
        let PickDate = obj.formatDate(format:"dd-MM-yyyy" , date:DatePicker.date)
        PickUpDate.text = PickDate
        Pick_Detail.PickUpDate = PickDate
        self.view.endEditing(true)
    }
    
    func checkDate() -> Bool {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        if Pick_Detail.PickUpDate == formatter.string(for:date){
            
            let formatter = DateFormatter()
            formatter.dateFormat="h:mm a"
            let currdate = formatter.string(for:date)
            let TimeA = formatter.date(from: Pick_Detail.PickUpTime)
            let TimeB = formatter.date(from: currdate!)
            
            if TimeB! > TimeA! {
                
                self.obj.alert(message: "Invalid Time. Pickup time can not be less than current time.", controller: self)
                return false
            }
        }
        
        return true
    }
    
    func presentAlert() {
        let alertController = UIAlertController(title: "Ammount", message: "Enter amount that you want rider to pay at pick up on your behalf.", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                Pick_Detail.PickUpAmount = field.text!
                if Pick_Detail.PickUpAmount != ""{
                    self.isSelected(image:UIImage(named:"PayCheck")!, show: false)
                }
                else{
                    self.isSelected(image:UIImage(named:"PayUncheck")!, show: true)
                }
                
            } else {
                if Pick_Detail.PickUpAmount == ""{
                    self.isSelected(image:UIImage(named:"PayUncheck")!, show: true)
                    
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            if Pick_Detail.PickUpAmount == ""{
                self.isSelected(image:UIImage(named:"PayUncheck")!, show: true)
            }
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "eg. 1500"
            if Pick_Detail.PickUpAmount != "" {
                textField.text = Pick_Detail.PickUpAmount
            }
            textField.keyboardType = UIKeyboardType.numberPad
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func isSelected(image:UIImage , show:Bool){
        
        self.AmountButton.setImage(image, for: .normal)
        self.EditAmount.isHidden = false
    }
    
    @IBAction func GoToPickLoc(_ sender: Any) {
        
        self.performSegue(withIdentifier: "RPick", sender: self)
        
    }
    @IBAction func DropDButtonA(_ sender: Any){
        self.performSegue(withIdentifier: "GoDropD", sender: self)
        
    }
    @IBAction func DropLocButtonA(_ sender: Any) {
        self.performSegue(withIdentifier: "Drop", sender: self)
    }
    
    @IBAction func PayAtPick(_ sender: Any) {
        
        if AmountButton.image(for: .normal) == UIImage(named:"PayUncheck"){
            
            self.presentAlert()
            
        }
        else {
            
            self.isSelected(image:UIImage(named:"PayUncheck")!, show: true)
            Pick_Detail.PickUpAmount = ""
            
        }
    }
    
    @IBAction func EditButton(_ sender: Any) {
        
        self.presentAlert()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.view.endEditing(true)
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
        
        if textField == self.SenderName{
            self.SenderContact.becomeFirstResponder()}
        
        if textField == self.SenderContact{
            self.SenderAddress.becomeFirstResponder()}
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.SenderAddress {
            
            self.view.frame.origin.y = self.origin! - 150
        }
        
        //        if textField == self.PickUpAmount {
        //
        //            self.view.frame.origin.y = self.origin! - 150
        //        }
        
        if textField == self.PickUpDate {
            
            self.view.frame.origin.y = self.origin! - 150
        }
        
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        self.view.frame.origin.y = self.origin!
        return true
        
    }
    
}

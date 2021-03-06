

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
import NVActivityIndicatorView

class DropDetailsVc: UIViewController , NVActivityIndicatorViewable {
    
    @IBOutlet weak var NameView: UIView!
    @IBOutlet weak var DetailView: UIView!
    @IBOutlet weak var AddressView: UIView!
    @IBOutlet weak var LoaderView: UIView!
    @IBOutlet weak var DateView: UIView!
    @IBOutlet weak var TimeView: UIView!
    @IBOutlet weak var DropName: UITextField!
    @IBOutlet weak var DropContact: UITextField!
    @IBOutlet weak var DropAddress: UITextField!
    @IBOutlet weak var DropDate: UITextField!
    @IBOutlet weak var DropTime: UITextField!
    @IBOutlet weak var ToastView: UIView!
    @IBOutlet weak var DropDetail: UITextView!
    @IBOutlet weak var ContactView: UIView!
    
    var frameorigin:CGRect?
    var origin:CGFloat?
    let DMobj = DelvoMethods()
    let diposeBag = DisposeBag()
    let DefaultText = "Drop Details"
    let obj = OrderDescClassMethods()
    let PhoneValidationError = "Invalid PhoneNo"
    let DatePicker = UIDatePicker()
    let TimePicker = UIDatePicker()
    let ApiObj = ApiParsing()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        MoveToVc.visitDD=true
        MoveToVc.PD_visitDD = true
        MoveToVc.DL_visitDD=true
        DropDetail.delegate = self
        self.ToastView.isHidden = true
        self.LoaderView.isHidden=true
        self.setDelegate()
        self.setOrigin()
        DMobj.AddGesture(controller: self)
        self.DropContact.inputAccessoryView = obj.AddDoneButton(controller: self)
        self.TimePickerMethod()
        self.TimeView.setBottomBorder()
        self.DateView.setBottomBorder()
        self.setViews()
        Drop_Detail.DropDate = Pick_Detail.PickUpDate
        DropDate.isEnabled = false
    }
    
    func setViews(){
        
        self.NameView.SetCorners(radius: 5)
        self.ContactView.SetCorners(radius: 5)
        self.AddressView.SetCorners(radius: 5)
        self.DetailView.SetCorners(radius: 5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.DropName.text = Drop_Detail.DropName
        self.DropContact.text = Drop_Detail.DropContact
        self.DropAddress.text = Drop_Detail.DropAddress
        self.DropTime.text = Drop_Detail.DropTime
        if Pick_Detail.timeCritical {
            
            self.DropDate.text = obj.formatDate(format:"dd-MM-yyyy" , date: Date())
        }
            
        else {
            self.DropDate.text = Pick_Detail.PickUpDate
        }
        
        if Drop_Detail.DropDetail != ""{
            self.DropDetail.text = Drop_Detail.DropDetail
        }
        self.setTextFields()
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
            
            Drop_Detail.DropContact =  self.DropContact.text!
            
        }).addDisposableTo(diposeBag)
        
        self.DropDetail.rx.text.asObservable().subscribe(onNext: {
            text in
            
            Drop_Detail.DropDetail = self.DropDetail.text!
            
        }).addDisposableTo(diposeBag)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        return false
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
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat="h:mm a"
        var TimeA = Date()
        if Pick_Detail.timeCritical {
            
            TimeA = formatter.date(from: obj.formatDate(format:"h:mm a" , date: Date()))!
            
        }
        else {
            TimeA = formatter.date(from: Pick_Detail.PickUpTime)!
        }
        
        let date:Date = calendar.date(byAdding: .minute, value: 45, to: TimeA)!
        TimePicker.minimumDate = date
        TimePicker.date = date
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(DonePressedTime))
        doneButton.tintColor = UIColor.DoneButtonColor()
        toolbar.setItems([doneButton], animated: false)
        DropTime.inputAccessoryView = toolbar
        DropTime.inputView = TimePicker
        DonePressedTime()
    }
    
    func DonePressedTime(){
        
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .none
        dateFormater.timeStyle = .medium
        dateFormater.dateFormat="h:mm a"
        DropTime.text = dateFormater.string(for: TimePicker.date)
        Drop_Detail.DropTime = dateFormater.string(for: TimePicker.date)!
        self.view.endEditing(true)
    }
    
    @IBAction func GoToPickLoc(_ sender: Any) {
        
        self.performSegue(withIdentifier: "GoPick", sender: self)
    }
    
    @IBAction func GoToPickDetail(_ sender: Any) {
        
        self.performSegue(withIdentifier: "GoPickD", sender: self)
    }
    
    @IBAction func GoToDropLoc(_ sender: Any) {
        
        self.performSegue(withIdentifier: "GoDrop", sender: self)
    }
    
    @IBAction func AddDropButton(_ sender: Any) {
        
        guard DropDetail.text != DefaultText  && DropDetail.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != "" && DropAddress.text != "" && DropContact.text != "" && DropTime.text != "" && DropDate.text != "" && DropName.text != "" else {
            
            DMobj.Toast(view: self.view, ToastView: self.ToastView, message:"Please fill the fields.")
            return
        }
        
        if !obj.validate(phoneNumber: self.DropContact.text!) {
            self.obj.alert(message: PhoneValidationError, controller: self)
            ContactView.addRedBorder()
            return
        }
        else{
            ContactView.removeBorder()
        }
        
        self.PlaceOrder()
        //ComapareDates()
        
    }
    
    func PlaceOrder(){
        
        let U_token = UserDefaults.standard.value(forKey: "UserToken") as! String
        self.dismissKeyboard()
        startAnimating(CGSize(width:50 ,height:50) , message: "Placing Order ..." , messageFont: UIFont.boldSystemFont(ofSize: 15) , type:.ballClipRotatePulse , color: UIColor.white
            , backgroundColor: UIColor.clear)
        self.LoaderView.isHidden=false
        ApiObj.PlaceOrder(token: U_token, Success:{ (message) -> () in
            
            self.obj.ShowAlert(controller: self, identifier: "OrderPlaced", message: message)
            self.EmptyOrderDetails()
            self.removeLoader()
            
        }
            , failure: { (message) -> () in
                
                self.removeLoader()
                self.obj.alert(message:message ,title: "Failed" ,controller: self)
        }
            , Failure: { (error) -> () in
                
                self.removeLoader()
                self.obj.alert(message:"Internet connection failed." ,title: "Failed" ,controller: self)
        })
        
    }
    
    func removeLoader(){
        
        self.stopAnimating()
        self.LoaderView.isHidden=true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.view.endEditing(true)
    }
    
    func EmptyOrderDetails(){
        
        _ = Pick_Detail.init()
        _ = Drop_Detail.init()
        _ = MoveToVc.init()
        _ = Location.init()
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
        
        if textField == self.DropAddress {
            
            self.view.frame.origin.y = self.origin! - 100
        }
        
        if textField == self.DropTime {
            
            self.view.frame.origin.y = self.origin! - 100
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

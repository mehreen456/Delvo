

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
    
    @IBAction func AddDropButton(_ sender: Any) {
        
      ComapareDates()
    }
   
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
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat="h:mm a"
        let TimeA = formatter.date(from: Pick_Detail.PickUpTime)
        let date:Date = calendar.date(byAdding: .minute, value: 30, to: TimeA!)!
        TimePicker.date = date
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
        dateFormater.dateFormat="h:mm a"
        DropTime.text = dateFormater.string(for: TimePicker.date)
        self.view.endEditing(true)
    }
    
    func DatePickerMethod(){
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        DatePicker.datePickerMode = .date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        dateFormatter.locale = Locale.init(identifier: "en_GB")
        let dateA:Date = dateFormatter.date(from: Pick_Detail.PickUpDate)!
        DatePicker.minimumDate = dateA
        DatePicker.date = dateA
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
        dateFormater.dateFormat = "MM-dd-yyyy"
        DatePicker.minimumDate = Date()
        DropDate.text = dateFormater.string(for: DatePicker.date)
        self.view.endEditing(true)
    }
    
    func ComapareDates(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        dateFormatter.locale = Locale.init(identifier: "en_GB")
        
        let dateA = dateFormatter.date(from: Pick_Detail.PickUpDate)
        print(dateA! as Date)
        
        let dateB = dateFormatter.date(from: Drop_Detail.DropDate)
        print(dateB! as Date)
       
        if dateA! > dateB!{
            
            self.obj.alert(message: "Invalid Date. Please Change PickUp Date.", controller: self)
            return
        }
        
        if dateA! == dateB!{
            
            let formatter = DateFormatter()
            formatter.dateFormat="h:mm a"
            let TimeA = formatter.date(from: Pick_Detail.PickUpTime)
            let TimeB = formatter.date(from: Drop_Detail.DropTime)
            
            let calendar = NSCalendar.current
            let components: DateComponents = calendar.dateComponents([.hour, .minute, .second], from: TimeA!, to: TimeB!)
            
            if TimeA! >= TimeB! {
                
                self.obj.alert(message: "Invalid Time. Drop time can not be less than pickup time.", controller: self)
                return
            }
            
            else{
                
                if components.hour! == 0{
                  
                    if  components.minute! < 30 {
                        
                        self.obj.alert(message: "Invalid Time. Can't deliver order before 30 minutes.", controller: self)
                        return
                    }

                }

            }
        }
    }
    
    @IBAction func GoToPickLoc(_ sender: Any) {
         _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func GoToPickDetail(_ sender: Any) {
        
        let viewControllers: [UIViewController] =  self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count
            - 3], animated: true)    }
    
    @IBAction func GoToDropLoc(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
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

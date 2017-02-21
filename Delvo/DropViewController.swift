
//
//  DropViewController.swift
//  Delvo
//
//  Created by Apple on 12/02/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class DropViewController: UIViewController , UITextFieldDelegate {
    
    struct Drop_Address{
        
        static var DropAddress = String()
    }
    
    @IBOutlet weak var ToastView: UIView!
    @IBOutlet weak var GoDelvoButton: UIButton!
    @IBOutlet weak var DropAddress: UITextField!
    @IBOutlet weak var PickUpLocation: UILabel!
    @IBOutlet weak var DropLocation: UILabel!
    @IBOutlet weak var DropView: UIView!
    @IBOutlet weak var PickUpView: UIView!
    @IBOutlet weak var MapView: UIView!
    
    var MapVC: MapViewController?
    var obj = DelvoMethods()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ShowMapView()
        self.navBar()
        self.addGesture()
        self.setTextFields()
        self.setColors()
        self.notification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        MapVC?.controller = "DropVc"
    }
    
    func ShowMapView(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        MapVC = storyboard.instantiateViewController(withIdentifier: "MapVc") as? MapViewController
        addChildViewController(MapVC!)
        MapVC?.view.frame = self.MapView.bounds
        MapView.addSubview((MapVC?.view)!)
        MapVC?.didMove(toParentViewController:self)
    }
    
    @IBAction func ChangePIckButton(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }

    // textfield delegate Methods
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        Drop_Address.DropAddress = self.DropAddress.text!
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
   // Segue Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Search"{
            
            let searchVc:SearchViewController = segue.destination as! SearchViewController
            searchVc.place = self.PickUpLocation.text!
            searchVc.delegate = MapVC as Address?
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "GoDelvo"{
            
            guard let text = DropAddress.text, !text.isEmpty else {
                
             obj.Toast(view: self.view, ToastView: self.ToastView, message:"Please enter drop address to proceed")
                return false
            }
            
        guard DropLocation.text != "Near by location" && DropLocation.text != "" else {
                
                obj.Toast(view: self.view, ToastView: self.ToastView, message:"Please select near by place")
                return false
            }
        }
        return true
    }
    
    // Class Methods
    func addGesture(){
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DropViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard(){
        
        view.endEditing(true)
    }
    
    func setColors(){
        
        self.PickUpView.backgroundColor = UIColor.DarkBlueColor()
        self.GoDelvoButton.backgroundColor = UIColor.ButtonColor()
    }
    
    func notification(){
    
        NotificationCenter.default.addObserver(self, selector: #selector(self.GetArea(_:)), name: NSNotification.Name(rawValue: "GetArea"), object: nil)
    }
    
    func GetArea(_ notification: NSNotification) {
        
        DropLocation.text = MapViewController.Location.DropLocation
    }
    
    func navBar(){
        
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "Menu.png"), for: UIControlState.normal)
        button.addTarget(self.revealViewController(), action:#selector(SWRevealViewController.rightRevealToggle(_:)), for: UIControlEvents.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        self.navigationItem.title = "Drop Location"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
    
    func setTextFields(){
        
        DropAddress.delegate = self
        PickUpLocation.text = MapViewController.Location.PickLocation
        DropLocation.text = MapViewController.Location.DropLocation
        self.ToastView.isHidden=true
    }
}

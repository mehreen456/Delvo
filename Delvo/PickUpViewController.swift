//
//  PickUpViewController.swift
//  Delvo
//
//  Created by Apple on 12/02/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class PickUpViewController: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var ToastView: UIView!
    @IBOutlet weak var PickAddress: UITextField!
    @IBOutlet weak var SideMenuButton: UIBarButtonItem!
    @IBOutlet weak var Mapview: UIView!
    @IBOutlet weak var PickUpLocation: UILabel!
    @IBOutlet weak var ProceedButton: UIButton!
    @IBOutlet weak var PickUpView: UIView!
    
    var MapVC: MapViewController?
    let obj = DelvoMethods()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navBar()
        self.ShowMapView()
        PickAddress.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.GetArea(_:)), name: NSNotification.Name(rawValue: "GetArea"), object: nil)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PickUpViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.ToastView.isHidden = true
    }
    
    func dismissKeyboard() {
       
        view.endEditing(true)
    }
    
    func GetArea(_ notification: NSNotification) {
        
        PickUpLocation.text = MapViewController.Location.PickLocation
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        MapVC?.controller = "PickUpVc"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Search"
        {
            let searchVc:SearchViewController = segue.destination as! SearchViewController
            searchVc.place = self.PickUpLocation.text!
            searchVc.delegate = MapVC as Address?
        }
    }
    

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
       
            if identifier == "Proceed"{
                
                guard let text = PickAddress.text, !text.isEmpty else {
                    
                    obj.Toast(view: self.view, ToastView: self.ToastView, message:"Please enter pick address to proceed")
                    return false
                }
                
                guard PickUpLocation.text != "Near by location" else {
                    
                    obj.Toast(view: self.view, ToastView: self.ToastView, message:"Please select near by place")
                    return false
                }
            }
            return true
    }
    
    func ShowMapView(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        MapVC = storyboard.instantiateViewController(withIdentifier: "MapVc")  as? MapViewController
        addChildViewController(MapVC!)
        MapVC?.view.frame = self.Mapview.bounds
        Mapview.addSubview((MapVC?.view)!)
        MapVC?.didMove(toParentViewController: self)
    }
    
    func navBar(){
        
        if self.revealViewController() != nil {
            
            SideMenuButton.target = self.revealViewController()
            SideMenuButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
            self.navigationController?.navigationBar.barTintColor = obj.PrimaryBlueColor()
        }
        
        self.ProceedButton.backgroundColor = obj.ButtonColor()
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        Pick_Address.PickAddress = self.PickAddress.text!
        return true
    }
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          view.endEditing(true)
        return true
    }
    
    struct Pick_Address{
        
        static var PickAddress = String()
    }
}

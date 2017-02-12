
//
//  PickUpViewController.swift
//  Delvo
//
//  Created by Apple on 12/02/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class PickUpViewController: UIViewController {

    @IBOutlet weak var SideMenuButton: UIBarButtonItem!
    
    @IBOutlet weak var Mapview: UIView!
    var MapVC: MapViewController?
    
    @IBOutlet weak var PickUpLocation: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil {
            
            SideMenuButton.target = self.revealViewController()
            SideMenuButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        self.ShowMapView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.GetArea(_:)), name: NSNotification.Name(rawValue: "GetArea"), object: nil)

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
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: self.navigationController?.navigationItem.title , style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        else{
           
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
    }
    
    func ShowMapView()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        MapVC = storyboard.instantiateViewController(withIdentifier: "MapVc")  as? MapViewController
        addChildViewController(MapVC!)
        MapVC?.view.frame = self.Mapview.bounds
        Mapview.addSubview((MapVC?.view)!)
        MapVC?.didMove(toParentViewController: self)
    }
}

//
//  MyOrdersVC.swift
//  Delvo
//
//  Created by Apple on 02/03/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NVActivityIndicatorView

class MyOrdersVC: UIViewController, OptionButtonsDelegate , NVActivityIndicatorViewable {
    
    @IBOutlet weak var LoaderView: UIView!
    @IBOutlet weak var MyOrderTable: UITableView!
    
    var cellHeight:CGFloat = 375
    var array:[NSDictionary] = []
    let obj = OrderDescClassMethods()
    let myobj = ApiParsing()
    let disposeBag = DisposeBag()
    let dmobj = DelvoMethods()
    var dataSource = Variable<[[String:Dictionary<String, String>]]>([])
    var MyCell = UITableViewCell()
    var CellHeightsArray :[CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.LoaderView.isHidden=true
        self.getToken()
        self.registerCell()
        self.navBar()
        self.setTableCell()
    }
    
    func removeLoader(){
        
        self.stopAnimating()
        self.LoaderView.isHidden=true
    }
    
    func setTableCell(){
        
        _ = self.MyOrderTable.rx.setDelegate(self)
        
        dataSource.asObservable().bindTo(MyOrderTable.rx.items(cellIdentifier: "OrderCell")){ IndexPath,dic,C_cell in
            
            if let cell = C_cell as? MyOrderCell{
                
                let pick = dic["PickTask"]
                let pickLoc = pick?["nearby"]
                cell.PickUpLabel.text = pickLoc
                print(IndexPath)
                let index = IndexPath.description
                let orderNum = Int(index)! + 1
                cell.UserName.text = "Order # " + orderNum.description
                let drop = dic["DropTask"]
                let dropLoc = drop?["nearby"]
                cell.DropLabel.text = dropLoc
                cell.delegate = self
                cell.indexPath = IndexPath
                
                self.cellHeight = self.dmobj.heightForView(text:cell.DropLabel.text!, frame:cell.DropLabel.frame,size: 13.0) + self.dmobj.heightForView(text:cell.PickUpLabel.text!, frame:cell.PickUpLabel.frame,size: 13.0) + 230
                
                
                self.CellHeightsArray.append(self.cellHeight)
                self.dmobj.AddBorder(height: self.cellHeight,view: cell.CellView)
                
            }
            }.addDisposableTo(disposeBag)
        
        self.MyOrderTable.alwaysBounceVertical = false

    }
    
    func registerCell(){
        
        let yourNibName = UINib(nibName: "MyOrderCell", bundle: nil)
        MyOrderTable.register(yourNibName, forCellReuseIdentifier: "OrderCell")
    }
    
    func getToken(){
        
        if (UserDefaults.standard.value(forKey: "UserToken")) != nil{
            let token =  UserDefaults.standard.value(forKey: "UserToken") as! String
            self.getOrders(U_token: token)
        }
            
        else {
            
            self.obj.alert(message:"You didn't placed any order yet." ,title: "My Orders" ,controller: self)
        }
    }
    
    func navBar(){
        
        self.navigationController?.navigationItem.title = "My Orders"
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    func getOrders(U_token:String){
        
        startAnimating(CGSize(width:60 ,height:60) , message: "Verifying User ..." , messageFont: UIFont.boldSystemFont(ofSize: 17) , type:.ballClipRotatePulse , color: UIColor.white
            , backgroundColor: UIColor.clear
        )
        self.LoaderView.isHidden=false
        
        myobj.MyOrders(token: U_token , Success: { (json) -> () in
            
            if json{
                
                if (UserDefaults.standard.value(forKey: "MyOrder")) != nil{
                    self.array =  UserDefaults.standard.value(forKey: "MyOrder") as! [[String:Dictionary<String, String>]] as [NSDictionary]
                    self.dataSource.value =  self.array as! [[String : Dictionary<String, String>]]
                    self.MyOrderTable.reloadData()
                    self.removeLoader()
                }
            }
        }
            , failure: { (message) -> () in
                
                self.obj.alert(message:message ,title: "Faliure" ,controller: self)
                self.removeLoader()
        }
            
            , Failure: { (error) -> () in
                
                self.obj.alert(message:error.description ,title: "Faliure" ,controller: self)
                self.removeLoader()
        })
    }
    
    func closeFriendsTapped(at index: Int) {
        let storyboard = UIStoryboard(name:"MyOrders", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "OrderDetail") as! OrderDetailVc
        destination.orderNum = index
        self.navigationController?.pushViewController(destination, animated: false)
    }
}

extension MyOrdersVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if CellHeightsArray.count > indexPath.row {
            return CellHeightsArray[indexPath.row]
        }
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.array.count == 0{
            return 0 }
        else {
            return 1 }
    }
    
    func numberOfSections(in MyOrderTable: UITableView) -> Int {
        return array.count
    }
}

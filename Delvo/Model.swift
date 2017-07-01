//
//  Model.swift
//  Delvo
//
//  Created by Apple on 08/03/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

struct Pick_Detail{
    
    static var PickLocation = String()
    static var PickAddress = String()
    static var PickName = String()
    static var PickContact = String()
    static var PickUpDetailAddress = String()
    static var PickUpTime = String()
    static var PickUpDate = String()
    static var PickUpDetail = String()
    static var PickUpAmount = String()
    static var timeCritical = Bool()
    init(){
       
        Pick_Detail.PickLocation = ""
        Pick_Detail.PickAddress = ""
        Pick_Detail.PickLocation = ""
        Pick_Detail.PickName = ""
        Pick_Detail.PickContact = ""
        Pick_Detail.PickUpTime = ""
        Pick_Detail.PickUpDate = ""
        Pick_Detail.PickUpDetail = ""
        Pick_Detail.PickUpAmount = ""
        Pick_Detail.timeCritical = false
    }

}

struct Drop_Detail{
    
    static var DropLocation = String()
    static var DropAddress = String()
    static var DropName = String()
    static var DropContact = String()
    static var DropDetailAddress = String()
    static var DropTime = String()
    static var DropDate = String()
    static var DropDetail = String()
    static var DropAmount = String()
    
    init(){
        
        Drop_Detail.DropLocation = ""
        Drop_Detail.DropAddress = ""
        Drop_Detail.DropName = ""
        Drop_Detail.DropContact = ""
        Drop_Detail.DropTime = ""
        Drop_Detail.DropDate = ""
        Drop_Detail.DropDetail = ""
        Drop_Detail.DropAmount = ""
    }
}

struct Location{
    
    static var PickLat = Double()
    static var PickLng = Double()
    static var DropLat = Double()
    static var DropLng = Double()
    
}

struct UserInfo{
    
    static var Name = String()
    static var Phone = String()
    static var Email = String()
    static var Password = String()
    static var auth_token = String()
    
}

struct MoveToVc{
    
    static var visitPD = false
    static var visitDL = false
    static var visitDD = false
    static var PD_visitDL = false
    static var PD_visitDD = false
    static var DL_visitDD = false
    
    init(){
        
        MoveToVc.visitPD = false
        MoveToVc.visitDL = false
        MoveToVc.visitDD = false
        MoveToVc.PD_visitDL = false
        MoveToVc.PD_visitDD = false
        MoveToVc.DL_visitDD = false
    }
    
}

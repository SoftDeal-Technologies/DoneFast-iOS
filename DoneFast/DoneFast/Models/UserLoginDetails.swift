//
//  UserLoginDetails.swift
//  DoneFast
//
//  Created by Ciber on 8/30/19.
//  Copyright © 2019 Ciber. All rights reserved.
//

import UIKit

//class UserLoginDetails: NSObject
//{
////  static let sharedUserLoginDetails = UserLoginDetails()
////
////  //Initializer access level change now
////  private override init()
////  {
////
////  }
//
//  var loginType:String?
//  var userID:String?
//  var userName:String?
//  var userEmail:String?
//  var userPermission:String?
//  var token:String?
//
//}



class UserLoginDetails
{
  static let shared = UserLoginDetails()
  
  //Initializer access level change now
  private init(){}
  
  var loginType:String?
  var userID:String?
  var userName:String?
  var userEmail:String?
  var userPermission:String?
  var token:String?
  var userProfileImage:String?
}

class ClearLoginDetails
{
    static let shared = ClearLoginDetails()
    
    //Initializer access level change now
    private init(){}
    
    func clearAllLoginData()
    {
        UserDefaults.standard.set("", forKey: "loginType")
        UserDefaults.standard.set("", forKey: "userEmail")
        UserDefaults.standard.set("", forKey: "userID")
        UserDefaults.standard.set("", forKey: "userName")
        UserDefaults.standard.set("", forKey: "userPermission")
        UserDefaults.standard.set("", forKey: "userProfileImage")
        UserDefaults.standard.set("", forKey: "token")
        UserDefaults.standard.synchronize()
    }
}

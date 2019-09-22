//
//  CustomerDetails.swift
//  DoneFast
//
//  Created by Ciber on 8/18/19.
//  Copyright © 2019 Ciber. All rights reserved.
//

import UIKit

class CustomerDetails: NSObject {
  
  var firstName:String?
  var lastName:String?
  var emailId:String?
  var state:String?
  var address:String?
  var city:String?
  var password:String?
  var confirmPassword:String?
  var phone:String?
  var zipCode:String?
  
  init(firstName:String,lastName:String,emailId:String,state:String,address:String,city:String,password:String,confirmPassword:String,phone:String,zipCode:String) {
    self.firstName = firstName
    self.lastName = lastName
    self.emailId = emailId
    self.state = state
    self.city = city
    self.password = password
    self.confirmPassword = confirmPassword
    self.phone = phone
    self.zipCode = zipCode
    self.address = address
  }

}

class CustomerBillingDetails: NSObject {
  var state:String?
  var address:String?
  var city:String?
  var zipCode:String?
  
  init(state:String,address:String,city:String,zipCode:String)
  {
    self.state = state
    self.city = city
    self.zipCode = zipCode
    self.address = address
  }
  
}

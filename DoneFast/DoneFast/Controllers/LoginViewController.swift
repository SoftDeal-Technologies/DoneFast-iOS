//
//  ViewController.swift
//  DoneFast
//
//  Created by Ciber on 8/9/19.
//  Copyright © 2019 Ciber. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class LoginViewController: UIViewController,WebServiceDelegate,UITextFieldDelegate {
  
  @IBOutlet weak var loginBtn: UIButton!
  @IBOutlet weak var userNameTxtField: UITextField!
  @IBOutlet weak var passwordTxtField: UITextField!
  var customerNavigationController:UINavigationController?
  
  var webServiceUrl = "http://rmisys.com/projects/globehome-app/ApiServices/Login"//ShareDataClass.shared.commonServiceUrl
  var Almgr = Alamofire.SessionManager()
  var userLoggedInDetails:UserLoginDetails? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    loginBtn.layer.cornerRadius = 5.0
  }

  @IBAction func loginClicked(_ sender: Any)
  {
   // self.performSegue(withIdentifier: "CustomerListVC", sender: self) //ToCustomerPropertyDetail
    
    guard let userName = userNameTxtField.text else { return }
    guard let password = passwordTxtField.text else { return }
    if userName.count > 0 && password.count > 0
    {
//      let loginParameters = ["userType": "Customer","userEmail": "sukruth@gmail.com","userPassword": "123456","deviceType": "Android","deviceToken": "APA91bFoi3lMMre9G3XzR1LrF4ZT82_15MsMdEICogXSLB8-MrdkRuRQFwNI5u8Dh0cI90ABD3BOKnxkEla8cGdisbDHl5cVIkZah5QUhSAxzx4Roa7b4xy9tvx9iNSYw-eXBYYd8k1XKf8Q_Qq1X9-x-U-Y79vdPq"]
      let loginParameters = ["userType": "Customer","userEmail": userName,"userPassword": password,"deviceType": "iOS","deviceToken": "APA91bFoi3lMMre9G3XzR1LrF4ZT82_15MsMdEICogXSLB8-MrdkRuRQFwNI5u8Dh0cI90ABD3BOKnxkEla8cGdisbDHl5cVIkZah5QUhSAxzx4Roa7b4xy9tvx9iNSYw-eXBYYd8k1XKf8Q_Qq1X9-x-U-Y79vdPq"]
      WebServices.sharedWebServices.delegate = self
      WebServices.sharedWebServices.uploadusingUrlSessionNormalData(webServiceParameters: loginParameters, methodType: .POST, webServiceType: .PCMS_LOGIN, token: "")
//      WebServices.sharedWebServices.uploadusingUrlSession(webServiceParameters: loginParameters, methodType: .POST, webServiceType: .PCMS_LOGIN )
    }
    else
    {
      let alertController:UIAlertController = UIAlertController(title: "", message: "Please enter Username & Password.", preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alertController, animated: true, completion: nil)
    }
    
  }
  
  func successResponse(responseString: String, webServiceType:WebServiceType)
  {
    
//    if let json = try? JSON(data: responseData)
//  do {
      if let jsonStr = try? JSON(parseJSON: responseString)
      {
        let  tempErrorCode = jsonStr["status"].stringValue
        
        if tempErrorCode == "1"
        {
          let userData = jsonStr["data"].dictionary
          let userDetails = userData!["user"]!.arrayValue
          let message = userData!["message"]!.stringValue
//          let tempUserDetails = UserLoginDetails()
          
          if userDetails.count > 0
          {
            let userId = userDetails[0]
            let userIdValue = userId["userID"].stringValue
            print(userIdValue)
            UserLoginDetails.shared.loginType = userId["loginType"].stringValue
            UserLoginDetails.shared.userEmail = userId["userEmail"].stringValue
            UserLoginDetails.shared.userID = userId["userID"].stringValue
            UserLoginDetails.shared.userName = userId["userName"].stringValue
            UserLoginDetails.shared.userPermission = userId["userPermission"].stringValue
            UserLoginDetails.shared.userProfileImage = userId["userProfileImage"].stringValue
          }
          if message == "You have successfully logged in."
          {
            UserLoginDetails.shared.token = userData!["token"]!.stringValue
//            self.userLoggedInDetails = tempUserDetails
            DispatchQueue.main.async {
//              self.performSegue(withIdentifier: "CustomerListVC", sender: self)
              let containerViewController = ContainerViewController()
//              self.customerNavigationController = UINavigationController(rootViewController: containerViewController)
              let appdelegate = UIApplication.shared.delegate as? AppDelegate
              appdelegate?.window?.rootViewController = containerViewController
            }
          }
        }
        else if tempErrorCode == "0"
        {
          
        }
      }
      
//    }
//    catch let error as NSError {
//      print("something wrong with the delete : \(error.userInfo)")
//    }

  }
  
  func failerResponse(responseData: Data, webServiceType: WebServiceType)
  {
    
  }
  
  @IBAction func newRegClicked(_ sender: Any)
  {
    self.performSegue(withIdentifier: "ToGoogleMapView", sender: self) //ToSelectOption
  }
  
  @IBAction func forgotPasswordClicked(_ sender: Any)
  {
//    self.performSegue(withIdentifier: "ToCustomerPropertyDetail", sender: self) //ToCustomerPropertyDetail ToCustomerAddProperty
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key
  {
    textField.resignFirstResponder()
    return true
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if segue.identifier == "CustomerListVC"
    {
      let customerPropertyListVC = segue.destination as? CustomerPropertyListVC
      customerPropertyListVC?.customerLoginDetails = self.userLoggedInDetails
    }
  }
}


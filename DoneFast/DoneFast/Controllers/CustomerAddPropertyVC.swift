//
//  CustomerAddPropertyVC.swift
//  DoneFast
//
//  Created by Ciber on 8/20/19.
//  Copyright © 2019 Ciber. All rights reserved.
//

import UIKit
import SwiftyJSON

class CustomerAddPropertyVC: UIViewController,UITextFieldDelegate {

  var customerLoginDetails:UserLoginDetails? = nil
  var requestListArray:[[String:Any]] = []
  var selectedProperty = ""
  var selectedPropertyDesign:Int?
  
  @IBOutlet weak var singlePropBtn: UIButton!
  @IBOutlet weak var multiPropBtn: UIButton!
  @IBOutlet weak var commercialPropBtn: UIButton!
  @IBOutlet weak var propertyDesignTextField: UITextField!
  @IBOutlet weak var propertyEmailIdTextField: UITextField!
  @IBOutlet weak var propertyPhoneNumberTextField: UITextField!
  @IBOutlet weak var propertyAddressTextField: UITextField!
  @IBOutlet weak var propertyCityTextField: UITextField!
  @IBOutlet weak var propertyStateTextField: UITextField!
  @IBOutlet weak var propertyZipCodeTextField: UITextField!
  @IBOutlet weak var bgScrollView: UIScrollView!

  override func viewDidLoad()
  {
      super.viewDidLoad()
  }
  
  @IBAction func propertyTypeClicked(_ sender: Any)
  {
    let propertyTypeBtn = sender as? UIButton
    switch propertyTypeBtn?.tag
    {
      case 1:
        selectedProperty = "Single"
        singlePropBtn.backgroundColor = UIColor.blue
        multiPropBtn.backgroundColor = UIColor.clear
        commercialPropBtn.backgroundColor = UIColor.clear
      case 2:
        selectedProperty = "Multi"
        singlePropBtn.backgroundColor = UIColor.clear
        multiPropBtn.backgroundColor = UIColor.blue
        commercialPropBtn.backgroundColor = UIColor.clear
      case 3:
        selectedProperty = "Commercial"
        singlePropBtn.backgroundColor = UIColor.clear
        multiPropBtn.backgroundColor = UIColor.clear
        commercialPropBtn.backgroundColor = UIColor.blue
      default:
        print("nothing")
    }
    
    let loginParameters = ["propertyType": selectedProperty]
    guard let tokenStr = UserLoginDetails.shared.token else { return }
    WebServices.sharedWebServices.delegate = self
    WebServices.sharedWebServices.uploadusingUrlSessionNormalData(webServiceParameters: loginParameters, methodType: .POST, webServiceType: .PROPERTY_TYPE, token: tokenStr)
  }
  
  @IBAction func backClicked(_ sender: Any)
  {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func submitClicked(_ sender: Any)
  {
    guard let userId =  UserLoginDetails.shared.userID else { return }
    if let propertyDesign = propertyDesignTextField.text, let propertyEmailId = propertyEmailIdTextField.text,let propertyPhoneNumber = propertyPhoneNumberTextField.text,let propertyAddress = propertyAddressTextField.text,let propertyCity = propertyCityTextField.text,let propertyState = propertyStateTextField.text,let propertyZipCode = propertyZipCodeTextField.text
    {
      if (propertyDesign.count > 0 && propertyEmailId.count > 0 && propertyPhoneNumber.count > 0 && propertyAddress.count > 0 && propertyCity.count > 0 && propertyState.count > 0 && propertyZipCode.count > 0)
      {
        let parameters = ["userID":userId,"propertyType":selectedProperty,"propertyDesign":propertyDesign,"propertyEmailId":propertyEmailId, "propertyPhoneNumber":propertyPhoneNumber,"propertyAddress":propertyAddress,"propertyCity":propertyCity,"propertyState":propertyState, "propertyZipCode":propertyZipCode,"propertyLocation":"44.968046,-94.420307"]
        guard let tokenStr = UserLoginDetails.shared.token else { return }
        WebServices.sharedWebServices.delegate = self
        WebServices.sharedWebServices.uploadusingUrlSessionNormalData(webServiceParameters: parameters, methodType: .POST, webServiceType: .ADD_CUSTOMER_PROPERTY, token: tokenStr)
      }
      else
      {
        let alertController:UIAlertController = UIAlertController(title: "", message: "Please enter all fields.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
      }
    }
  }
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
  {
    if textField == propertyDesignTextField
    {
      self.openPropertyDesignPopOver(sender: propertyDesignTextField)
      return false
    }
    
    return true
  }
  
  func openPropertyDesignPopOver(sender:UITextField)
  {
    // get a reference to the view controller for the popover
    let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubCategoryServiceVC") as? SubCategoryServiceVC
    // set the presentation style
    popController!.modalPresentationStyle = UIModalPresentationStyle.popover
    popController?.popOverType = .PropertyDesign
    popController?.serviceListArray = self.requestListArray as [AnyObject]
    // set up the popover presentation controller
    popController?.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
    popController?.popoverPresentationController?.delegate = self
    popController?.delegate = self
    popController?.popoverPresentationController?.sourceView = (sender as UIView) // button
    popController?.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
    // present the popover
    self.present(popController!, animated: true, completion: nil)
  }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
  func navigateToListCustomerProperty()
  {
    let controllerArray = self.navigationController?.viewControllers
    if controllerArray!.count > 0
    {
      for controller in controllerArray!
      {
        if (controller.isKind(of: CustomerPropertyListVC.self))
        {
          self.navigationController?.popToViewController(controller, animated: true)
          break
        }
      }
    }
  }

}

extension CustomerAddPropertyVC:WebServiceDelegate
{
  func successResponse(responseString: String, webServiceType: WebServiceType)
  {
    if  webServiceType == .PROPERTY_TYPE
    {
      if let jsonStr = try? JSON(parseJSON: responseString)
      {
        let  tempErrorCode = jsonStr["status"].stringValue
        
        if tempErrorCode == "1"
        {
          let propertyData = jsonStr["data"].dictionary
          let propertyList = propertyData!["requestList"]!.arrayValue
          if propertyList.count > 0
          {
            for tempDict in propertyList
            {
              var newDict = [String: Any]()
              newDict["name"] = tempDict["name"].stringValue
              newDict["id"] = tempDict["id"].stringValue
              self.requestListArray.append(newDict)
            }
          }
//          for tempReqdict in self.requestListArray
//          {
//            print(tempReqdict)
//            if let id = tempReqdict["id"], let name = tempReqdict["name"]
//            {
//              print(id)
//              print(name)
//            }
//          }
        }
      }
    }
    else if webServiceType == .ADD_CUSTOMER_PROPERTY
    {
      if let jsonStr = try? JSON(parseJSON: responseString)
      {
//        let  tempErrorCode = jsonStr["status"].stringValue
        let propertyData = jsonStr["data"].dictionary
        let message = propertyData!["message"]!.string
        //if tempErrorCode == "1"
        if message == "Property Added Successfully"
        {
          let alertController:UIAlertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
          //            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: ))
          alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
//            self.navigateToListCustomerProperty()
            DispatchQueue.main.async {
              self.navigationController?.popViewController(animated: true)
            }
          }))
          DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
          }
        }
      }
    }
  }
  
  func failerResponse(responseData: Data, webServiceType: WebServiceType)
  {
    
  }
}

extension CustomerAddPropertyVC:UIPopoverPresentationControllerDelegate
{
  func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
    // return UIModalPresentationStyle.FullScreen
    return UIModalPresentationStyle.none
  }
}

extension CustomerAddPropertyVC:ServiceSubCategoryDelegate
{
  func selectedSubCategory(selectedSubCategory: AnyObject)
  {
    selectedPropertyDesign = selectedSubCategory as? Int
    let tempDesign = self.requestListArray[selectedPropertyDesign!]
    self.propertyDesignTextField.text = (tempDesign["name"] as! String)
  }
}

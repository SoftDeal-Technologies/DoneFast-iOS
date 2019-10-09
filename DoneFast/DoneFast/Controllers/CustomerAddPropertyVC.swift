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
  var activityIndicator:UIActivityIndicatorView?
    var customerAddProperty:CustomerAddProperty?
    
  
  @IBOutlet weak var singlePropBtn: UIButton!
  @IBOutlet weak var multiPropBtn: UIButton!
  @IBOutlet weak var commercialPropBtn: UIButton!
  @IBOutlet weak var propertyDesignTextField: UITextField!
  @IBOutlet weak var propertyTypeTextField: UITextField!
  @IBOutlet weak var propertyEmailIdTextField: UITextField!
  @IBOutlet weak var propertyPhoneNumberTextField: UITextField!
  @IBOutlet weak var propertyAddressTextField: UITextField!
  @IBOutlet weak var propertyCityTextField: UITextField!
  @IBOutlet weak var propertyStateTextField: UITextField!
  @IBOutlet weak var propertyZipCodeTextField: UITextField!
  @IBOutlet weak var bgScrollView: UIScrollView!
  var popOverType:PopOverType!
  

  override func viewDidLoad()
  {
      super.viewDidLoad()
    activityIndicator = UIActivityIndicatorView(frame: CGRect(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2, width: 37, height: 37))
    activityIndicator?.style = .whiteLarge
    activityIndicator?.hidesWhenStopped = true
    activityIndicator?.isHidden = true
    self.view.addSubview(activityIndicator!)
  }
  
  @IBAction func propertyTypeClicked(_ sender: Any)
  {
    self.propertyTypePopOverClicked(sender: propertyTypeTextField)
  }
  
  @IBAction func backClicked(_ sender: Any)
  {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func propertyDesignClicked(_ sender: Any)
  {
    self.openPropertyDesignPopOver(sender: propertyDesignTextField)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  @IBAction func submitClicked(_ sender: Any)
  {
//    self.performSegue(withIdentifier: "ToGoogleMapView", sender: self)
//    guard let userId =  UserLoginDetails.shared.userID else { return }
    if let propertyDesign = propertyDesignTextField.text, let propertyEmailId = propertyEmailIdTextField.text,let propertyPhoneNumber = propertyPhoneNumberTextField.text,let propertyAddress = propertyAddressTextField.text,let propertyCity = propertyCityTextField.text,let propertyState = propertyStateTextField.text,let propertyZipCode = propertyZipCodeTextField.text
    {
      if (propertyDesign.count > 0 && propertyEmailId.count > 0 && propertyPhoneNumber.count > 0 && propertyAddress.count > 0 && propertyCity.count > 0 && propertyState.count > 0 && propertyZipCode.count > 0)
      {
        customerAddProperty = CustomerAddProperty()
        customerAddProperty?.propertyDesign = propertyDesign
        customerAddProperty?.propertyEmailId = propertyEmailId
        customerAddProperty?.propertyPhoneNumber = propertyPhoneNumber
        customerAddProperty?.propertyAddress = propertyAddress
        customerAddProperty?.propertyCity = propertyCity
        customerAddProperty?.propertyState = propertyState
        customerAddProperty?.propertyZipCode = propertyZipCode
        customerAddProperty?.selectedProperty = selectedProperty
        
        self.performSegue(withIdentifier: "ToGoogleMapView", sender: self)
        
//        let parameters = ["userID":userId,"propertyType":selectedProperty,"propertyDesign":propertyDesign,"propertyEmailId":propertyEmailId, "propertyPhoneNumber":propertyPhoneNumber,"propertyAddress":propertyAddress,"propertyCity":propertyCity,"propertyState":propertyState, "propertyZipCode":propertyZipCode,"propertyLocation":"44.968046,-94.420307"]
//        guard let tokenStr = UserLoginDetails.shared.token else { return }
//        self.view.isUserInteractionEnabled = false
//        activityIndicator?.isHidden = false
//        activityIndicator?.startAnimating()
//        WebServices.sharedWebServices.delegate = self
//        WebServices.sharedWebServices.uploadusingUrlSessionNormalData(webServiceParameters: parameters, methodType: .POST, webServiceType: .ADD_CUSTOMER_PROPERTY, token: tokenStr)
        
      }
      else
      {
        let alertController:UIAlertController = UIAlertController(title: "", message: "Please enter all fields.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
      }
    }
  }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let googleMapVC = segue.destination as? GoogleMapVC
        googleMapVC?.customerAddProperty = self.customerAddProperty
    }
    
  func propertTypeSelect(selectedPropertyType:Int)
  {
    let tempPropertyType = selectedPropertyType + 1
    
    switch tempPropertyType
    {
    case 1:
      selectedProperty = "Single"
//      singlePropBtn.backgroundColor = UIColor.blue
//      multiPropBtn.backgroundColor = UIColor.clear
//      commercialPropBtn.backgroundColor = UIColor.clear
    case 2:
      selectedProperty = "Multi"
//      singlePropBtn.backgroundColor = UIColor.clear
//      multiPropBtn.backgroundColor = UIColor.blue
//      commercialPropBtn.backgroundColor = UIColor.clear
    case 3:
      selectedProperty = "Commercial"
//      singlePropBtn.backgroundColor = UIColor.clear
//      multiPropBtn.backgroundColor = UIColor.clear
//      commercialPropBtn.backgroundColor = UIColor.blue
    default:
      print("nothing")
    }
    propertyTypeTextField.text = selectedProperty
    let loginParameters = ["propertyType": selectedProperty]
    guard let tokenStr = UserLoginDetails.shared.token else { return }
    self.view.isUserInteractionEnabled = false
    activityIndicator?.isHidden = false
    activityIndicator?.startAnimating()
    WebServices.sharedWebServices.delegate = self
    WebServices.sharedWebServices.uploadusingUrlSessionNormalData(webServiceParameters: loginParameters, methodType: .POST, webServiceType: .PROPERTY_TYPE, token: tokenStr)
  }
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
  {
    if textField == propertyDesignTextField
    {
      self.openPropertyDesignPopOver(sender: propertyDesignTextField)
      return false
    }
    else if textField == propertyTypeTextField
    {
      self.propertyTypePopOverClicked(sender: propertyTypeTextField)
      return false
    }
    
    return true
  }
  
  
  func propertyTypePopOverClicked(sender:UITextField)
  {
    // get a reference to the view controller for the popover
    let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubCategoryServiceVC") as? SubCategoryServiceVC
    // set the presentation style
    popController!.modalPresentationStyle = UIModalPresentationStyle.popover
    popController?.popOverType = .PropertyType
    self.popOverType = .PropertyType
    popController?.serviceListArray = ["Single","Multi","Commercial"] as [AnyObject]
    // set up the popover presentation controller
    popController?.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
    popController?.popoverPresentationController?.delegate = self
    popController?.delegate = self
    popController?.popoverPresentationController?.sourceView = (sender as UIView) // button
    popController?.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
    // present the popover
    self.present(popController!, animated: true, completion: nil)
  }
  
  func openPropertyDesignPopOver(sender:UITextField)
  {
    // get a reference to the view controller for the popover
    if self.requestListArray.count > 0
    {
      let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubCategoryServiceVC") as? SubCategoryServiceVC
      // set the presentation style
      popController!.modalPresentationStyle = UIModalPresentationStyle.popover
      popController?.popOverType = .PropertyDesign
      self.popOverType = .PropertyDesign
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
    else
    {
      let alertController:UIAlertController = UIAlertController(title: "", message: "Please first select Property Type", preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alertController, animated: true, completion: nil)
    }
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
    DispatchQueue.main.async {
      self.view.isUserInteractionEnabled = true
      self.activityIndicator?.stopAnimating()
      self.activityIndicator?.isHidden = true
    }
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
    DispatchQueue.main.async {
      self.view.isUserInteractionEnabled = true
      self.activityIndicator?.stopAnimating()
      self.activityIndicator?.isHidden = true
    }  }
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
    if self.popOverType ==  PopOverType.PropertyDesign
    {
      selectedPropertyDesign = selectedSubCategory as? Int
      let tempDesign = self.requestListArray[selectedPropertyDesign!]
      self.propertyDesignTextField.text = (tempDesign["name"] as! String)
    }
    else if self.popOverType == PopOverType.PropertyType
    {
      self.propertTypeSelect(selectedPropertyType: (selectedSubCategory as? Int)!)
    }
  }
}

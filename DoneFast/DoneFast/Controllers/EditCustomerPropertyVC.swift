//
//  EditCustomerPropertyVC.swift
//  DoneFast
//
//  Created by Ciber on 9/14/19.
//  Copyright © 2019 Ciber. All rights reserved.
//

import UIKit
import SwiftyJSON

class EditCustomerPropertyVC: UIViewController,UITextFieldDelegate
{
  var customerLoginDetails:UserLoginDetails? = nil
  var propertyList:PropertyList? = nil
  @IBOutlet weak var nameTxtField: UITextField!
  @IBOutlet weak var propertyDesBtn: UIButton!
  @IBOutlet weak var propertyTypeBtn: UIButton!
  @IBOutlet weak var emailTxtField: UITextField!
  @IBOutlet weak var phoneNoTxtField: UITextField!
  var selectedPropertyDesign:Int?
  var requestListArray:[[String:Any]] = []
  var activityIndicator:UIActivityIndicatorView?
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    activityIndicator = UIActivityIndicatorView(frame: CGRect(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2, width: 37, height: 37))
    activityIndicator?.style = .whiteLarge
    activityIndicator?.hidesWhenStopped = true
    activityIndicator?.isHidden = true
    self.view.addSubview(activityIndicator!)
        // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    nameTxtField.text = propertyList?.propertyCustomerName
    emailTxtField.text = propertyList?.propertyEmailId
    phoneNoTxtField.text = propertyList?.propertyPhoneNumber
    propertyDesBtn.setTitle(propertyList?.propertyTitle, for: .normal)
    
    guard let propertyType = propertyList?.propertyType else { return }
    propertyTypeBtn.setTitle(propertyType, for: .normal)
    
    let loginParameters = ["propertyType": propertyType]
    guard let tokenStr = UserLoginDetails.shared.token else { return }
    WebServices.sharedWebServices.delegate = self
    self.view.isUserInteractionEnabled = false
    activityIndicator?.isHidden = false
    activityIndicator?.startAnimating()
    WebServices.sharedWebServices.uploadusingUrlSessionNormalData(webServiceParameters: loginParameters as [String : Any], methodType: .POST, webServiceType: .PROPERTY_TYPE, token: tokenStr)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  @IBAction func propertyDesClicked(_ sender: Any)
  {
    let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubCategoryServiceVC") as? SubCategoryServiceVC
    // set the presentation style
    popController!.modalPresentationStyle = UIModalPresentationStyle.popover
    popController?.popOverType = .PropertyDesign
    popController?.serviceListArray = self.requestListArray as [AnyObject]
    // set up the popover presentation controller
    popController?.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
    popController?.popoverPresentationController?.delegate = self
    popController?.delegate = self
    popController?.popoverPresentationController?.sourceView = (sender as! UIView) // button
    popController?.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
    // present the popover
    self.present(popController!, animated: true, completion: nil)
  }
  
  @IBAction func backClicked(_ sender: Any)
  {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func updateClicked(_ sender: Any)
  {
    if let propertyName = nameTxtField.text, let emailId = emailTxtField.text, let phoneNo = phoneNoTxtField.text
    {
      if propertyName.count > 0 && emailId.count > 0 && phoneNo.count > 0
      {
        if let propertyId = propertyList?.propertyID, let propertyDesign = propertyDesBtn.titleLabel?.text
        {
          let parameters = ["propertyID":propertyId,"propertyDesign":propertyDesign,"propertyEmailId":emailId, "propertyPhoneNumber":phoneNo,"propertyCustomerName":propertyName]
            guard let tokenStr = UserLoginDetails.shared.token else { return }
            WebServices.sharedWebServices.delegate = self
            self.view.isUserInteractionEnabled = false
            WebServices.sharedWebServices.uploadusingUrlSessionNormalData(webServiceParameters: parameters as [String : Any], methodType: .POST, webServiceType: .EDIT_CUSTOMER_PROPERTY, token: tokenStr)
        }
      }
      else
      {
        
      }
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
}

extension EditCustomerPropertyVC:WebServiceDelegate
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
        }
      }
    }
    else if webServiceType == .EDIT_CUSTOMER_PROPERTY
    {
      if let jsonStr = try? JSON(parseJSON: responseString)
      {
        //        let  tempErrorCode = jsonStr["status"].stringValue
        let jsonData = jsonStr["data"].dictionary
        let message = jsonData!["message"]!.string
        //if tempErrorCode == "1"
        if message == "Property Updated Successfully"
        {
          DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
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
    }
  }
}

extension EditCustomerPropertyVC:UIPopoverPresentationControllerDelegate
{
  func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
    // return UIModalPresentationStyle.FullScreen
    return UIModalPresentationStyle.none
  }
}

extension EditCustomerPropertyVC:ServiceSubCategoryDelegate
{
  func selectedSubCategory(selectedSubCategory: AnyObject)
  {
    selectedPropertyDesign = selectedSubCategory as? Int
    let tempDesign = self.requestListArray[selectedPropertyDesign!]
//    self.propertyDesBtn.text = (tempDesign["name"] as! String)
    self.propertyDesBtn.setTitle((tempDesign["name"] as! String), for: .normal)
  }
}

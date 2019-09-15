//
//  EditCustomerPropertyVC.swift
//  DoneFast
//
//  Created by Ciber on 9/14/19.
//  Copyright © 2019 Ciber. All rights reserved.
//

import UIKit
import SwiftyJSON

class EditCustomerPropertyVC: UIViewController
{
  var customerLoginDetails:UserLoginDetails? = nil
  var propertyList:PropertyList? = nil
  @IBOutlet weak var nameTxtField: UITextField!
  @IBOutlet weak var propertyDesBtn: UIButton!
  @IBOutlet weak var propertyTypeBtn: UIButton!
  @IBOutlet weak var emailTxtField: UITextField!
  @IBOutlet weak var phoneNoTxtField: UITextField!
  
  override func viewDidLoad()
  {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    nameTxtField.text = propertyList?.propertyCustomerName
    emailTxtField.text = propertyList?.propertyEmailId
    phoneNoTxtField.text = propertyList?.propertyPhoneNumber
    propertyDesBtn.setTitle(propertyList?.propertyTitle, for: .normal)
    propertyTypeBtn.setTitle(propertyList?.propertyType, for: .normal)
  }
  
  @IBAction func propertyDesClicked(_ sender: Any)
  {
    
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
        if let propertyId = propertyList?.propertyID, let propertyDesign = propertyList?.propertyTitle
        {
          let parameters = ["propertyID":propertyId,"propertyDesign":propertyDesign,"propertyEmailId":emailId, "propertyPhoneNumber":phoneNo,"propertyCustomerName":propertyName]
            guard let tokenStr = UserLoginDetails.shared.token else { return }
            WebServices.sharedWebServices.delegate = self
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
  
  func failerResponse(responseData: Data, webServiceType: WebServiceType)
  {
    
  }
}

//
//  EditCustomerProfileVC.swift
//  DoneFast
//
//  Created by Ciber on 8/25/19.
//  Copyright © 2019 Ciber. All rights reserved.
//

import UIKit

class EditUserProfileVC: UIViewController {

  var loggedInUserDetails:LoggedInUserDetails?
  var customerLoginDetails:UserLoginDetails? = nil
  @IBOutlet weak var custIdValueLabel: UILabel!
  @IBOutlet weak var custTypeValueLabel: UILabel!
  @IBOutlet weak var cardCVVTxtField: UITextField!
  @IBOutlet weak var cardExpTxtField: UITextField!
  @IBOutlet weak var cardHolderNameTxtField: UITextField!
  @IBOutlet weak var cardNumberTxtField: UITextField!
  @IBOutlet weak var cardTypeLabel: UILabel!
  @IBOutlet weak var billingStateTxtField: UITextField!
  @IBOutlet weak var billingCityTxtField: UITextField!
  @IBOutlet weak var billingAddressTxtField: UITextField!
  @IBOutlet weak var zipCodeBillingTxtField: UITextField!
  @IBOutlet weak var zipCodeTxtField: UITextField!
  @IBOutlet weak var stateTxtField: UITextField!
  @IBOutlet weak var cityTxtField: UITextField!
  @IBOutlet weak var addressTxtField: UITextField!
  @IBOutlet weak var phoneNoTxtField: UITextField!
  @IBOutlet weak var emailIdBottomLabel: UITextField!
  @IBOutlet weak var lastNameTxtField: UITextField!
  @IBOutlet weak var emailIdLabel: UILabel!
  @IBOutlet weak var firstNameTxtField: UITextField!
  @IBOutlet weak var custProfilePicImageView: UIImageView!
  
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
  
  override func viewWillAppear(_ animated: Bool)
  {
    super.viewWillAppear(animated)
    self.populateData()
  }
  @IBAction func saveClicked(_ sender: Any)
  {
    self.callWebService()
  }
  @IBAction func backClicked(_ sender: Any)
  {
    self.navigationController?.popViewController(animated: true)
  }
  func populateData()
  {
    custIdValueLabel.text = loggedInUserDetails?.userID
    custTypeValueLabel.text = "Customer"
    cardCVVTxtField.text = loggedInUserDetails?.customerCardCvv
    cardExpTxtField.text = loggedInUserDetails?.customerCardExp
     cardHolderNameTxtField.text = loggedInUserDetails?.customerCardName
     cardNumberTxtField.text = loggedInUserDetails?.customerCardNumber
//     cardTypeLabel.text = loggedInUserDetails?.customerCardType
     billingStateTxtField.text = loggedInUserDetails?.customerBillState
     billingCityTxtField.text = loggedInUserDetails?.customerBillCity
     billingAddressTxtField.text = loggedInUserDetails?.customerBillAddress
     zipCodeBillingTxtField.text = loggedInUserDetails?.customerBillZip
     zipCodeTxtField.text = loggedInUserDetails?.customerZip
     stateTxtField.text = loggedInUserDetails?.customerState
     cityTxtField.text = loggedInUserDetails?.customerCity
     addressTxtField.text = loggedInUserDetails?.customerAddress
     phoneNoTxtField.text = loggedInUserDetails?.customerPhoneNumber
//     emailIdBottomLabel.text = loggedInUserDetails?.customerEmail
     lastNameTxtField.text = loggedInUserDetails?.customerLastName
     emailIdLabel.text = loggedInUserDetails?.customerEmail
     firstNameTxtField.text = loggedInUserDetails?.customerFirstName
//     custProfilePicImageView: UIImageView!
    if let customerPhoto = loggedInUserDetails?.customerPhoto {
      custProfilePicImageView.downloaded(from: URL(string: customerPhoto)!)
      custProfilePicImageView.layer.cornerRadius = (custProfilePicImageView.frame.size.width/2)
    }
    
  }
  
  func callWebService()
  {
    guard let userId = UserLoginDetails.shared.userID else { return }
    guard let tokenStr = UserLoginDetails.shared.token else { return }
    WebServices.sharedWebServices.delegate = self
    if let firstName = firstNameTxtField.text,let lastName = lastNameTxtField.text,let phoneNumber = phoneNoTxtField.text,let address = addressTxtField.text,let city = cityTxtField.text,let state = stateTxtField.text,let zipCode = zipCodeTxtField.text,let billingAddress = billingAddressTxtField.text,let billingCity = billingCityTxtField.text,let billingState = billingStateTxtField.text,let billingZipCode = zipCodeBillingTxtField.text,let creditCardType = cardTypeLabel.text,let creditCardNumber = cardNumberTxtField.text,let creditCardExp = cardExpTxtField.text,let creditCardCVV = cardCVVTxtField.text
    {
      let parameters = ["userID": userId,"firstName":firstName,"lastName":lastName,"phoneNumber":phoneNumber,"address":address,"city":city,"state":state,"zipCode":zipCode,"billingAddress":billingAddress,"billingCity":billingCity,"billingState":billingState,"billingZipCode":billingZipCode,"creditCardType":creditCardType,  "creditCardNumber":creditCardNumber,"creditCardName":creditCardType,"creditCardExp":creditCardExp,"creditCardCVV":creditCardCVV]
      let imageStringArray = ["customerPhoto"]
      let imageDataArray = [custProfilePicImageView.image]
      WebServices.sharedWebServices.uploadusingUrlSessionNormalDataWithImage(webServiceParameters: parameters, methodType: .POST, webServiceType: .CUSTOMER_UPDATE_PROFILE, token: tokenStr, imagesString: imageStringArray, imageDataArray: imageDataArray as! [UIImage])
      //(webServiceParameters: parameters, methodType: .POST, webServiceType: .CUSTOMER_UPDATE_PROFILE, token: tokenStr)
    }
    
  }
}

extension EditUserProfileVC:WebServiceDelegate
{
  func successResponse(responseString: String, webServiceType: WebServiceType)
  {
    
  }
  
  func failerResponse(responseData: Data, webServiceType: WebServiceType)
  {
    
  }
}

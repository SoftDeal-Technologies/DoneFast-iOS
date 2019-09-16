//
//  UserProfileVC.swift
//  DoneFast
//
//  Created by Ciber on 8/23/19.
//  Copyright © 2019 Ciber. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserProfileVC: UIViewController
{
  var customerLoginDetails:UserLoginDetails? = nil

  @IBOutlet weak var cardCVVLabel: UILabel!
  @IBOutlet weak var cardExpLabel: UILabel!
  @IBOutlet weak var cardHolderName: UILabel!
  @IBOutlet weak var cardNumberLabel: UILabel!
  @IBOutlet weak var cardTypeLabel: UILabel!
  @IBOutlet weak var billingStateLabel: UILabel!
  @IBOutlet weak var billingCityLabel: UILabel!
  @IBOutlet weak var billingAddressLabel: UILabel!
  @IBOutlet weak var zipCodeBillingLabel: UILabel!
  @IBOutlet weak var zipCodeLabel: UILabel!
  @IBOutlet weak var stateLabel: UILabel!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var phoneNoLabel: UILabel!
  @IBOutlet weak var emailIdBottomLabel: UILabel!
  @IBOutlet weak var lastNameLabel: UILabel!
  @IBOutlet weak var emailIdLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var custIdValueLabel: UILabel!
  @IBOutlet weak var custTypeValueLabel: UILabel!
  @IBOutlet weak var firstNameLabel: UILabel!
  @IBOutlet weak var custProfilePicImageView: UIImageView!
  var userLoggedInArray:[LoggedInUserDetails] = []
  
  override func viewDidLoad()
  {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool)
  {
    super.viewWillAppear(animated)
    self.callWebService()
  }
    
  @IBAction func backClicked(_ sender: Any)
  {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func editClicked(_ sender: Any)
  {
    self.performSegue(withIdentifier: "ToEditUserProfile", sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    let editUserProfileController = segue.destination as? EditUserProfileVC
    editUserProfileController?.loggedInUserDetails = self.userLoggedInArray[0]
    editUserProfileController?.customerLoginDetails = self.customerLoginDetails
  }
  
  func displayUserDetails()
  {
    let loggedInUser = self.userLoggedInArray[0]
    cardCVVLabel.text = loggedInUser.customerCardCvv
    cardExpLabel.text = loggedInUser.customerCardExp
    cardHolderName.text = loggedInUser.customerCardName
     cardNumberLabel.text = loggedInUser.customerCardNumber
     cardTypeLabel.text = loggedInUser.customerCardType
     billingStateLabel.text = loggedInUser.customerBillState
     billingCityLabel.text = loggedInUser.customerBillCity
     billingAddressLabel.text = loggedInUser.customerBillAddress
    zipCodeBillingLabel.text = loggedInUser.customerBillZip
     zipCodeLabel.text = loggedInUser.customerZip
     stateLabel.text = loggedInUser.customerState
     cityLabel.text = loggedInUser.customerCity
     addressLabel.text = loggedInUser.customerAddress
    phoneNoLabel.text = loggedInUser.customerPhoneNumber
    emailIdBottomLabel.text = loggedInUser.customerEmail
    lastNameLabel.text = loggedInUser.customerLastName
    emailIdLabel.text = loggedInUser.customerEmail
    nameLabel.text = loggedInUser.customerFirstName
    custIdValueLabel.text = loggedInUser.userID
//    custTypeValueLabel.text = loggedInUser.customerCardType
    firstNameLabel.text = loggedInUser.customerFirstName
    custProfilePicImageView.downloaded(from: URL(string: loggedInUser.customerPhoto!)!)
    custProfilePicImageView.layer.cornerRadius = (custProfilePicImageView.frame.size.width/2)
  }
  func callWebService()
  {
    guard let userId = UserLoginDetails.shared.userID else { return }
    guard let tokenStr = UserLoginDetails.shared.token else { return }
    WebServices.sharedWebServices.delegate = self
    let parameters = ["userID": userId]
    WebServices.sharedWebServices.uploadusingUrlSessionNormalData(webServiceParameters: parameters, methodType: .POST, webServiceType: .CUSTOMER_PROFILE, token: tokenStr)
  }
}

extension UserProfileVC:WebServiceDelegate
{
  func successResponse(responseString: String, webServiceType: WebServiceType)
  {
    if let jsonStr = try? JSON(parseJSON: responseString)
    {
      //        let  tempErrorCode = jsonStr["status"].stringValue
      let jsonData = jsonStr["data"].dictionary
      let message = jsonData!["message"]!.string
      //if tempErrorCode == "1"
      if message == "Success"
      {
        if let customerArray = jsonData!["customer"]?.arrayValue
        {
          if customerArray.count > 0
          {
            let loggedInUserDetails = LoggedInUserDetails()
            let userData = customerArray[0]
            loggedInUserDetails.userID = userData["userID"].stringValue
            loggedInUserDetails.customerFirstName = userData["customerFirstName"].stringValue
            loggedInUserDetails.customerLastName = userData["customerLastName"].stringValue
            loggedInUserDetails.customerEmail = userData["customerEmail"].stringValue
            loggedInUserDetails.customerPhoneNumber = userData["customerPhoneNumber"].stringValue
            loggedInUserDetails.customerAddress = userData["customerAddress"].stringValue
            loggedInUserDetails.customerCity = userData["customerCity"].stringValue
            loggedInUserDetails.customerState = userData["customerState"].stringValue
            loggedInUserDetails.customerZip = userData["customerZip"].stringValue
            loggedInUserDetails.customerBillAddress = userData["customerBillAddress"].stringValue
            loggedInUserDetails.customerBillCity = userData["customerBillCity"].stringValue
            loggedInUserDetails.customerBillState = userData["customerBillState"].stringValue
            loggedInUserDetails.customerBillZip = userData["customerBillZip"].stringValue
            loggedInUserDetails.customerCardType = userData["customerCardType"].stringValue
            loggedInUserDetails.customerCardName = userData["customerCardName"].stringValue
            loggedInUserDetails.customerCardNumber = userData["customerCardNumber"].stringValue
            loggedInUserDetails.customerCardExp = userData["customerCardExp"].stringValue
            loggedInUserDetails.customerCardCvv = userData["customerCardCvv"].stringValue
            loggedInUserDetails.customerPhoto = userData["customerPhoto"].stringValue
            self.userLoggedInArray.append(loggedInUserDetails)
          }
          DispatchQueue.main.async {
            self.displayUserDetails()
          }
        }
      }
    }
  }
  
  func failerResponse(responseData: Data, webServiceType: WebServiceType)
  {
    
  }
  
  
}

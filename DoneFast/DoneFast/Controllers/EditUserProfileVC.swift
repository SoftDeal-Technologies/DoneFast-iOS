//
//  EditCustomerProfileVC.swift
//  DoneFast
//
//  Created by Ciber on 8/25/19.
//  Copyright © 2019 Ciber. All rights reserved.
//

import UIKit
import SwiftyJSON

class EditUserProfileVC: UIViewController,UITextFieldDelegate {

  var activityIndicator:UIActivityIndicatorView?
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
  @IBOutlet weak var custProfilePicBtn: UIButton!
  var imagePickerController = UIImagePickerController()

  override func viewDidLoad()
  {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    activityIndicator = UIActivityIndicatorView(frame: CGRect(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2, width: 37, height: 37))
    activityIndicator?.style = .whiteLarge
    activityIndicator?.hidesWhenStopped = true
    activityIndicator?.isHidden = true
    self.view.addSubview(activityIndicator!)
  }
  
  override func viewWillAppear(_ animated: Bool)
  {
    super.viewWillAppear(animated)
    self.populateData()
  }
  @IBAction func profileImageClicked(_ sender: Any)
  {
    imagePickerController.delegate = self
    imagePickerController.allowsEditing = false
    imagePickerController.sourceType = .photoLibrary
    self.navigationController?.present(imagePickerController, animated: true, completion: nil)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
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
    if let customerPhoto = loggedInUserDetails?.customerPhoto
    {
      if customerPhoto.count > 0
      {
        custProfilePicImageView.downloaded(from: URL(string: customerPhoto)!)
        custProfilePicImageView.layer.cornerRadius = (custProfilePicImageView.frame.size.width/2)
      }
    }
    
  }
  
  func callWebService()
  {
    guard let userId = UserLoginDetails.shared.userID else { return }
    guard let tokenStr = UserLoginDetails.shared.token else { return }
    WebServices.sharedWebServices.delegate = self
    if let firstName = firstNameTxtField.text,let lastName = lastNameTxtField.text,let phoneNumber = phoneNoTxtField.text,let address = addressTxtField.text,let city = cityTxtField.text,let state = stateTxtField.text,let zipCode = zipCodeTxtField.text,let billingAddress = billingAddressTxtField.text,let billingCity = billingCityTxtField.text,let billingState = billingStateTxtField.text,let billingZipCode = zipCodeBillingTxtField.text,let creditCardNumber = cardNumberTxtField.text,let creditCardExp = cardExpTxtField.text,let creditCardCVV = cardCVVTxtField.text, let cardHolderName = cardHolderNameTxtField.text
    {
      let parameters = ["userID": userId,"firstName":firstName,"lastName":lastName,"phoneNumber":phoneNumber,"address":address,"city":city,"state":state,"zipCode":zipCode,"billingAddress":billingAddress,"billingCity":billingCity,"billingState":billingState,"billingZipCode":billingZipCode,"creditCardType":"VISA",  "creditCardNumber":creditCardNumber,"creditCardName":cardHolderName,"creditCardExp":creditCardExp,"creditCardCVV":creditCardCVV]
      let imageStringArray = ["customerPhoto"]
      let imageDataArray = [custProfilePicImageView.image]
      self.view.isUserInteractionEnabled = false
      activityIndicator?.isHidden = false
      activityIndicator?.startAnimating()
      WebServices.sharedWebServices.uploadusingUrlSessionNormalDataWithImage(webServiceParameters: parameters, methodType: .POST, webServiceType: .CUSTOMER_UPDATE_PROFILE, token: tokenStr, imagesString: imageStringArray, imageDataArray: imageDataArray as! [UIImage])
      //(webServiceParameters: parameters, methodType: .POST, webServiceType: .CUSTOMER_UPDATE_PROFILE, token: tokenStr)
    }
    
  }
}

extension EditUserProfileVC:WebServiceDelegate
{
  func successResponse(responseString: String, webServiceType: WebServiceType)
  {
    DispatchQueue.main.async {
      self.view.isUserInteractionEnabled = true
      self.activityIndicator?.stopAnimating()
      self.activityIndicator?.isHidden = true
    }
    if let jsonStr = try? JSON(parseJSON: responseString)
    {
      //        let  tempErrorCode = jsonStr["status"].stringValue
      let jsonData = jsonStr["data"].dictionary
      let message = jsonData!["message"]!.string
      //if tempErrorCode == "1"
      if message == "Successfully update your profile"
      {
        
        DispatchQueue.main.async {
          let alertController = UIAlertController(title: message, message: "", preferredStyle: .alert)
          alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
          }))
          self.present(alertController, animated: true, completion: nil)
          
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

extension EditUserProfileVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate
{
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    {
      custProfilePicImageView.image = pickedImage
    }
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
  {
    dismiss(animated: true, completion: nil)
  }
}

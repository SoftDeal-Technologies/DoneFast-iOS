//
//  CardPaymentViewController.swift
//  DoneFast
//
//  Created by Ciber on 8/12/19.
//  Copyright © 2019 Ciber. All rights reserved.
//
import SwiftyJSON
import UIKit
import CCValidator

class CardPaymentViewController: UIViewController,WebServiceDelegate,SignatureDelegate,UITextFieldDelegate{
 
  var activityIndicator:UIActivityIndicatorView?
  
  func successResponse(responseString: String, webServiceType: WebServiceType)
  {
    DispatchQueue.main.async
      {
      self.view.isUserInteractionEnabled = true
      self.activityIndicator?.stopAnimating()
      self.activityIndicator?.isHidden = true
    }
    if let jsonStr = try? JSON(parseJSON: responseString)
    {
      let  tempErrorCode = jsonStr["status"].stringValue
      
      if tempErrorCode == "1"
      {
        let userData = jsonStr["data"].dictionary
        if userData!.count > 0
        {
          let message = userData!["message"]!.stringValue
          if message == "You have successfully signed up & logged in."
          {
            DispatchQueue.main.async {
              self.navigationController?.popToRootViewController(animated: true)
            }
          }
        }
      }
      else if tempErrorCode == "0"
      {
        
      }
    }
  }
  
  func sendSignatureImage(signatureImage: UIImage) {
    self.signatureImage = signatureImage
    self.digitalSignImageView.image = signatureImage
  }
  
  func failerResponse(responseData: String, webServiceType: WebServiceType)
  {
    DispatchQueue.main.async {
      self.view.isUserInteractionEnabled = true
      self.activityIndicator?.stopAnimating()
      self.activityIndicator?.isHidden = true
    }
  }
  
  @IBOutlet weak var monthYearTxtField: UITextField!
  @IBOutlet weak var cardNumberTxtField: UITextField!
  @IBOutlet weak var nameTxtField: UITextField!
  @IBOutlet weak var cvvTxtField: UITextField!
  @IBOutlet weak var digitalSignImageView: UIImageView!
  
  var customerDetails:CustomerDetails?
  var customerBillingDetails:CustomerBillingDetails?
  var signatureImage:UIImage!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    activityIndicator = UIActivityIndicatorView(frame: CGRect(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2, width: 37, height: 37))
    activityIndicator?.style = .whiteLarge
    activityIndicator?.hidesWhenStopped = true
    activityIndicator?.isHidden = true
    self.view.addSubview(activityIndicator!)
        // Do any additional setup after loading the view.
    }
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let allowedCharacters = CharacterSet(charactersIn:"0123456789 ")//Here change this characters based on your requirement
        let characterSet = CharacterSet(charactersIn: string)
        if textField == self.cardNumberTxtField || textField == self.cvvTxtField
        {
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
  @IBAction func signatureClicked(_ sender: Any)
  {
    self.performSegue(withIdentifier: "ToDigitalSignatureView", sender: self)
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {  
    if segue.identifier == "ToDigitalSignatureView"
    {
      let signController = segue.destination as! DigitalSignatureViewController
      signController.delegate = self
    }
  }
  @IBAction func submitClicked(_ sender: Any)
  {
//    self.navigationController?.popToRootViewController(animated: true)
    guard let cardNumber = cardNumberTxtField.text else { return }
    guard let expiryMonthYear = monthYearTxtField.text else { return }
    guard let name = nameTxtField.text else { return }
    guard let cvv = cvvTxtField.text else { return }
    if self.signatureImage != nil
    {
      if (cardNumber.count > 0 && expiryMonthYear.count > 0 && name.count > 0 && cvv.count > 0)
      { 
        let isFullCardDataOK = CCValidator.validate(creditCardNumber: cardNumber)
        if isFullCardDataOK == false
        {
            let alertController:UIAlertController = UIAlertController(title: "", message: "Please enter vaid credit card number.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }

        guard let firstname = customerDetails?.firstName else {return}
        guard let lastName = customerDetails?.lastName else {return}
        guard let emailId = customerDetails?.emailId else {return}
        guard let password = customerDetails?.password else {return}
        guard let phone = customerDetails?.phone else {return}
        guard let address = customerDetails?.address else {return}
        guard let city = customerDetails?.city else {return}
        guard let state = customerDetails?.state else {return}
        guard let zipCode = customerDetails?.zipCode else {return}
        guard let billAddress = customerBillingDetails?.address else {return}
        guard let billCity = customerBillingDetails?.city else {return}
        guard let billState = customerBillingDetails?.state else {return}
        guard let billZipCode = customerBillingDetails?.zipCode else {return}
        
//        print(firstname)
        print(customerDetails?.firstName! as Any)
        
        WebServices.sharedWebServices.delegate = self
//        customerSignature
        let imageParameters = ["customerSignature"]
        let imageDataParameters = [signatureImage]
        
//        let numberAsString = cardNumber.text
        let recognizedType = CCValidator.typeCheckingPrefixOnly(creditCardNumber: cardNumber)
        print(recognizedType.rawValue)
        var creditCardType = ""
        switch (recognizedType.rawValue)
        {
        case 0:
            creditCardType = "AmericanExpress"
        case 1:
            creditCardType = "Dankort"
        case 2:
            creditCardType = "DinersClub"
        case 3:
            creditCardType = "Discover"
        case 4:
            creditCardType = "JCB"
        case 5:
            creditCardType = "Maestro"
        case 6:
            creditCardType = "MasterCard"
        case 7:
            creditCardType = "UnionPay"
        case 8:
            creditCardType = "VisaElectron"
        case 9:
            creditCardType = "Visa"
        case 10:
            creditCardType = "NotRecognized"
        default:
            creditCardType = "NotRecognized"
        }
        //check if type is e.g. .Visa, .MasterCard or .NotRecognized
        
        let customerRegParameters = ["userType":"Customer","firstName":firstname,"lastName":lastName,"emailId":emailId,  "password":password,"phoneNumber":phone,"address":address,"city":city,"state":state,  "zipCode":zipCode,"billingAddress":billAddress,  "billingCity":billCity,  "billingState":billState,  "billingZipCode":billZipCode,"creditCardType":creditCardType,"creditCardNumber":cardNumber,"creditCardName":name,  "creditCardExp":expiryMonthYear,"creditCardCVV":cvv,"deviceType":"iOS","deviceToken":"APA91bFoi3lMMre9G3XzR1LrF4ZT82_15MsMdEICogXSLB8-MrdkRuRQFwNI5u8Dh0cI90ABD3BOKnxkEla8cGdisbDHl5cVIkZah5QUhSAxzx4Roa7b4xy9tvx9iNSYw-eXBYYd8k1XKf8Q_Qq1X9-x-U-Y79vdPq"] as [String : Any] //"billingAddress":"Aspen St",  "billingCity":"San Antonio",  "billingState":"TX",  "billingZipCode":"78006",
        self.view.isUserInteractionEnabled = false
        activityIndicator?.isHidden = false
        activityIndicator?.startAnimating()
        WebServices.sharedWebServices.uploadusingUrlSessionNormalDataWithImage(webServiceParameters: customerRegParameters as [String : Any], methodType: .POST, webServiceType: .NEW_CUSTOMER_REGISTRATION, token: "",imagesString:imageParameters,imageDataArray:imageDataParameters as! [UIImage])
      }
      else
      {
        let alertController:UIAlertController = UIAlertController(title: "", message: "Please enter credit card details.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
      }
    }
  }

}

//
//  CardPaymentViewController.swift
//  DoneFast
//
//  Created by Ciber on 8/12/19.
//  Copyright © 2019 Ciber. All rights reserved.
//
import SwiftyJSON
import UIKit

class CardPaymentViewController: UIViewController,WebServiceDelegate,SignatureDelegate{
 
  func successResponse(responseString: String, webServiceType: WebServiceType) {
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
  
  func failerResponse(responseData: Data, webServiceType: WebServiceType) {
    
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

        // Do any additional setup after loading the view.
    }
    

  @IBAction func signatureClicked(_ sender: Any)
  {
    self.performSegue(withIdentifier: "ToDigitalSignatureView", sender: self)
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
        
//              let customerRegParameters = ["userType":"Customer","firstName":"Hnimavat","lastName":"Harish","emailId":"hardiknimavat@yahoo.com",  "password":"12345678","phoneNumber":"9874859685","address":"AspenSt",  "city":"SanAntonio",  "state":"TX",  "zipCode":"78006",  "creditCardType":"VISA","creditCardNumber":"41111111111111111","creditCardName":"Nimavat","creditCardExp":"12/21",  "creditCardCVV":"123",  "deviceType":"iOS","deviceToken":"APA91bFoi3lMMre9G3XzR1LrF4ZT82_15MsMdEICogXSLB8-MrdkRuRQFwNI5u8Dh0cI90ABD3BOKnxkEla8cGdisbDHl5cVIkZah5QUhSAxzx4Roa7b4xy9tvx9iNSYw-eXBYYd8k1XKf8Q_Qq1X9-x-U-Y79vdPq"]
//
//          {
//            "userType":"Customer",   "firstName":"Sukruth",  "lastName":"Kudige Harish",  "emailId":"sukruth@gmail.com",  "password":"123456",  "phoneNumber":"9874859685",  "address":"Aspen St",  "city":"San Antonio",  "state":"TX",  "zipCode":"78006",  "creditCardType":"Visa",  "creditCardNumber":"4111111111111111",  "creditCardName":"Sukruth Kudige Harish",  "creditCardExp":"11/22",  "creditCardCVV":"111",   "customerSignature":"This will upload raw image data.",  "deviceType":"Android",
//            "deviceToken":"APA91bFoi3lMMre9G3XzR1LrF4ZT82_15MsMdEICogXSLB8-MrdkRuRQFwNI5u8Dh0cI90ABD3BOKnxkEla8cGdisbDHl5cVIkZah5QUhSAxzx4Roa7b4xy9tvx9iNSYw-eXBYYd8k1XKf8Q_Qq1X9-x-U-Y79vdPq"
//        }
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
        
        let customerRegParameters = ["userType":"Customer","firstName":firstname,"lastName":lastName,"emailId":emailId,  "password":password,"phoneNumber":phone,"address":address,"city":city,"state":state,  "zipCode":zipCode,"billingAddress":billAddress,  "billingCity":billCity,  "billingState":billState,  "billingZipCode":billZipCode,"creditCardType":"Visa","creditCardNumber":cardNumber,"creditCardName":name,  "creditCardExp":expiryMonthYear,"creditCardCVV":cvv,"deviceType":"Android","deviceToken":"APA91bFoi3lMMre9G3XzR1LrF4ZT82_15MsMdEICogXSLB8-MrdkRuRQFwNI5u8Dh0cI90ABD3BOKnxkEla8cGdisbDHl5cVIkZah5QUhSAxzx4Roa7b4xy9tvx9iNSYw-eXBYYd8k1XKf8Q_Qq1X9-x-U-Y79vdPq"] //"billingAddress":"Aspen St",  "billingCity":"San Antonio",  "billingState":"TX",  "billingZipCode":"78006",
        WebServices.sharedWebServices.uploadusingUrlSessionNormalDataWithImage(webServiceParameters: customerRegParameters as [String : Any], methodType: .POST, webServiceType: .NEW_CUSTOMER_REGISTRATION, token: "",imagesString:imageParameters,imageDataArray:imageDataParameters as! [UIImage])
      }
      else
      {
        let alertController:UIAlertController = UIAlertController(title: "", message: "Please credit card details.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
      }
    }
//    self.performSegue(withIdentifier: "ToDigitalSignatureView", sender: self)
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

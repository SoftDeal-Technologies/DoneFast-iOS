//
//  NewCustomerViewController.swift
//  DoneFast
//
//  Created by Ciber on 8/12/19.
//  Copyright © 2019 Ciber. All rights reserved.
//

import UIKit

class NewCustomerViewController: UIViewController,UITextFieldDelegate {

  @IBOutlet weak var firstNameTxtField: UITextField!
  @IBOutlet weak var lastNameTxtField: UITextField!
  @IBOutlet weak var emailIdTxtField: UITextField!
  
  @IBOutlet weak var phoneTxtField: UITextField!
  @IBOutlet weak var zipCodeTxtField: UITextField!
  @IBOutlet weak var addressTxtField: UITextField!
  @IBOutlet weak var cityTxtField: UITextField!
  @IBOutlet weak var stateTxtField: UITextField!
  @IBOutlet weak var passwordTxtField: UITextField!
  @IBOutlet weak var confirmPasswordTxtField: UITextField!
  @IBOutlet weak var bgScrollView: UIScrollView!
  var checkMarkPrivacyPolicy = false
  
  @IBOutlet weak var checkBoxBtn: UIButton!
  var customerDetail:CustomerDetails!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    bgScrollView.frame = CGRect(x: 0, y: 179, width: self.view.frame.size.width, height: self.view.frame.size.height-179)
    // Do any additional setup after loading the view.
  }
    
  @IBAction func viewTermsConditionsClicked(_ sender: Any)
  {
    self.performSegue(withIdentifier: "ToTermsConditionsView", sender: self)
  }
  
  @IBAction func checkBoxClicked(_ sender: Any)
  {
    if checkMarkPrivacyPolicy
    {
      let image = UIImage(named:check_box_blank_black)
      
      checkMarkPrivacyPolicy = false
      checkBoxBtn.setImage(image, for: .normal)
    }
    else
    {
      let image = UIImage(named:check_box_black)
      checkMarkPrivacyPolicy = true
      checkBoxBtn.setImage(image, for: .normal)
    }
  }
  
  @IBAction func nextClicked(_ sender: Any)
  {
    guard let firstName = firstNameTxtField.text else { return }
    guard let lastName = lastNameTxtField.text else { return }
    guard let emailId = emailIdTxtField.text else { return }
    guard let state = stateTxtField.text else { return }
    guard let address = addressTxtField.text else { return }
    guard let city = cityTxtField.text else { return }
    guard let password = passwordTxtField.text else { return }
    guard let confirmPassword = confirmPasswordTxtField.text else { return }
    guard let phone = phoneTxtField.text else { return }
    guard let zipCode = zipCodeTxtField.text else { return }
    
    if checkMarkPrivacyPolicy == true
    {
        if password != confirmPassword
        {
            let alertController:UIAlertController = UIAlertController(title: "", message: "Both password should match", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
      if firstName.count > 0 && lastName.count > 0 && emailId.count > 0 && state.count > 0 && address.count > 0 && city.count > 0 && password.count > 0 && confirmPassword.count > 0
      {
        customerDetail = CustomerDetails(firstName: firstName, lastName: lastName, emailId: emailId, state: state, address:address, city: city, password: password, confirmPassword: confirmPassword, phone: phone, zipCode: zipCode)
        
        self.performSegue(withIdentifier: "ToBillingAddressView", sender: self)
      }
      else
      {
        let alertController:UIAlertController = UIAlertController(title: "", message: "Please enter all fields for new registration.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
      }
    }
    else
    {
      let alertController:UIAlertController = UIAlertController(title: "", message: "Please check terms & conditions.", preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alertController, animated: true, completion: nil)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if segue.identifier == "ToBillingAddressView"
    {
      let destController = segue.destination as! BillingAddressVC
      destController.customerDetail = self.customerDetail
    }
  }
  func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key
  {
    textField.resignFirstResponder()
    return true
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

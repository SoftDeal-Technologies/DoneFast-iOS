//
//  BillingAddressVC.swift
//  DoneFast
//
//  Created by Ciber on 9/22/19.
//  Copyright © 2019 Ciber. All rights reserved.
//

import UIKit

let check_box_blank_black = "baseline_check_box_outline_blank_black"
let check_box_black = "baseline_check_box_black"

class BillingAddressVC: UIViewController,UITextFieldDelegate {

  @IBOutlet weak var zipCodeTxtField: UITextField!
  @IBOutlet weak var addressTxtField: UITextField!
  @IBOutlet weak var cityTxtField: UITextField!
  @IBOutlet weak var stateTxtField: UITextField!
  @IBOutlet weak var checkBoxBtn: UIButton!
  var customerDetail:CustomerDetails!
  var customerBillingDetail:CustomerBillingDetails!
  var isSameAsPersonal:Bool = false
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func checkBoxClicked(_ sender: Any)
    {
      if isSameAsPersonal == false
      {
        isSameAsPersonal = true
        zipCodeTxtField.text = customerDetail.zipCode
        addressTxtField.text = customerDetail.address
        cityTxtField.text = customerDetail.city
        stateTxtField.text = customerDetail.state
        let image = UIImage(named:check_box_black)
        checkBoxBtn.setImage(image, for: .normal)
      }
      else
      {
        isSameAsPersonal = false
        zipCodeTxtField.text = ""
        addressTxtField.text = ""
        cityTxtField.text = ""
        stateTxtField.text = ""
        let image = UIImage(named:check_box_blank_black)
        checkBoxBtn.setImage(image, for: .normal)
      }
    }
  
  @IBAction func nextClicked(_ sender: Any)
  {
    
    guard let state = stateTxtField.text else { return }
    guard let address = addressTxtField.text else { return }
    guard let city = cityTxtField.text else { return }
    guard let zipCode = zipCodeTxtField.text else { return }
    
    if state.count > 0 && address.count > 0 && city.count > 0 && zipCode.count > 0
    {
      customerBillingDetail = CustomerBillingDetails(state: state, address:address, city: city, zipCode: zipCode)
      self.performSegue(withIdentifier: "ToCardPaymentView", sender: self)
    }
    else
    {
      let alertController:UIAlertController = UIAlertController(title: "", message: "Please enter all fields for billing address details", preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alertController, animated: true, completion: nil)
    }
    
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if segue.identifier == "ToCardPaymentView"
    {
      let destController = segue.destination as! CardPaymentViewController
      destController.customerDetails = self.customerDetail
      destController.customerBillingDetails = self.customerBillingDetail
    }
    
  }
}

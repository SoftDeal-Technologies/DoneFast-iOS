//
//  RegistrationOptionViewController.swift
//  DoneFast
//
//  Created by Ciber on 8/10/19.
//  Copyright © 2019 Ciber. All rights reserved.
//

import UIKit

class RegistrationOptionViewController: UIViewController {

  @IBOutlet weak var vendorBtn: UIButton!
  @IBOutlet weak var customerBtn: UIButton!
  override func viewDidLoad()
  {
      super.viewDidLoad()
      // Do any additional setup after loading the view.
      vendorBtn.layer.borderColor = UIColor.black.cgColor
      customerBtn.layer.borderColor = UIColor.black.cgColor
      vendorBtn.layer.borderWidth = 2.0
      customerBtn.layer.borderWidth = 2.0
      vendorBtn.layer.cornerRadius = 10.0
      customerBtn.layer.cornerRadius = 10.0
  }
  
  @IBAction func customerBtnClicked(_ sender: Any)
  {
    self.performSegue(withIdentifier: "ToNewCustomerView", sender: self)
  }
  
  @IBAction func vendorBtnClicked(_ sender: Any)
  {
    
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

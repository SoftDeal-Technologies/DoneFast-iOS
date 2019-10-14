//
//  LogOutVC.swift
//  DoneFast
//
//  Created by Ciber on 10/4/19.
//  Copyright © 2019 Ciber. All rights reserved.
//

import UIKit
import SwiftyJSON

class LogOutVC: UIViewController {

    var activityIndicator:UIActivityIndicatorView?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.logOutClicked()
  }
    

  func logOutClicked()
  {
    guard let userId = UserLoginDetails.shared.userID else { return }
    guard let userType = UserLoginDetails.shared.loginType else { return }
    let parameters = ["userID": userId,"userType": userType]
    guard let tokenStr = UserLoginDetails.shared.token else { return }
    self.view.isUserInteractionEnabled = false
    activityIndicator?.isHidden = false
    activityIndicator?.startAnimating()
    WebServices.sharedWebServices.delegate = self
    WebServices.sharedWebServices.uploadusingUrlSessionNormalData(webServiceParameters: parameters, methodType: .POST, webServiceType: .LOG_OUT, token: tokenStr)
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

extension LogOutVC:WebServiceDelegate
{
  func successResponse(responseString: String, webServiceType: WebServiceType) {
    
    DispatchQueue.main.async {
      self.view.isUserInteractionEnabled = true
      self.activityIndicator?.stopAnimating()
      self.activityIndicator?.isHidden = true
    }
    
    if let jsonStr = try? JSON(parseJSON: responseString)
    {
      let  tempErrorCode = jsonStr["status"].stringValue
      let userData = jsonStr["data"].dictionary
      let message = userData!["message"]!.stringValue
      if tempErrorCode == "1" && message == "Successfully Logout."
      {
        DispatchQueue.main.async {
            guard let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
                else
            {
                return
            }
            ClearLoginDetails.shared.clearAllLoginData()
            let appdelegate = UIApplication.shared.delegate as? AppDelegate
            appdelegate?.window?.rootViewController = loginViewController
        }
      }
    }
  }
  
  func failerResponse(responseData: String, webServiceType: WebServiceType) {
    
  }
  
  
}

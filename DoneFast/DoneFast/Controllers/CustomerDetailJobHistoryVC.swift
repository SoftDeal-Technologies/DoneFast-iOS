//
//  CustomerDetailJobHistoryVC.swift
//  DoneFast
//
//  Created by Ciber on 8/27/19.
//  Copyright © 2019 Ciber. All rights reserved.
//
import SwiftyJSON

import UIKit

class CustomerDetailJobHistoryVC: UIViewController {

  var customerLoginDetails:UserLoginDetails? = nil
  var customerRequest:CustomerRequest? = nil
  
  @IBOutlet weak var serviceFeeLabel: UILabel!
  @IBOutlet weak var dispatchFeeLabel: UILabel!
  @IBOutlet weak var permitFeeLabel: UILabel!
  @IBOutlet weak var totalFeeLabel: UILabel!
  var delegate: CenterViewControllerDelegate?

  override func viewDidLoad()
  {
      super.viewDidLoad()
      // Do any additional setup after loading the view.
  }
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.callWebService()
  }
  
  // MARK: Button actions
  @IBAction func leftPanelClicked(_ sender: Any)
  {
    delegate?.toggleLeftPanel()
  }
  
  @IBAction func goBackClicked(_ sender: Any)
  {
    self.navigationController?.popViewController(animated: true)
  }
  
  func callWebService()
  {
    guard let userId = UserLoginDetails.shared.userID else { return }
    guard let requestId = customerRequest?.requestId else { return }
    let parameters = ["customer_id": userId,"request_id":requestId]
    guard let tokenStr = UserLoginDetails.shared.token else { return }
    WebServices.sharedWebServices.delegate = self
    WebServices.sharedWebServices.uploadusingUrlSessionNormalData(webServiceParameters: parameters, methodType: .POST, webServiceType: .VIEW_PRICE_QUOTE, token: tokenStr)
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
extension CustomerDetailJobHistoryVC:WebServiceDelegate
{
  func successResponse(responseString: String, webServiceType: WebServiceType) {
    //List of Requests
    
    if let jsonStr = try? JSON(parseJSON: responseString)
    {
      let  tempErrorCode = jsonStr["status"].stringValue
      
      if tempErrorCode == "1"
      {
        let responseData = jsonStr["data"].dictionary
        let priceQuoteDetails = responseData!["response"]!.arrayValue
        if priceQuoteDetails.count > 0
        {
          let customerReqPriceQuote = CustomerRequestPriceQuote()
          let tempDict = priceQuoteDetails[0]
          customerReqPriceQuote.request_id = tempDict["request_id"].stringValue
          customerReqPriceQuote.propertyId = tempDict["propertyId"].stringValue
          customerReqPriceQuote.propertyTitle = tempDict["propertyTitle"].stringValue
          customerReqPriceQuote.propertyLocation = tempDict["propertyLocation"].stringValue
          customerReqPriceQuote.service_type = tempDict["service_type"].stringValue
          customerReqPriceQuote.service_subtype = tempDict["service_subtype"].stringValue
          customerReqPriceQuote.service_fee = tempDict["service_fee"].stringValue
          customerReqPriceQuote.dispatch_fee = tempDict["dispatch_fee"].stringValue
          customerReqPriceQuote.permanent_fee = tempDict["permanent_fee"].stringValue
          customerReqPriceQuote.job_id = tempDict["job_id"].stringValue
          customerReqPriceQuote.vendro_name = tempDict["vendro_name"].stringValue
          customerReqPriceQuote.job_status = tempDict["job_status"].stringValue
          customerReqPriceQuote.priceQuoteStatus = tempDict["priceQuoteStatus"].stringValue
          customerReqPriceQuote.requestOn = tempDict["requestOn"].stringValue
          DispatchQueue.main.async {
            self.serviceFeeLabel.text = customerReqPriceQuote.service_fee
            self.dispatchFeeLabel.text = customerReqPriceQuote.dispatch_fee
            self.permitFeeLabel.text = customerReqPriceQuote.permanent_fee
          }
        }
      }
    }
  }
  
  func failerResponse(responseData: Data, webServiceType: WebServiceType) {
    
  }
}

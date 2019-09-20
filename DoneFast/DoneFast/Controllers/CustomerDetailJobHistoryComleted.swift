//
//  CustomerDetailJobHistoryVC.swift
//  DoneFast
//
//  Created by Ciber on 8/27/19.
//  Copyright © 2019 Ciber. All rights reserved.
//
import SwiftyJSON

import UIKit

class CustomerDetailJobHistoryCompleted: UIViewController {

  var customerLoginDetails:UserLoginDetails? = nil
  var customerRequest:CustomerRequest? = nil
  
  @IBOutlet weak var reqIDLabel: UILabel!
  @IBOutlet weak var jobIDLabel: UILabel!
  @IBOutlet weak var serviceLabel: UILabel!
  @IBOutlet weak var serviceSubTypeLabel: UILabel!
  @IBOutlet weak var jobStatusLabel: UILabel!
  @IBOutlet weak var vendorNameLabel: UILabel!
  @IBOutlet weak var priceQuoteStatusLabel: UILabel!
  @IBOutlet weak var requestDateLabel: UILabel!
  @IBOutlet weak var travelStartDateLabel: UILabel!
  @IBOutlet weak var travelEndDateLabel: UILabel!
  @IBOutlet weak var workStartDateLabel: UILabel!
  @IBOutlet weak var workEndDateLabel: UILabel!
  @IBOutlet weak var propertyIdLable: UILabel!
  @IBOutlet weak var propertyTitleLabel: UILabel!
  @IBOutlet weak var propertyAddressLabel: UILabel!
  
  
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
extension CustomerDetailJobHistoryCompleted:WebServiceDelegate
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
          let customerReqPriceQuote = CustomerRequestDetailPriceQuote()
          let tempDict = priceQuoteDetails[0]
          customerReqPriceQuote.request_id = tempDict["request_id"].stringValue
          customerReqPriceQuote.propertyId = tempDict["propertyId"].stringValue
          customerReqPriceQuote.propertyTitle = tempDict["propertyTitle"].stringValue
          customerReqPriceQuote.propertyLocation = tempDict["propertyLocation"].stringValue
          customerReqPriceQuote.service_type = tempDict["service_type"].stringValue
          customerReqPriceQuote.service_subtype = tempDict["service_subtype"].stringValue
          customerReqPriceQuote.service_fee = tempDict["travelStart_date"].stringValue
          customerReqPriceQuote.dispatch_fee = tempDict["travelEnd_date"].stringValue
          customerReqPriceQuote.permanent_fee = tempDict["workStart_date"].stringValue
          customerReqPriceQuote.job_id = tempDict["job_id"].stringValue
          customerReqPriceQuote.vendro_name = tempDict["vendro_name"].stringValue
          customerReqPriceQuote.job_status = tempDict["job_status"].stringValue
          customerReqPriceQuote.priceQuoteStatus = tempDict["priceQuoteStatus"].stringValue
          customerReqPriceQuote.requestOn = tempDict["requestOn"].stringValue
          
          DispatchQueue.main.async {
            self.reqIDLabel.text = customerReqPriceQuote.request_id
            self.jobIDLabel.text = customerReqPriceQuote.job_id
            self.serviceLabel.text = customerReqPriceQuote.service_type
            self.serviceSubTypeLabel.text = customerReqPriceQuote.service_subtype
            self.jobStatusLabel.text = customerReqPriceQuote.job_status
            self.vendorNameLabel.text = customerReqPriceQuote.vendro_name
            self.priceQuoteStatusLabel.text = customerReqPriceQuote.priceQuoteStatus
            self.requestDateLabel.text = customerReqPriceQuote.requestOn
            self.travelStartDateLabel.text = customerReqPriceQuote.travelStart_date
            self.travelEndDateLabel.text = customerReqPriceQuote.travelEnd_date
            self.workStartDateLabel.text = customerReqPriceQuote.workStart_date
            self.workEndDateLabel.text = customerReqPriceQuote.workEnd_date
            self.propertyIdLable.text = customerReqPriceQuote.propertyId
            self.propertyTitleLabel.text = customerReqPriceQuote.propertyTitle
            self.propertyAddressLabel.text = customerReqPriceQuote.propertyLocation
          }
        }
      }
    }
  }
  
  func failerResponse(responseData: Data, webServiceType: WebServiceType) {
    
  }
}

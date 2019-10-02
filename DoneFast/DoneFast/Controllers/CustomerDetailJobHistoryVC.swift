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
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var serviceFeeLabel: UILabel!
  @IBOutlet weak var dispatchFeeLabel: UILabel!
  @IBOutlet weak var permitFeeLabel: UILabel!
  @IBOutlet weak var totalFeeLabel: UILabel!
  @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var serviceFeeTitleLable: UILabel!
  @IBOutlet weak var reqIDLabel: UILabel!
  @IBOutlet weak var jobIDLabel: UILabel!
  @IBOutlet weak var serviceLabel: UILabel!
  @IBOutlet weak var serviceSubTypeLabel: UILabel!
  @IBOutlet weak var reqDateLabel: UILabel!
  @IBOutlet weak var propertyTitleLabel: UILabel!
  @IBOutlet weak var propertyLocationLabel: UILabel!
  @IBOutlet weak var topView: UIView!
  @IBOutlet weak var permitStackView: UIStackView!
  @IBOutlet weak var totalStackView: UIStackView!
  @IBOutlet weak var jobIdStackView: UIStackView!
  @IBOutlet weak var downSeparatorView: UIView!
  @IBOutlet weak var topSeparatorView: UIView!
  @IBOutlet weak var acceptCancelStackView: UIStackView!
  @IBOutlet weak var jobIdStackHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var backBtnYConstraint: NSLayoutConstraint!
  @IBOutlet weak var acceptBtn: UIButton!
  @IBOutlet weak var cancelBtn: UIButton!
  @IBOutlet weak var backBtn: UIButton!
  @IBOutlet weak var totalStackViewConstraint: NSLayoutConstraint!
  var delegate: CenterViewControllerDelegate?
  @IBOutlet weak var topSeparaterViewConstraint: NSLayoutConstraint!
  var activityIndicator:UIActivityIndicatorView?
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    activityIndicator = UIActivityIndicatorView(frame: CGRect(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2, width: 37, height: 37))
    activityIndicator?.style = .whiteLarge
    activityIndicator?.hidesWhenStopped = true
    activityIndicator?.isHidden = true
    self.view.addSubview(activityIndicator!)
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
  
  @IBAction func acceptClicked(_ sender: Any)
  {
    var status = ""
    let senderbtn = sender as? UIButton
    if senderbtn?.tag == 1
    {
      status = "Accepted"
    }
    else
    {
      status = "Cancelled"
    }
    
    guard let userId = UserLoginDetails.shared.userID else { return }
    guard let requestId = customerRequest?.requestId else { return }
    
    let parameters = ["customer_id": userId,"request_id":requestId,"status":status] //
    guard let tokenStr = UserLoginDetails.shared.token else { return }
    WebServices.sharedWebServices.delegate = self
    self.view.isUserInteractionEnabled = false
    activityIndicator?.isHidden = false
    activityIndicator?.startAnimating()
    WebServices.sharedWebServices.uploadusingUrlSessionNormalData(webServiceParameters: parameters, methodType: .POST, webServiceType: .PRICE_REQUEST, token: tokenStr)
  }
  
  func callWebService()
  {
    guard let userId = UserLoginDetails.shared.userID else { return }
    guard let requestId = customerRequest?.requestId else { return }
    let parameters = ["customer_id": userId,"request_id":requestId]
    guard let tokenStr = UserLoginDetails.shared.token else { return }
    WebServices.sharedWebServices.delegate = self
    self.view.isUserInteractionEnabled = false
    activityIndicator?.isHidden = false
    activityIndicator?.startAnimating()
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
    DispatchQueue.main.async {
      self.view.isUserInteractionEnabled = true
      self.activityIndicator?.stopAnimating()
      self.activityIndicator?.isHidden = true
    }
    if webServiceType == .VIEW_PRICE_QUOTE
    {
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
              self.reqIDLabel.text = customerReqPriceQuote.request_id
              self.jobIDLabel.text = customerReqPriceQuote.job_id
              self.serviceLabel.text = customerReqPriceQuote.service_type
              self.serviceSubTypeLabel.text = customerReqPriceQuote.service_subtype
              self.propertyTitleLabel.text = customerReqPriceQuote.propertyTitle
              self.propertyLocationLabel.text = customerReqPriceQuote.propertyLocation
              
              if customerReqPriceQuote.priceQuoteStatus == "Price Quote Accepted" || customerReqPriceQuote.priceQuoteStatus == "Price Quote Assigned" // || customerReqPriceQuote.priceQuoteStatus == "Price Quote Cancelled"
              {
                self.topSeparaterViewConstraint.constant = 300
                self.totalStackView.isHidden = true
                self.downSeparatorView.isHidden = true
                self.backBtnYConstraint.constant = 50
                self.topSeparatorView.isHidden = false
                if customerReqPriceQuote.priceQuoteStatus == "Price Quote Accepted"
                {
                  self.titleLabel.text = "ORDER DETAILS"
                  //                self.backBtn.isHidden = true
                  self.acceptBtn.isHidden = true
                  self.cancelBtn.isHidden = true
                }
                else
                {
                  self.jobIdStackHeightConstraint.constant = 0
                  self.jobIdStackView.isHidden = true
                  self.titleLabel.text = "SERVICE ORDER QUOTE"
                }
              }
              else if customerReqPriceQuote.priceQuoteStatus == "Pending"
              {
                //              self.topViewHeightConstraint.constant = 10
                //              self.backBtnYConstraint.constant = 135
                self.topSeparaterViewConstraint.constant = 0
                self.topView.isHidden = true
                self.titleLabel.text = "PENDING"
                self.acceptBtn.isHidden = true
                self.cancelBtn.isHidden = true
                self.topSeparatorView.isHidden = true
              }
            }
          }
        }
      }
    }
    else if webServiceType == .PRICE_REQUEST
    {
      if let jsonStr = try? JSON(parseJSON: responseString)
      {
        let  tempErrorCode = jsonStr["status"].stringValue
        
        if tempErrorCode == "1"
        {
          let responseData = jsonStr["data"].dictionary
          let priceQuoteDetails = responseData!["message"]!.stringValue
          DispatchQueue.main.async {
            let alertController:UIAlertController = UIAlertController(title: "", message: priceQuoteDetails, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: {
              self.navigationController?.popViewController(animated: true)
            })
          }
        }
      }
    }
    
    //Response sent successfully.
  }
  
  func failerResponse(responseData: Data, webServiceType: WebServiceType) {
    DispatchQueue.main.async {
      self.view.isUserInteractionEnabled = true
      self.activityIndicator?.stopAnimating()
      self.activityIndicator?.isHidden = true
    }
  }
}

//
//  CustomerJobHistoryVC.swift
//  DoneFast
//
//  Created by Ciber on 9/3/19.
//  Copyright © 2019 Ciber. All rights reserved.
//

import UIKit
import SwiftyJSON
let customerPropertyTableCellIdentifier = "CustomerJobHistoryTableCell"
class CustomerJobHistoryVC: UIViewController {
  var customerLoginDetails:UserLoginDetails? = nil
  var jobRequestListArray:[CustomerRequest] = []
  var selectedCustomerRequest:CustomerRequest? = nil
  var delegate: CenterViewControllerDelegate?
  
  @IBOutlet weak var jobRequestTableView: UITableView!
  
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
  
  func callWebService()
  {
    guard let userId = UserLoginDetails.shared.userID else { return }
    let loginParameters = ["customer_id": userId]
    guard let tokenStr = UserLoginDetails.shared.token else { return }
    WebServices.sharedWebServices.delegate = self
    WebServices.sharedWebServices.uploadusingUrlSessionNormalData(webServiceParameters: loginParameters, methodType: .POST, webServiceType: .CUSTOMER_REQUESTS, token: tokenStr)
  }
    // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
      // Get the new view controller using segue.destination.
      // Pass the selected object to the new view controller.
    if segue.identifier == "ToCustomerJobDetail"
    {
      let customerDetailJobHistoryVC = segue.destination as? CustomerDetailJobHistoryVC
      customerDetailJobHistoryVC?.customerLoginDetails = self.customerLoginDetails
      customerDetailJobHistoryVC?.customerRequest = self.selectedCustomerRequest
      customerDetailJobHistoryVC?.delegate = self.delegate
    }
  }
  
}

extension CustomerJobHistoryVC:UITableViewDelegate
{
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
  {
    tableView.deselectRow(at: indexPath, animated: true) //ToCustomerDetail ,ToAddCustomerProperty
    self.selectedCustomerRequest = self.jobRequestListArray[indexPath.row]
    self.performSegue(withIdentifier: "ToCustomerJobDetail", sender: self)
  }
}

extension CustomerJobHistoryVC:UITableViewDataSource
{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return self.jobRequestListArray.count
//    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    var customerJobHistoryTableCell: CustomerJobHistoryTableCell! = tableView.dequeueReusableCell(withIdentifier: customerPropertyTableCellIdentifier) as? CustomerJobHistoryTableCell
    if customerJobHistoryTableCell == nil
    {
      tableView.register(UINib(nibName: customerPropertyTableCellIdentifier, bundle: nil), forCellReuseIdentifier: customerPropertyTableCellIdentifier)
      customerJobHistoryTableCell = tableView.dequeueReusableCell(withIdentifier: customerPropertyTableCellIdentifier) as? CustomerJobHistoryTableCell
    }
    let customerRequest = self.jobRequestListArray[indexPath.row]
    if let  title = customerRequest.priceQuoteStatus
    {
        customerJobHistoryTableCell.statusLabel.text =  title
    }
    if let  jobId = customerRequest.jobId
    {
      customerJobHistoryTableCell.jobIdLabel.text = "\(jobId)"
    }
    if let  jobStatus = customerRequest.jobStatus
    {
     customerJobHistoryTableCell.titleLabel.text = "\(jobStatus)"
    }
    if let  requestId = customerRequest.requestId
    {
      customerJobHistoryTableCell.requestIdLabel.text = "#\(requestId)"
    }
    
    return customerJobHistoryTableCell
  }
}

extension CustomerJobHistoryVC:WebServiceDelegate
{
  func successResponse(responseString: String, webServiceType: WebServiceType) {
    //List of Requests
    
    if let jsonStr = try? JSON(parseJSON: responseString)
    {
      let  tempErrorCode = jsonStr["status"].stringValue
      
      if tempErrorCode == "1"
      {
        let requestData = jsonStr["data"].dictionary
        let requestList = requestData!["requestList"]!.arrayValue
        if self.jobRequestListArray.count > 0
        {
          self.jobRequestListArray.removeAll()
        }
        for tempDict in requestList
        {
          let customerRequest = CustomerRequest()
          customerRequest.requestId = tempDict["requestId"].stringValue
          customerRequest.serviceId = tempDict["serviceId"].stringValue
          customerRequest.propertyId = tempDict["propertyId"].stringValue
          customerRequest.customerId = tempDict["customerId"].stringValue
          customerRequest.customerName = tempDict["customerName"].stringValue
          customerRequest.priceQuoteStatus = tempDict["priceQuoteStatus"].stringValue
          customerRequest.jobStatus = tempDict["jobStatus"].stringValue
          customerRequest.jobId = tempDict["jobId"].stringValue
          customerRequest.vendor = tempDict["vendor"].stringValue
          customerRequest.requestOn = tempDict["requestOn"].stringValue
          self.jobRequestListArray.append(customerRequest)
        }

        DispatchQueue.main.async {
          self.jobRequestTableView.reloadData()
        }
      }
    }
  }
  
  func failerResponse(responseData: Data, webServiceType: WebServiceType) {
    
  }
}

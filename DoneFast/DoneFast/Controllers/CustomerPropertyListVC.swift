//
//  CustomerPropertyListVC.swift
//  DoneFast
//
//  Created by Ciber on 8/20/19.
//  Copyright © 2019 Ciber. All rights reserved.
//

import UIKit
import SwiftyJSON

let cellIdentifier = "CustomerPropertyTableCell"

class CustomerPropertyListVC: UIViewController {
  
  @IBOutlet weak var customerListTableView: UITableView!
  var delegate: CenterViewControllerDelegate?
  var customerLoginDetails:UserLoginDetails? = nil
  var propertyListArray:[PropertyList] = []
  var selectedPropertyId:String?
  var activityIndicator:UIActivityIndicatorView?
  
  override func viewDidLoad()
  {
      super.viewDidLoad()
      // Do any additional setup after loading the view.
    activityIndicator = UIActivityIndicatorView(frame: CGRect(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2, width: 37, height: 37))
    activityIndicator?.style = .whiteLarge
    activityIndicator?.hidesWhenStopped = true
    activityIndicator?.isHidden = true
    self.view.addSubview(activityIndicator!)
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.callWebService()
  }
  
  func callWebService()
  {
    guard let userId = UserLoginDetails.shared.userID else { return }
    let loginParameters = ["userID": userId]
    guard let tokenStr = UserLoginDetails.shared.token else { return }
    self.view.isUserInteractionEnabled = false
    activityIndicator?.isHidden = false
    activityIndicator?.startAnimating()
    WebServices.sharedWebServices.delegate = self
    WebServices.sharedWebServices.uploadusingUrlSessionNormalData(webServiceParameters: loginParameters, methodType: .POST, webServiceType: .LIST_CUSTOMER_PROPERTY, token: tokenStr)
  }
  
  // MARK: Button actions
  @IBAction func leftPanelClicked(_ sender: Any)
  {
    delegate?.toggleLeftPanel()
  }
  
  @IBAction func addCustomerPropertyClicked(_ sender: Any)
  {
//    self.performSegue(withIdentifier: "ToAddCustomerProperty", sender: self) //ToUserDetail
//    self.performSegue(withIdentifier: "ToCustomerJobHistory", sender: self) ///ToUserDetail For Testing only
    guard let customerAddPropertyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomerAddPropertyVC") as? CustomerAddPropertyVC
      else
    {
      return
    }
    self.navigationController!.pushViewController(customerAddPropertyVC, animated: true)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if segue.identifier == "ToAddCustomerProperty"
    {
      let customerAddProp = segue.destination as? CustomerAddPropertyVC
      customerAddProp?.customerLoginDetails = self.customerLoginDetails
    }
    else if segue.identifier == "ToCustomerDetail"
    {
      let customerPropertyDetail = segue.destination as? CustomerPropertyDetailVC
      customerPropertyDetail?.customerLoginDetails = self.customerLoginDetails
      customerPropertyDetail?.delegate = self.delegate
      customerPropertyDetail?.propertyId = self.selectedPropertyId
    }
    else if segue.identifier == "ToUserDetail"
    {
      let customerPropertyDetail = segue.destination as? UserProfileVC
      customerPropertyDetail?.customerLoginDetails = self.customerLoginDetails
    }
    else if segue.identifier == "ToCustomerJobHistory"
    {
      let customerJobHistory = segue.destination as? CustomerJobHistoryVC
      customerJobHistory?.customerLoginDetails = self.customerLoginDetails
    }
  }
}

extension CustomerPropertyListVC:UITableViewDelegate
{
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
  {
    tableView.deselectRow(at: indexPath, animated: true) //ToCustomerDetail ,ToAddCustomerProperty
    let propertyList = self.propertyListArray[indexPath.row]
    self.selectedPropertyId = propertyList.propertyID
    self.performSegue(withIdentifier: "ToCustomerDetail", sender: self)
  }
}

extension CustomerPropertyListVC:UITableViewDataSource
{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
//    guard let countRows = self.propertyListArray else { return 0 }
    return self.propertyListArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //    let addClubCardTableViewCell:AddClubCardTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AddClubCardTableViewCell
    
    var customerPropertyTableCell: CustomerPropertyTableCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CustomerPropertyTableCell
    if customerPropertyTableCell == nil
    {
      tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
      customerPropertyTableCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CustomerPropertyTableCell
    }
    let customerProperty = self.propertyListArray[indexPath.row]
    
    if let  propertyTitle = customerProperty.propertyTitle
    {
      customerPropertyTableCell.newPropTitleLabel.text =  propertyTitle
    }
    if let  propertyCity = customerProperty.propertyCity , let propertyState = customerProperty.propertyState
    {
      customerPropertyTableCell.locationLabel.text = "Location: \(propertyCity), \(propertyState)"
    }
    if let  propertyAddress = customerProperty.propertyAddress
    {
      customerPropertyTableCell.addressLabel.text = "Address: \(propertyAddress)"
    }
    if let  propertyID = customerProperty.propertyID
    {
     customerPropertyTableCell.propertyIdLabel.text = "Property ID: \(propertyID)"
    }
    
    return customerPropertyTableCell
  }
}

extension CustomerPropertyListVC:WebServiceDelegate
{
  func successResponse(responseString: String, webServiceType: WebServiceType)
  {
    DispatchQueue.main.async {
      self.view.isUserInteractionEnabled = true
      self.activityIndicator?.stopAnimating()
      self.activityIndicator?.isHidden = true
    }
    
    if let jsonStr = try? JSON(parseJSON: responseString)
    {
      let  tempErrorCode = jsonStr["status"].stringValue
      
      if tempErrorCode == "1"
      {
        let propertyData = jsonStr["data"].dictionary
        let propertyList = propertyData!["propertyList"]!.arrayValue
        if self.propertyListArray.count > 0
        {
          self.propertyListArray.removeAll()
        }
        for tempDict in propertyList
        {
          print(tempDict)
          let propertyList = PropertyList()
          propertyList.propertyID = tempDict["propertyID"].stringValue
          propertyList.propertyType = tempDict["propertyType"].stringValue
          propertyList.propertyTitle = tempDict["propertyTitle"].stringValue
          propertyList.propertyCity = tempDict["propertyCity"].stringValue
          propertyList.propertyState = tempDict["propertyState"].stringValue
          propertyList.propertyZipCode = tempDict["propertyZipCode"].stringValue
          propertyList.propertyPhoto = tempDict["propertyPhoto"].stringValue
          propertyList.propertyAddress = tempDict["propertyAddress"].stringValue
          self.propertyListArray.append(propertyList)
        }
        DispatchQueue.main.async {
          self.customerListTableView.reloadData()
        }
      }
    }
  }
  
  func failerResponse(responseData: Data, webServiceType: WebServiceType)
  {
    DispatchQueue.main.async {
      self.view.isUserInteractionEnabled = true
      self.activityIndicator?.stopAnimating()
      self.activityIndicator?.isHidden = true
    }
  }
}

//protocol CenterViewControllerDelegate
//{
//  func toggleLeftPanel()
//  func collapseSidePanels()
//}
//
//extension CustomerPropertyListVC: SidePanelViewControllerDelegate {
//  func didSelectRow(selectedRow: Int) {
//    self.callWebService()
//  }
//}

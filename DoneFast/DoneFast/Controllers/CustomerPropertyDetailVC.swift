//
//  CustomerPropertyDetailVC.swift
//  DoneFast
//
//  Created by Ciber on 8/20/19.
//  Copyright © 2019 Ciber. All rights reserved.
//

import UIKit
import SwiftyJSON

class CustomerPropertyDetailVC: UIViewController {

  var propertyId:String?
  var customerLoginDetails:UserLoginDetails? = nil
  var propertyList:PropertyList? = nil
  var delegate: CenterViewControllerDelegate?
  @IBOutlet weak var propertyTitleLabel: UILabel!
  @IBOutlet weak var zipCodeLabel: UILabel!
  @IBOutlet weak var phoneNoLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var stateLabel: UILabel!
  @IBOutlet weak var propertyDesignLabel: UILabel!
  @IBOutlet weak var propertyidLabel: UILabel!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var propertyAddressLabel:UILabel!
  @IBOutlet weak var propertyTypeImageView: UIImageView!
  @IBOutlet weak var editDeletePropertyBtn: UIButton!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    self.callWebService(webServiceType: .VIEW_CUSTOMER_PROPERTY)
  }
  
  override func viewWillAppear(_ animated: Bool)
  {
    super.viewWillAppear(animated)
  }
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
  func callWebService(webServiceType:WebServiceType)
  {
    guard let propertyId = self.propertyId else { return }
    let loginParameters = ["propertyID": propertyId]
    guard let tokenStr = UserLoginDetails.shared.token else { return }
    WebServices.sharedWebServices.delegate = self
    WebServices.sharedWebServices.uploadusingUrlSessionNormalData(webServiceParameters: loginParameters, methodType: .POST, webServiceType: webServiceType, token: tokenStr)
  }

  // MARK: Button actions
  @IBAction func leftPanelClicked(_ sender: Any)
  {
    delegate?.toggleLeftPanel()
  }
  
  @IBAction func editDeletePropertyClicked(_ sender: Any)
  {
//      self.performSegue(withIdentifier: "ToEditCustomerProperty", sender: self)
    
//    self.callWebService(webServiceType: .DELETE_CUSTOMER_PROPERTY)
    
    // get a reference to the view controller for the popover
    let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubCategoryServiceVC") as? SubCategoryServiceVC
    // set the presentation style
    popController!.modalPresentationStyle = UIModalPresentationStyle.popover
    popController?.popOverType = .EditOrDeleteProperty
    popController?.serviceListArray = ["Edit","Delete"] as [AnyObject]
    // set up the popover presentation controller
    popController?.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
    popController?.popoverPresentationController?.delegate = self
    popController?.delegate = self
    popController?.popoverPresentationController?.sourceView = (sender as! UIView) // button
    popController?.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
    // present the popover
    self.present(popController!, animated: true, completion: nil)
  }
  @IBAction func backClicked(_ sender: Any)
  {
    self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction func requestServiceClicked(_ sender: Any)
  {
    self.performSegue(withIdentifier: "ToSelectService", sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if segue.identifier == "ToEditCustomerProperty"
    {
      let editCustomerPropertyVC = segue.destination as? EditCustomerPropertyVC
      editCustomerPropertyVC?.customerLoginDetails = self.customerLoginDetails
      editCustomerPropertyVC?.propertyList = self.propertyList
    }
    else if (segue.identifier == "ToSelectService")
    {
      let selectServiceController = segue.destination as? SelectServiceVC
      selectServiceController?.customerLoginDetails = self.customerLoginDetails
      selectServiceController?.propertyId = self.propertyId
      selectServiceController?.delegate = self.delegate
    }
  }
  
  @objc func goToEditViewProperty()
  {
    self.performSegue(withIdentifier: "ToEditCustomerProperty", sender: self)
  }
}

extension CustomerPropertyDetailVC : WebServiceDelegate
{
  func successResponse(responseString: String, webServiceType: WebServiceType)
  {
    if webServiceType == .VIEW_CUSTOMER_PROPERTY
    {
      if let jsonStr = try? JSON(parseJSON: responseString)
      {
        //        let  tempErrorCode = jsonStr["status"].stringValue
        let propertyData = jsonStr["data"].dictionary
        let message = propertyData!["message"]!.string
        //if tempErrorCode == "1"
        if message == "Success"
        {
          let propertyArray = propertyData!["property"]!.arrayValue
          if propertyArray.count > 0
          {
            let tempProperty = propertyArray[0]
            DispatchQueue.main.async {
              self.propertyTitleLabel.text =  tempProperty["propertyTitle"].stringValue
              self.zipCodeLabel.text =  tempProperty["propertyZipCode"].stringValue
              self.phoneNoLabel.text =  tempProperty["propertyPhoneNumber"].stringValue
              self.emailLabel.text =  tempProperty["propertyEmailId"].stringValue
              self.stateLabel.text =  tempProperty["propertyState"].stringValue
              self.propertyDesignLabel.text =  tempProperty["propertyDesignName"].stringValue
              self.propertyidLabel.text =  tempProperty["propertyID"].stringValue
              self.cityLabel.text =  tempProperty["propertyCity"].stringValue
              self.propertyAddressLabel.text =  tempProperty["propertyAddress"].stringValue
              let propertyType = tempProperty["propertyType"].stringValue
              
              self.propertyList = PropertyList()
              
              self.propertyList!.propertyID =  tempProperty["propertyID"].stringValue
              self.propertyList!.propertyType = tempProperty["propertyType"].stringValue
              self.propertyList!.propertyTitle = tempProperty["propertyTitle"].stringValue
              self.propertyList!.propertyDesignName = tempProperty["propertyDesignName"].stringValue
              self.propertyList!.propertyAddress = tempProperty["propertyAddress"].stringValue
              self.propertyList!.propertyCity = tempProperty["propertyCity"].stringValue
              self.propertyList!.propertyState = tempProperty["propertyState"].stringValue
              self.propertyList!.propertyZipCode = tempProperty["propertyZipCode"].stringValue
              self.propertyList!.propertyPhoto = tempProperty["propertyPhoto"].stringValue
              self.propertyList!.propertyCustomerName = tempProperty["propertyCustomerName"].stringValue
              self.propertyList!.propertyPhoneNumber = tempProperty["propertyPhoneNumber"].stringValue
              self.propertyList!.propertyEmailId = tempProperty["propertyEmailId"].stringValue
              if propertyType == "Single"
              {
                self.propertyTypeImageView.image = UIImage(named: "ic_single")
              }
              else if propertyType == "Multi"
              {
                self.propertyTypeImageView.image = UIImage(named: "ic_multi")
              }
              else
              {
                self.propertyTypeImageView.image = UIImage(named: "ic_commercial")
              }
            }
          }
        }
      }
    }
    else if webServiceType == .DELETE_CUSTOMER_PROPERTY
    {
      if let jsonStr = try? JSON(parseJSON: responseString)
      {
        //        let  tempErrorCode = jsonStr["status"].stringValue
        let propertyData = jsonStr["data"].dictionary
        let message = propertyData!["message"]!.string
        //if tempErrorCode == "1"
        if message == "Property Deleted Successfully"
        {
          DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
          }
        }
      }
    }
  }
  
  func failerResponse(responseData: Data, webServiceType: WebServiceType)
  {
    
  }
}

extension CustomerPropertyDetailVC: SidePanelViewControllerDelegate {
  func didSelectRow(selectedRow: Int) {
   
  }
}

extension CustomerPropertyDetailVC:UIPopoverPresentationControllerDelegate
{
  func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
    // return UIModalPresentationStyle.FullScreen
    return UIModalPresentationStyle.none
  }
}

extension CustomerPropertyDetailVC:ServiceSubCategoryDelegate
{
  func selectedSubCategory(selectedSubCategory: AnyObject)
  {
    if selectedSubCategory as? Int == 1
    {
      self.callWebService(webServiceType: .DELETE_CUSTOMER_PROPERTY)
    }
    else
    {
      Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(goToEditViewProperty), userInfo: nil, repeats: false)
    }
  }
}

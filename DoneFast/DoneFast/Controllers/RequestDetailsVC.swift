//
//  RequestDetailsVC.swift
//  DoneFast
//
//  Created by Ciber on 8/22/19.
//  Copyright © 2019 Ciber. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol ServiceSubCategoryDelegate
{
  func selectedSubCategory(selectedSubCategory:AnyObject)
}

class RequestDetailsVC: UIViewController,UITextFieldDelegate {

  var activityIndicator:UIActivityIndicatorView?
  @IBOutlet var tapGestureOnImageSelect: UIGestureRecognizer!
  @IBOutlet weak var propertyImagesView: UIView!
  @IBOutlet weak var photoBtn1: UIButton!
  @IBOutlet weak var photoBtn2: UIButton!
  @IBOutlet weak var photoBtn3: UIButton!
  @IBOutlet weak var photoBtn4: UIButton!
  @IBOutlet weak var photoBtn5: UIButton!
  @IBOutlet weak var photoBtn6: UIButton!
  @IBOutlet weak var subCategoryBtn: UIButton!
  @IBOutlet weak var subCatSelectArrowBtn: UIButton!
  @IBOutlet weak var chooseServiceLabel: UILabel!
  @IBOutlet weak var notesTextField: UITextField!
  var customerLoginDetails:UserLoginDetails? = nil
  var propertyId:String?
  var selectedService = 1
  var serviceSubCategoryList:[ServiceSubCatogary] = []
  var selectedSubCategory:ServiceSubCatogary?
  var delegate: CenterViewControllerDelegate?
  var clickedImageSelection = -1
  
  @IBOutlet weak var selectImageStackView: UIStackView!
  var imagePickerController = UIImagePickerController()
  override func viewDidLoad()
  {
      super.viewDidLoad()
      self.propertyImagesView.isHidden = true
      self.selectImageStackView.isHidden = false
      tapGestureOnImageSelect.delegate = self
      activityIndicator = UIActivityIndicatorView(frame: CGRect(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2, width: 37, height: 37))
      activityIndicator?.style = .whiteLarge
      activityIndicator?.hidesWhenStopped = true
      activityIndicator?.isHidden = true
      self.view.addSubview(activityIndicator!)
      // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if self.selectedService == 2
    {
      self.callWebService(webServiceType: .SERVICE_SUB_CATEGORY)
    }
    else
    {
      subCategoryBtn.isHidden = true
      chooseServiceLabel.isHidden = true
      subCatSelectArrowBtn.isHidden = true
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  // MARK: Button actions
  @IBAction func clearImagesClicked(_ sender: Any)
  {
    photoBtn1.setImage(UIImage(named: "ic_add_images"), for: .normal)
    photoBtn2.setImage(UIImage(named: "ic_add_images"), for: .normal)
    photoBtn3.setImage(UIImage(named: "ic_add_images"), for: .normal)
    photoBtn4.setImage(UIImage(named: "ic_add_images"), for: .normal)
    photoBtn5.setImage(UIImage(named: "ic_add_images"), for: .normal)
    photoBtn6.setImage(UIImage(named: "ic_add_images"), for: .normal)
    clickedImageSelection = -1
  }
  @IBAction func leftPanelClicked(_ sender: Any)
  {
    delegate?.toggleLeftPanel()
  }
  
  @IBAction func submitClicked(_ sender: Any)
  {
    self.callWebService(webServiceType: .JOB_REQUEST)
  }
  
  @IBAction func subCategoryServiceClicked(_ sender: Any)
  {
    // get a reference to the view controller for the popover
    let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubCategoryServiceVC") as? SubCategoryServiceVC
    // set the presentation style
    popController!.modalPresentationStyle = UIModalPresentationStyle.popover
    popController?.popOverType = .ServiceSubCategory
    popController?.serviceListArray = self.serviceSubCategoryList
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
  
  
  @IBAction func selectPhotosClicked(_ sender: Any)
  {
    imagePickerController.delegate = self
    imagePickerController.allowsEditing = false
    imagePickerController.sourceType = .photoLibrary
    let senderBtn = sender as? UIButton
    self.clickedImageSelection = senderBtn!.tag
    self.navigationController?.present(imagePickerController, animated: true, completion: nil)
  }
  
  func callWebService(webServiceType:WebServiceType)
  {
    guard let tokenStr = UserLoginDetails.shared.token else { return }
    WebServices.sharedWebServices.delegate = self
    if webServiceType == .JOB_REQUEST
    {
      guard let propertyId = self.propertyId else { return }
      guard let userId = UserLoginDetails.shared.userID else { return }
      
      if clickedImageSelection == -1
      {
        let alertController = UIAlertController(title: "", message: "Please select photo of property.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        return
      }
      let imageData = photoBtn1.imageView?.image
      let imageParameters = ["image1"]
      let imageDataParameters = [imageData]
      let notes = notesTextField.text ?? ""
      var subCategoryId = ""
      
      if selectedService == 2
      {
        if let tempSubCategoryId = self.selectedSubCategory?.id
        {
          subCategoryId = tempSubCategoryId
        }
      }
      subCategoryId = ""
        let tempSelectedService = String(self.selectedService)
        
      let parameters = ["customer_id": userId,  "property_id": propertyId,"service_id": tempSelectedService,"service_subid": subCategoryId,"service_notes": notes] as [String : Any]
      self.view.isUserInteractionEnabled = false
      activityIndicator?.isHidden = false
      activityIndicator?.startAnimating()
      WebServices.sharedWebServices.uploadusingUrlSessionNormalDataWithImage(webServiceParameters: parameters as [String : Any], methodType: .POST, webServiceType: .JOB_REQUEST, token: tokenStr, imagesString: imageParameters, imageDataArray: imageDataParameters as! [UIImage])
    }
    else
    {
      let parameters = ["serviceId": self.selectedService]
      self.view.isUserInteractionEnabled = false
      WebServices.sharedWebServices.uploadusingUrlSessionNormalData(webServiceParameters: parameters, methodType: .POST, webServiceType: .SERVICE_SUB_CATEGORY, token: tokenStr)
    }
  }
}

extension RequestDetailsVC:WebServiceDelegate
{
  func successResponse(responseString: String, webServiceType: WebServiceType)
  {
    DispatchQueue.main.async {
      self.view.isUserInteractionEnabled = true
      self.activityIndicator?.stopAnimating()
      self.activityIndicator?.isHidden = true
    }
    if webServiceType == .JOB_REQUEST
    {
      if let jsonStr = try? JSON(parseJSON: responseString)
      {
        //        let  tempErrorCode = jsonStr["status"].stringValue
        let jsonData = jsonStr["data"].dictionary
        let message = jsonData!["message"]!.string
        //if tempErrorCode == "1"
        if message == "Request sent successfully."
        {
          DispatchQueue.main.async {
            let controllerArray = self.navigationController?.viewControllers
            if controllerArray!.count > 0
            {
              for controller in controllerArray!
              {
                if (controller.isKind(of: CustomerPropertyListVC.self))
                {
                  self.navigationController?.popToViewController(controller, animated: true)
                  break
                }
              }
            }
          }
        }
      }
    }
    else if webServiceType == .SERVICE_SUB_CATEGORY
    {
      if let jsonStr = try? JSON(parseJSON: responseString)
      {
        //        let  tempErrorCode = jsonStr["status"].stringValue
        let jsonData = jsonStr["data"].dictionary
        let message = jsonData!["message"]!.string
        //if tempErrorCode == "1"
        if message == "List of sub services"
        {
          let serviceList = jsonData!["serviceList"]?.arrayValue
          if serviceList!.count > 0
          {
            for tempDict in serviceList!
            {
              let serviceSubModel = ServiceSubCatogary()
              serviceSubModel.id = tempDict["id"].stringValue
              serviceSubModel.name = tempDict["name"].stringValue
              self.serviceSubCategoryList.append(serviceSubModel)
            }
          }
        }
      }
    }
  }
  
  func failerResponse(responseData: String, webServiceType: WebServiceType)
  {
    DispatchQueue.main.async {
      self.view.isUserInteractionEnabled = true
      self.activityIndicator?.stopAnimating()
      self.activityIndicator?.isHidden = true
    }
  }
}

extension RequestDetailsVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate
{
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      
      
      switch (self.clickedImageSelection)
      {
      case 1:
        photoBtn1.contentMode = .scaleAspectFit
        photoBtn1.setImage(pickedImage, for: .normal)
        break
      case 2:
        photoBtn2.contentMode = .scaleAspectFit
        photoBtn2.setImage(pickedImage, for: .normal)
        break
      case 6:
        photoBtn6.contentMode = .scaleAspectFit
        photoBtn6.setImage(pickedImage, for: .normal)
        break
      case 3:
        photoBtn3.contentMode = .scaleAspectFit
        photoBtn3.setImage(pickedImage, for: .normal)
        break
      case 4:
        photoBtn4.contentMode = .scaleAspectFit
        photoBtn4.setImage(pickedImage, for: .normal)
        break
      case 5:
        photoBtn5.contentMode = .scaleAspectFit
        photoBtn5.setImage(pickedImage, for: .normal)
        break
      default:
        break
      }
      
      self.propertyImagesView.isHidden = false
//      self.selectImageStackView.isHidden = true
      self.selectImageStackView.isHidden = true
    }
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
  {
    dismiss(animated: true, completion: nil)
  }
}

extension RequestDetailsVC:UIPopoverPresentationControllerDelegate
{
  func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
    // return UIModalPresentationStyle.FullScreen
    return UIModalPresentationStyle.none
  }
}

extension RequestDetailsVC:ServiceSubCategoryDelegate
{
  func selectedSubCategory(selectedSubCategory: AnyObject)
  {
    let tempSelectedCategory = selectedSubCategory as? ServiceSubCatogary
    print(tempSelectedCategory!.name as Any)
    self.subCategoryBtn.setTitle(tempSelectedCategory!.name, for: .normal)
    self.selectedSubCategory = tempSelectedCategory
  }
}

extension RequestDetailsVC: SidePanelViewControllerDelegate {
  func didSelectRow(selectedRow: Int)
  {
  }
}

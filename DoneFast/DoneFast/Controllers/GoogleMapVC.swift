//
//  GoogleMapVC.swift
//  DoneFast
//
//  Created by Ciber on 9/7/19.
//  Copyright © 2019 Ciber. All rights reserved.
//

import UIKit
import SwiftyJSON
import GoogleMaps

class GoogleMapVC: UIViewController {

    var mapVC:MapViewController?
    var activityIndicator:UIActivityIndicatorView?
    @IBOutlet weak var googleMapView: UIView!
    var propertyLocation:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
    
    override func viewDidLoad()
  {
    super.viewDidLoad()
      // Do any additional setup after loading the view.
  }
  
    var customerAddProperty:CustomerAddProperty?
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.loadGoogleMap()
//    Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(loadGoogleMap), userInfo: nil, repeats: false)
  }
  
    @objc func loadGoogleMap()
    {
        if self.mapVC == nil
        {
            guard let mapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as? MapViewController
                else
            {
                return
            }
            self.mapVC = mapVC
            self.googleMapView.addSubview(mapVC.view)
            self.mapVC!.view.frame = self.googleMapView.frame
            self.mapVC!.mapView?.frame = CGRect(x: 0, y: 0, width: self.googleMapView.frame.size.width, height: self.googleMapView.frame.size.height)
            self.mapVC!.mapView?.delegate = self
//            self.propertyLocation = self.mapVC?.mapView?.myLocation?.coordinate
        }
    }
    

    @IBAction func goBackClicked(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitClicked(_ sender: Any)
    {
        guard let userId =  UserLoginDetails.shared.userID else { return }
        guard let propertyDesign = customerAddProperty?.propertyDesign else { return}
        guard let propertyEmailId = customerAddProperty?.propertyEmailId else { return }
        guard let propertyPhoneNumber = customerAddProperty?.propertyPhoneNumber else { return }
        guard let propertyAddress = customerAddProperty?.propertyAddress else { return}
        guard let propertyCity = customerAddProperty?.propertyCity else { return}
        guard let propertyState = customerAddProperty?.propertyState else { return}
        guard let propertyZipCode = customerAddProperty?.propertyZipCode else { return}
        guard let selectedProperty = customerAddProperty?.selectedProperty else { return }
        guard let propertyCustomerName = customerAddProperty?.name else { return }
//        guard let tempLocation =  propertyLocation else {
//            return
//        }
       
        let tempPropertyLocation = String(format: "%0.2f,%0.2f",propertyLocation.latitude, propertyLocation.longitude)
        let parameters = ["userID":userId,"propertyType":selectedProperty,"propertyDesign":propertyDesign,"propertyCustomerName":propertyCustomerName,"propertyEmailId":propertyEmailId, "propertyPhoneNumber":propertyPhoneNumber,"propertyAddress":propertyAddress,"propertyCity":propertyCity,"propertyState":propertyState, "propertyZipCode":propertyZipCode,"propertyLocation":tempPropertyLocation]
        guard let tokenStr = UserLoginDetails.shared.token else { return }
        self.view.isUserInteractionEnabled = false
        activityIndicator?.isHidden = false
        activityIndicator?.startAnimating()
        WebServices.sharedWebServices.delegate = self
        WebServices.sharedWebServices.uploadusingUrlSessionNormalData(webServiceParameters: parameters as [String : Any], methodType: .POST, webServiceType: .ADD_CUSTOMER_PROPERTY, token: tokenStr)
    }
}

extension GoogleMapVC:WebServiceDelegate
{
  func successResponse(responseString: String, webServiceType: WebServiceType)
  {
    DispatchQueue.main.async {
      self.view.isUserInteractionEnabled = true
      self.activityIndicator?.stopAnimating()
      self.activityIndicator?.isHidden = true
    }
    
    if webServiceType == .ADD_CUSTOMER_PROPERTY
    {
      if let jsonStr = try? JSON(parseJSON: responseString)
      {
//        let  tempErrorCode = jsonStr["status"].stringValue
        let propertyData = jsonStr["data"].dictionary
        let message = propertyData!["message"]!.string
        //if tempErrorCode == "1"
        if message == "Property Added Successfully"
        {
          let alertController:UIAlertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
          //            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: ))
          alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
//            self.navigateToListCustomerProperty()
            DispatchQueue.main.async {
              self.navigationController?.popToRootViewController(animated: true)
            }
          }))
          DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
          }
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

extension GoogleMapVC:GMSMapViewDelegate
{
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker)
    {
        print(marker.position.latitude as Any)
        print(marker.position.longitude as Any)
        let locationCoordinates = CLLocationCoordinate2D(latitude: marker.position.latitude, longitude: marker.position.longitude)
        self.propertyLocation = locationCoordinates
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.propertyLocation = coordinate
    }
}

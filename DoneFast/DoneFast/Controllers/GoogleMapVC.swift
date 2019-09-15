//
//  GoogleMapVC.swift
//  DoneFast
//
//  Created by Ciber on 9/7/19.
//  Copyright © 2019 Ciber. All rights reserved.
//

import UIKit
import GoogleMaps

class GoogleMapVC: UIViewController {

  @IBOutlet weak var googleMapView: GMSMapView!
//    override func viewDidLoad()
//  {
//    super.viewDidLoad()
//      // Do any additional setup after loading the view.
//  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
//    let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
//    self.googleMapView = GMSMapView.map(withFrame: googleMapView.frame, camera: camera)
//    self.googleMapView.isMyLocationEnabled = true
    // Creates a marker in the center of the map.
//    let marker = GMSMarker()
//    marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//    marker.title = "Sydney"
//    marker.snippet = "Australia"
//    marker.map = self.googleMapView
  }
  // You don't need to modify the default init(nibName:bundle:) method.
  
  
  override func loadView() {
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 3.0)
    let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
    mapView.isMyLocationEnabled = true
    self.view = mapView
    
    // Creates a marker in the center of the map.
    let marker = GMSMarker()
    marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
    marker.title = "Sydney"
    marker.snippet = "Australia"
    marker.map = mapView
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

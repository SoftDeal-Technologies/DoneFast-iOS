//
//  MapViewController.swift
//  DoneFast
//
//  Created by Ciber on 10/9/19.
//  Copyright © 2019 Ciber. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    var mapView:GMSMapView?
    
    override func loadView()
    {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 10.0)
//        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera) //let
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera) //let
        mapView!.isMyLocationEnabled = true
        
//        print(self.parent ?? "test")
//        mapView.delegate = (self.parent as! GMSMapViewDelegate)
        self.view = mapView
//        mapView?.frame = CGRect(x: 0, y: 0, width: (mapView?.frame.size.width)!, height: (mapView?.frame.size.height)!)
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)//  marker.position = CLLocationCoordinate2D(latitude: (mapView.myLocation?.coordinate.latitude)!, longitude: (mapView.myLocation?.coordinate.longitude)!)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
        marker.isDraggable = true
        marker.map = mapView
    }
}

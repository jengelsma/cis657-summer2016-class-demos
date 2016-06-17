//
//  ViewController.swift
//  Lecture15-MapDemo
//
//  Created by Jonathan Engelsma on 6/16/16.
//  Copyright © 2016 Jonathan Engelsma. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let camera = GMSCameraPosition.cameraWithLatitude(42.96356,
                                                          longitude: -85.88990, zoom: 18)
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        self.view = mapView
        mapView.delegate = self
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(42.96356, -85.8899)
        marker.title = "GVSU"
        marker.snippet = "Allendale, MI"
        marker.map = mapView

        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.delegate = self
        self.handleLocationPermissions()
    }
    
    
    func handleLocationPermissions()
    {
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedWhenInUse, .AuthorizedAlways:
            print("already authorized, let's go!")
        case .NotDetermined:
            self.locationManager.requestWhenInUseAuthorization()
        case  .Restricted, .Denied:
            let alertController = UIAlertController(
                title: "Location permissions not enabled!",
                message: "In order to show you your current location, you need to allow location services to be enabled when this app is in use.  Go to the settings and select 'While Using The App'.",
                preferredStyle: .Alert)
            
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            
            let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            alertController.addAction(openAction)
            
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        
    }

    func locationManager(manager: CLLocationManager,
                         didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        print("authorization changed")
        let mapView = self.view as! GMSMapView
        if (CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse) {
            mapView.settings.myLocationButton = true
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = 10.0
            locationManager.startUpdatingLocation()
            
        } else {
            mapView.settings.myLocationButton = false
        }
    }
    
    
    func locationManagerDidResumeLocationUpdates(manager: CLLocationManager) {
        print("updates resumed")
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations[0]
        
        
        print("(location = (\(location.coordinate.latitude), \(location.coordinate.longitude) speed = \(location.speed))")
        
        
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
        
        
        let alertController = UIAlertController(title: "Fancy Maps", message: "You must go to GVSU!", preferredStyle: .Alert)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            print("Congrats, you canceled")
        }
        alertController.addAction(cancelAction)
        
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            print("Congrats, you thought that was ok")
        }
        alertController.addAction(OKAction)
        
        
        self.presentViewController(alertController, animated: true) {
            print("Dialog should now be onscreen!")
        }
        
        
    }


}


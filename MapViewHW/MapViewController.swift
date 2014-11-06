//
//  MapViewController.swift
//  MapViewHW
//
//  Created by Shiquan Fu on 11/3/14.
//  Copyright (c) 2014 Tina Fu. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var locationManager : CLLocationManager!
    

    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "regionAdded:", name: "REGION_ADDED", object: nil)
        let longPress = UILongPressGestureRecognizer(target: self, action: "didLongPressMap:")
        self.mapView.addGestureRecognizer(longPress)
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.locationManager = appDelegate.locationManager
        self.locationManager.delegate = self
        self.mapView.delegate = self
        


                
        switch CLLocationManager.authorizationStatus() as CLAuthorizationStatus {
        case .Authorized:
            println("authorized")
            //self.locationManager.startUpdatingLocation()
            self.mapView.showsUserLocation = true
        case .NotDetermined:
            println("not determined")
            self.locationManager.requestAlwaysAuthorization()
        case .Restricted:
            println("restricted")
        case .Denied:
            println("denied")
        default:
            println("default")
        }

        // Do any additional setup after loading the view.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func didLongPressMap (sender : UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Began {
            let touchPoint = sender.locationInView(self.mapView)
            let touchCoordinate = self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
            println("\(touchCoordinate.latitude) \(touchCoordinate.longitude)")
            var annotation = MKPointAnnotation()
            annotation.coordinate = touchCoordinate
            annotation.title = "Add Region"
            self.mapView.addAnnotation(annotation)
        }
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "ANNOTATION")
        annotationView.animatesDrop = true
        annotationView.canShowCallout = true
        let addButton = UIButton.buttonWithType(UIButtonType.ContactAdd) as UIButton
        annotationView.rightCalloutAccessoryView = addButton
        return annotationView
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        let regionVC = self.storyboard?.instantiateViewControllerWithIdentifier("ADDREGION_VC") as AddRegionViewController
        regionVC.locationManager = self.locationManager
        regionVC.selectedAnnotation = view.annotation
        self.presentViewController(regionVC, animated: true, completion: nil)
        
    }
    // render the overlay
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        let renderer = MKCircleRenderer(overlay: overlay)
        renderer.fillColor = UIColor.purpleColor().colorWithAlphaComponent(0.20)
        //renderer.strokeColor = UIColor.blackColor()
        return renderer
    }


    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        println("great success!")
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        println("left region")
    }
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .Authorized:
            println("changed to authorized")
            //self.locationManager.startUpdatingLocation()
        default:
            println("default on authorization change")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("we got a location update!")
        
        if let location = locations.last as? CLLocation {
            println(location.coordinate.latitude)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func regionAdded(notification : NSNotification) {
        println("region added!")
        let userInfo = notification.userInfo!
        let geoRegion = userInfo["region"] as CLCircularRegion
        
        let overlay = MKCircle(centerCoordinate: geoRegion.center, radius: geoRegion.radius)
        self.mapView.addOverlay(overlay)
        
    }

    
}

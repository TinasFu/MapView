//
//  AddRegionViewController.swift
//  MapViewHW
//
//  Created by Shiquan Fu on 11/3/14.
//  Copyright (c) 2014 Tina Fu. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class AddRegionViewController: UIViewController, MKMapViewDelegate {
    
    var locationManager : CLLocationManager!
    var selectedAnnotation : MKAnnotation!
    var dataController : DataController!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var textView: UITextField!
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let regionSet : NSSet = self.locationManager.monitoredRegions
        let regions : AnyObject = regionSet.allObjects
        println(regions.count)
        
        let mapCamera = MKMapCamera(lookingAtCenterCoordinate: selectedAnnotation.coordinate, fromEyeCoordinate: selectedAnnotation.coordinate, eyeAltitude: 8000)
        self.mapView.addAnnotation(selectedAnnotation)
        self.mapView.setCamera(mapCamera, animated: true)

        // Do any additional setup after loading the view.
        // make a reference of AppDelegate and pass the managedObjectContext to DataController

        self.dataController = DataController()
    }
    
    @IBAction func cancel(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    @IBAction func addRegion(sender: AnyObject) {
        let name = self.textView.text
        var geoRegion = CLCircularRegion(center: selectedAnnotation.coordinate, radius: 100.0, identifier: "\(name)")
        self.locationManager.startMonitoringForRegion(geoRegion)
        NSNotificationCenter.defaultCenter().postNotificationName("REGION_ADDED", object: self, userInfo: ["region" : geoRegion])
    
        //Add to Core Data
        self.dataController.insertRegionData(geoRegion!)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

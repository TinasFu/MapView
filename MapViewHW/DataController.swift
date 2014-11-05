//
//  DataController.swift
//  MapViewHW
//
//  Created by Shiquan Fu on 11/4/14.
//  Copyright (c) 2014 Tina Fu. All rights reserved.
//

import Foundation
import MapKit
import CoreData

class DataController {
    var managedObjectContext : NSManagedObjectContext!
    
    init() {
        
        var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate

        self.managedObjectContext = appDelegate.managedObjectContext
    }
    
    func insertRegionData(region: CLCircularRegion!) {
        var time = NSDate()
        var newRegion = NSEntityDescription.insertNewObjectForEntityForName("Region", inManagedObjectContext: self.managedObjectContext) as Region
        newRegion.name = region.identifier
        newRegion.radius = region.radius
        newRegion.longitude = region.center.longitude
        newRegion.latitude = region.center.latitude
        newRegion.date = time
        
    }

    
}

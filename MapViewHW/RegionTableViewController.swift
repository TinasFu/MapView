//
//  RegionTableViewController.swift
//  MapViewHW
//
//  Created by Shiquan Fu on 11/5/14.
//  Copyright (c) 2014 Tina Fu. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class RegionTableViewController: UIViewController, UITableViewDataSource, NSFetchedResultsControllerDelegate, CLLocationManagerDelegate  {
    
    var managedObjectContext : NSManagedObjectContext!
    var fetchedResultsController : NSFetchedResultsController!
    var locationManager : CLLocationManager!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.locationManager = appDelegate.locationManager
        self.locationManager.delegate = self
//        let regionSet = self.locationManager.monitoredRegions
//        let regions = regionSet.allObjects
//        
//        if regions.count == 0 {
//            var fetchRequest = NSFetchRequest(entityName: "Region")
//            self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Regions")
//            for anyObject in self.fetchedResultsController.fetchedObjects! {
//                NSFileManager.delete(anyObject)
//            }
//            
//        }
        
        self.managedObjectContext = appDelegate.managedObjectContext
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didGetCloudChanges:", name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: appDelegate.persistentStoreCoordinator)
        
        var fetchRequest = NSFetchRequest(entityName: "Region")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: "Regions")
        self.fetchedResultsController.delegate = self
        
        var error : NSError?
        if !self.fetchedResultsController.performFetch(&error) {
            println(error?.localizedDescription)
        }
        // Do any additional setup after loading the view.
    }

    func didGetCloudChanges(notification : NSNotification) {
        self.managedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
        
    }
    
    //?????????????????????
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("REGION_CELL", forIndexPath: indexPath) as UITableViewCell
        let region = self.fetchedResultsController.fetchedObjects?[indexPath.row] as Region
        cell.textLabel.text = region.name
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            
            //remove region from monitoredRegions through location manager
            println("number of monitored regions before removing:\(self.locationManager.monitoredRegions.allObjects.count)")
            let geoRegion = self.fetchedResultsController.objectAtIndexPath(indexPath) as Region
            for region in self.locationManager.monitoredRegions {
                if (region.identifier == geoRegion.name) {
                    self.locationManager.stopMonitoringForRegion(region as CLRegion)
                    println("number of monitored regions after removing:\(self.locationManager.monitoredRegions.allObjects.count)")
                }
                
            }
            
            //delete region from core data and tableview
            let context = self.fetchedResultsController.managedObjectContext
            context.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject)
            
            
            
            var error: NSError? = nil
            if !context.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                println("Unresolved error \(error?.localizedDescription)")
                abort()
            }
        }
    }

    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData()
    }
    
}


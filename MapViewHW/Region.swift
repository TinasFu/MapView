//
//  Region.swift
//  MapViewHW
//
//  Created by Shiquan Fu on 11/4/14.
//  Copyright (c) 2014 Tina Fu. All rights reserved.
//

import Foundation
import CoreData

class Region: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var date: NSDate
    @NSManaged var radius: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var latitude: NSNumber

}

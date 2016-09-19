//
//  Menu+CoreDataProperties.swift
//  RANE_App
//
//  Created by cape start on 29/08/16.
//  Copyright © 2016 capestart. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Menu {

    @NSManaged var menuId: NSNumber
    @NSManaged var menuName: String
    @NSManaged var menuIconURL: String
    @NSManaged var companyId: NSNumber

}

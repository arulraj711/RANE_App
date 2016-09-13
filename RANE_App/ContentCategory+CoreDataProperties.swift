//
//  ContentCategory+CoreDataProperties.swift
//  RANE_App
//
//  Created by cape start on 13/09/16.
//  Copyright © 2016 capestart. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ContentCategory {

    @NSManaged var contentCategoryId: String
    @NSManaged var contentCategoryName: String

}

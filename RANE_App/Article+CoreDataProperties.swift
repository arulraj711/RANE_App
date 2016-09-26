//
//  Article+CoreDataProperties.swift
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

extension Article {

    @NSManaged var articleId: String
    @NSManaged var articleDescription: String
    @NSManaged var articleDetailedDescription: String
    @NSManaged var articleURL: String
    @NSManaged var articleTitle: String
    @NSManaged var articleTypeId: NSNumber
    @NSManaged var companyId: NSNumber
    @NSManaged var articlepublishedDate: Double
    @NSManaged var articleModifiedDate: Double
    @NSManaged var isSavedForLater: NSNumber
    @NSManaged var isMarkedImportant: NSNumber
    @NSManaged var contentTypeId: NSNumber
    @NSManaged var contentCategoryId: NSNumber
    @NSManaged var pageNo: NSNumber
    @NSManaged var fieldsName: String
    @NSManaged var outletName: String
    @NSManaged var contactName: String
    @NSManaged var markAsImportantUserName: String
    @NSManaged var markAsImportantUserId: NSNumber

}

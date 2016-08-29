//
//  CoreDataController.swift
//  RANE_App
//
//  Created by cape start on 29/08/16.
//  Copyright © 2016 capestart. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData


class CoreDataController {
    
    
    func addMenu(menuJSON:JSON) {
        
        //1 get managedcontext from appdelegate Object
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2 set predicate value
        let fetchRequest = NSFetchRequest(entityName: "Menu")
        fetchRequest.predicate = NSPredicate(format: "menuId == %@",menuJSON["id"].stringValue)
        print("predicate",fetchRequest)
        
        do {
        
            let results =
                try managedContext.executeFetchRequest(fetchRequest) as! [Menu]
            if results.count != 0{
                let menu = results[0] as Menu
                
                menu.setValue(menuJSON["id"].intValue, forKey: "menuId")
                menu.setValue(menuJSON["name"].stringValue.capitalizedString, forKey: "menuName")
                menu.setValue(menuJSON["iconUrl"].stringValue, forKey: "menuIconURL")
                menu.setValue(menuJSON["companyId"].intValue, forKey: "companyId")
                try menu.managedObjectContext?.save()
                
            } else {
                // Create Entity
                let entity = NSEntityDescription.entityForName("Menu", inManagedObjectContext: managedContext)
                
                // Initialize Record
                let record = Menu(entity: entity!, insertIntoManagedObjectContext: managedContext)
                //let record = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
                
                print("menu json",menuJSON)
                print("menu name",menuJSON["name"].stringValue)
                
                // Populate Record
                record.setValue(menuJSON["id"].intValue, forKey: "menuId")
                record.setValue(menuJSON["name"].stringValue.capitalizedString, forKey: "menuName")
                record.setValue(menuJSON["iconUrl"].stringValue, forKey: "menuIconURL")
                record.setValue(menuJSON["companyId"].intValue, forKey: "companyId")
                // Save Record
                try record.managedObjectContext?.save()
            }
            
            
            // Dismiss View Controller
            
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
    }
    
    func addArticle(articleJSON:JSON,contentTypeId:Int,pageNo:Int) {
        //1 get managedcontext from appdelegate Object
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2 set predicate value
        let fetchRequest = NSFetchRequest(entityName: "Article")
        fetchRequest.predicate = NSPredicate(format: "articleId == %@ AND contentTypeId == %@",articleJSON["id"].stringValue,String(contentTypeId))
        
        do {
            
            let results =
                try managedContext.executeFetchRequest(fetchRequest) as! [Article]
            if results.count != 0{
                let article = results[0] as Article
                
                article.setValue(articleJSON["id"].stringValue, forKey: "articleId")
                article.setValue(articleJSON["articleDescription"].stringValue.capitalizedString, forKey: "articleDescription")
                article.setValue(articleJSON["articleDetailedDescription"].stringValue, forKey: "articleDetailedDescription")
                article.setValue(articleJSON["articleURL"].stringValue, forKey: "articleURL")
                article.setValue(articleJSON["heading"].stringValue, forKey: "articleTitle")
                article.setValue(articleJSON["articleTypeId"][0].intValue, forKey: "articleTypeId")
                article.setValue(articleJSON["companyId"].intValue, forKey: "companyId")
                article.setValue(articleJSON["publishedDate"].double, forKey: "articlepublishedDate")
                article.setValue(articleJSON["modifiedDate"].double, forKey: "articleModifiedDate")
                article.setValue(articleJSON["saveForLater"].intValue, forKey: "isSavedForLater")
                article.setValue(articleJSON["markAsImportant"].intValue, forKey: "isMarkedImportant")
                article.setValue(contentTypeId, forKey: "contentTypeId")
                article.setValue(pageNo, forKey: "pageNo")
                
                try article.managedObjectContext?.save()
                
            } else {
                // Create Entity
                let entity = NSEntityDescription.entityForName("Article", inManagedObjectContext: managedContext)
                
                // Initialize Record
                let article = Article(entity: entity!, insertIntoManagedObjectContext: managedContext)
                //let record = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
                
                article.setValue(articleJSON["id"].stringValue, forKey: "articleId")
                article.setValue(articleJSON["articleDescription"].stringValue.capitalizedString, forKey: "articleDescription")
                article.setValue(articleJSON["articleDetailedDescription"].stringValue, forKey: "articleDetailedDescription")
                article.setValue(articleJSON["articleURL"].stringValue, forKey: "articleURL")
                article.setValue(articleJSON["heading"].stringValue, forKey: "articleTitle")
                article.setValue(articleJSON["articleTypeId"][0].intValue, forKey: "articleTypeId")
                article.setValue(articleJSON["companyId"].intValue, forKey: "companyId")
                article.setValue(articleJSON["publishedDate"].double, forKey: "articlepublishedDate")
                article.setValue(articleJSON["modifiedDate"].double, forKey: "articleModifiedDate")
                article.setValue(articleJSON["saveForLater"].intValue, forKey: "isSavedForLater")
                article.setValue(articleJSON["markAsImportant"].intValue, forKey: "isMarkedImportant")
                article.setValue(contentTypeId, forKey: "contentTypeId")
                article.setValue(pageNo, forKey: "pageNo")
                try article.managedObjectContext?.save()
            }
            
            
            // Dismiss View Controller
            
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
        
    }
    
    
    func updateMarkedImportantStatusInArticle(artilceId:String,isMarked:Int) {
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2 set predicate value
        let fetchRequest = NSFetchRequest(entityName: "Article")
        fetchRequest.predicate = NSPredicate(format: "articleId == %@",artilceId)
        do {
            
            let results =
                try managedContext.executeFetchRequest(fetchRequest) as! [Article]
            if results.count != 0{
                let article = results[0] as Article
                article.setValue(isMarked, forKey: "isMarkedImportant")
                try article.managedObjectContext?.save()
            }
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
    }

    func updateSavedForLaterStatusInArticle(artilceId:String,isSaved:Int) {
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2 set predicate value
        let fetchRequest = NSFetchRequest(entityName: "Article")
        fetchRequest.predicate = NSPredicate(format: "articleId == %@",artilceId)
        do {
            
            let results =
                try managedContext.executeFetchRequest(fetchRequest) as! [Article]
            if results.count != 0{
                let article = results[0] as Article
                article.setValue(isSaved, forKey: "isMarkedImportant")
                try article.managedObjectContext?.save()
            }
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
    }
    
    
    
    func updateMenuInfoInCoreData(menuJSON:JSON) {
        //1 get managedcontext from appdelegate Object
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2 set predicate value
        let fetchRequest = NSFetchRequest(entityName: "Menu")
        fetchRequest.predicate = NSPredicate(format: "menuId == %@",menuJSON["id"].stringValue)
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            if results.count != 0{
                let managedObject = results[0]
                
                managedObject.setValue(menuJSON["id"].intValue, forKey: "menuId")
                managedObject.setValue(menuJSON["name"].stringValue.capitalizedString, forKey: "menuName")
                managedObject.setValue(menuJSON["iconUrl"].stringValue, forKey: "menuIconURL")
                managedObject.setValue(menuJSON["companyId"].intValue, forKey: "companyId")
            } else {
                if let entity = NSEntityDescription.entityForName("Menu", inManagedObjectContext: managedContext) {
                let user = NSManagedObject(entity: entity,
                                           insertIntoManagedObjectContext: managedContext)
                
                //3 set the values in user object
                user.setValue(menuJSON["id"].intValue, forKey: "menuId")
                user.setValue(menuJSON["name"].stringValue.capitalizedString, forKey: "menuName")
                user.setValue(menuJSON["iconUrl"].stringValue, forKey: "menuIconURL")
                user.setValue(menuJSON["companyId"].intValue, forKey: "companyId")
                }
            }
            try managedContext.save()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func getEntityInfoFromCoreData(entityName:String) -> [Menu] {
        var entityResult = [Menu]()
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: entityName)
        
        //3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest) as! [Menu]
            entityResult = results
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return entityResult
    }
    
    func getArticleListForContentTypeId(contentTypeId:NSNumber,pageNo:NSNumber,entityName:String) -> [Article] {
        var entityResult = [Article]()
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: entityName)
        if((pageNo.isEqualToNumber(0))) {
            fetchRequest.predicate = NSPredicate(format: "contentTypeId == %@",contentTypeId)
        } else {
            fetchRequest.predicate = NSPredicate(format: "contentTypeId == %@ AND pageNo == %@",contentTypeId,pageNo)
        }
        
        //3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest) as! [Article]
            entityResult = results
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return entityResult
    }
    
}


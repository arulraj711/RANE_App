

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
    var contentCategory: [ContentCategory]?
    func addContentCategory(contentCategoryJSON:JSON) {
        //1 get managedcontext from appdelegate Object
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2 set predicate value
        let fetchRequest = NSFetchRequest(entityName: "ContentCategory")
        fetchRequest.predicate = NSPredicate(format: "contentCategoryId == %@",contentCategoryJSON["id"].stringValue)
        //        print("predicate",fetchRequest)
        
        do {
            
            let results =
                try managedContext.executeFetchRequest(fetchRequest) as! [ContentCategory]
            if results.count != 0{
                let contentCategory = results[0] as ContentCategory
                
                contentCategory.setValue(contentCategoryJSON["nodeid"].stringValue, forKey: "contentCategoryId")
                contentCategory.setValue(contentCategoryJSON["name"].stringValue, forKey: "contentCategoryName")
                
                try contentCategory.managedObjectContext?.save()
                
            } else {
                // Create Entity
                let entity = NSEntityDescription.entityForName("ContentCategory", inManagedObjectContext: managedContext)
                
                // Initialize Record
                let contentCategory = ContentCategory(entity: entity!, insertIntoManagedObjectContext: managedContext)
                //let record = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
                
                //                print("menu json",menuJSON)
                //                print("menu name",menuJSON["name"].stringValue)
                
                // Populate Record
                contentCategory.setValue(contentCategoryJSON["nodeid"].stringValue, forKey: "contentCategoryId")
                contentCategory.setValue(contentCategoryJSON["name"].stringValue, forKey: "contentCategoryName")
                
                // Save Record
                try contentCategory.managedObjectContext?.save()
            }
            
            
            // Dismiss View Controller
            
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
    }
    
    func getContentNameFromContentTypeId(contentTypeId:Int)->String {
        print("inside",contentTypeId)
        var contentCategoryName:String!
        //1 get managedcontext from appdelegate Object
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2 set predicate value
        let fetchRequest = NSFetchRequest(entityName: "ContentCategory")
        fetchRequest.predicate = NSPredicate(format: "contentCategoryId == %@",String(contentTypeId))
        //        print("predicate",fetchRequest)
        do {
            
            let results =
                try managedContext.executeFetchRequest(fetchRequest) as! [ContentCategory]
            if results.count != 0{
                let contentCategory = results[0] as ContentCategory
                contentCategoryName = contentCategory.contentCategoryName
            }
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
        return contentCategoryName
    }
    
    
    func getMenuNameFromArticleTypeId(contentTypeId:NSNumber)->String {
        var menuName:String!
        //1 get managedcontext from appdelegate Object
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2 set predicate value
        let fetchRequest = NSFetchRequest(entityName: "Menu")
        fetchRequest.predicate = NSPredicate(format: "menuId == %@",contentTypeId)
        //        print("predicate",fetchRequest)
        do {
            
            let results =
                try managedContext.executeFetchRequest(fetchRequest) as! [Menu]
            if results.count != 0{
                let contentCategory = results[0] as Menu
                menuName = contentCategory.menuName
            }
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
        return menuName
    }
    
    func addMenu(menuJSON:JSON) {
        
        //1 get managedcontext from appdelegate Object
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2 set predicate value
        let fetchRequest = NSFetchRequest(entityName: "Menu")
        fetchRequest.predicate = NSPredicate(format: "menuId == %@",menuJSON["id"].stringValue)
//        print("predicate",fetchRequest)
        
        do {
        
            let results =
                try managedContext.executeFetchRequest(fetchRequest) as! [Menu]
            if results.count != 0{
                let menu = results[0] as Menu
                
                menu.setValue(menuJSON["id"].intValue, forKey: "menuId")
                menu.setValue(menuJSON["name"].stringValue, forKey: "menuName")
                menu.setValue(menuJSON["iconUrl"].stringValue, forKey: "menuIconURL")
                menu.setValue(menuJSON["companyId"].intValue, forKey: "companyId")
                try menu.managedObjectContext?.save()
                
            } else {
                // Create Entity
                let entity = NSEntityDescription.entityForName("Menu", inManagedObjectContext: managedContext)
                
                // Initialize Record
                let record = Menu(entity: entity!, insertIntoManagedObjectContext: managedContext)
                //let record = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
                
//                print("menu json",menuJSON)
//                print("menu name",menuJSON["name"].stringValue)
                
                // Populate Record
                record.setValue(menuJSON["id"].intValue, forKey: "menuId")
                record.setValue(menuJSON["name"].stringValue, forKey: "menuName")
                print("menu",menuJSON)
                print("menu url",menuJSON["iconUrl"].stringValue)
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
    
    func addArticle(articleJSON:JSON,contentTypeId:Int,pageNo:Int,searchText:String) {
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
                if(searchText.characters.count == 0) {
                    article.setValue(false, forKey: "isSearch")
                    
                } else {
                    article.setValue(true, forKey: "isSearch")
                }
                /* fields name configuration */
//                if let fieldsArray = articleJSON["fields"].array {
//                    var fieldsName:String = ""
//                    for fields in fieldsArray {
//                        if(fieldsName.characters.count == 0) {
//                            fieldsName = fieldsName.uppercaseString+fields["name"].stringValue.uppercaseString
//                        } else {
//                            fieldsName = fieldsName.uppercaseString+" & "+fields["name"].stringValue.uppercaseString
//                        }
//                        
//                    }
//                    article.setValue(fieldsName, forKey: "fieldsName")
//                }
                self.contentCategory = CoreDataController().getContentCategoryInfoFromCoreData("ContentCategory")
                
                /* fields name configuration */
                if let fieldsArray = articleJSON["contentCategoryId"].array {
                    var fieldsName:String = ""
                    for fields in fieldsArray {
                        print("fields",fields,CoreDataController().getContentNameFromContentTypeId(fields.int!))
                        if(fieldsName.characters.count == 0) {
                            
                            fieldsName = fieldsName.uppercaseString+CoreDataController().getContentNameFromContentTypeId(fields.int!).uppercaseString
                        } else {
                            fieldsName = fieldsName.uppercaseString+" & "+CoreDataController().getContentNameFromContentTypeId(fields.int!).uppercaseString
                        }
                        
                    }
                    article.setValue(fieldsName, forKey: "fieldsName")
                }
                
                
                /* outlet name configuration */
                if let outletArray = articleJSON["outlet"].array {
                    var outletName:String = ""
                    for outlet in outletArray {
                        if(outletName.characters.count == 0) {
                            outletName = outletName+outlet["name"].stringValue
                        } else {
                            outletName = outletName+" & "+outlet["name"].stringValue
                        }
                        
                    }
                    article.setValue(outletName, forKey: "outletName")
                }
                
                /* contact name configuration */
                if let contactArray = articleJSON["contact"].array {
                    var contactName:String = ""
                    for contact in contactArray {
                        if(contactName.characters.count == 0) {
                            contactName = contactName+contact["name"].stringValue
                        } else {
                            contactName = contactName+","+contact["name"].stringValue
                        }
                        
                    }
                    article.setValue(contactName, forKey: "contactName")
                }
                
                if let markAsImportantDic = articleJSON["markAsImportantUserDetail"].dictionary {
                    if(markAsImportantDic.count != 0) {
                        article.setValue(markAsImportantDic["userId"]?.intValue, forKey: "markAsImportantUserId")
                        article.setValue(markAsImportantDic["name"]?.stringValue, forKey: "markAsImportantUserName")
                    }
                    
                }
                
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
                if(searchText.characters.count == 0) {
                    article.setValue(false, forKey: "isSearch")
                    
                } else {
                    article.setValue(true, forKey: "isSearch")
                }
//                /* fields name configuration */
//                if let fieldsArray = articleJSON["fields"].array {
//                    var fieldsName:String = ""
//                    for fields in fieldsArray {
//                        if(fieldsName.characters.count == 0) {
//                            fieldsName = fieldsName.uppercaseString+fields["name"].stringValue.uppercaseString
//                        } else {
//                            fieldsName = fieldsName.uppercaseString+" & "+fields["name"].stringValue.uppercaseString
//                        }
//                        
//                    }
//                    article.setValue(fieldsName, forKey: "fieldsName")
//                }
                
                self.contentCategory = CoreDataController().getContentCategoryInfoFromCoreData("ContentCategory")
                
                /* fields name configuration */
                if let fieldsArray = articleJSON["contentCategoryId"].array {
                    var fieldsName:String = ""
                    for fields in fieldsArray {
                        print("fields",fields,CoreDataController().getContentNameFromContentTypeId(fields.int!))
                        if(fieldsName.characters.count == 0) {
                            
                            fieldsName = fieldsName.uppercaseString+CoreDataController().getContentNameFromContentTypeId(fields.int!).uppercaseString
                        } else {
                            fieldsName = fieldsName.uppercaseString+" & "+CoreDataController().getContentNameFromContentTypeId(fields.int!).uppercaseString
                        }
                        
                    }
                    article.setValue(fieldsName, forKey: "fieldsName")
                }
                
                /* outlet name configuration */
                if let outletArray = articleJSON["outlet"].array {
                    var outletName:String = ""
                    for outlet in outletArray {
                        if(outletName.characters.count == 0) {
                            outletName = outletName+outlet["name"].stringValue
                        } else {
                            outletName = outletName+" & "+outlet["name"].stringValue
                        }
                        
                    }
                    article.setValue(outletName, forKey: "outletName")
                }
                
                /* contact name configuration */
                if let contactArray = articleJSON["contact"].array {
                    var contactName:String = ""
                    for contact in contactArray {
                        if(contactName.characters.count == 0) {
                            contactName = contactName+contact["name"].stringValue
                        } else {
                            contactName = contactName+","+contact["name"].stringValue
                        }
                        
                    }
                    article.setValue(contactName, forKey: "contactName")
                }
                
                if let markAsImportantDic = articleJSON["markAsImportantUserDetail"].dictionary {
                    if(markAsImportantDic.count != 0) {
                        article.setValue(markAsImportantDic["userId"]?.intValue, forKey: "markAsImportantUserId")
                        article.setValue(markAsImportantDic["name"]?.stringValue, forKey: "markAsImportantUserName")
                    }
                    
                }
                
                try article.managedObjectContext?.save()
            }
            
            
            // Dismiss View Controller
            
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
        
    }
    
    
    func updateMarkedImportantStatusInArticle(artilceId:String,contentTypeId:Int,isMarked:Int,isMarkedImpSync:Bool) {
        print("incoming content type id",contentTypeId)
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2 set predicate value
        let fetchRequest = NSFetchRequest(entityName: "Article")
        fetchRequest.predicate = NSPredicate(format: "articleId == %@ AND contentTypeId == %@",artilceId,String(contentTypeId))
        do {
            
            let results =
                try managedContext.executeFetchRequest(fetchRequest) as! [Article]
            if results.count != 0{
                let article = results[0] as Article
                article.setValue(isMarked, forKey: "isMarkedImportant")
                article.setValue(isMarkedImpSync, forKey: "isMarkedImportantSync")
                try article.managedObjectContext?.save()
            }
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
    }

    func updateSavedForLaterStatusInArticle(artilceId:String,contentTypeId:Int,isSaved:Int,isSavedSync:Bool) {
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2 set predicate value
        let fetchRequest = NSFetchRequest(entityName: "Article")
        fetchRequest.predicate = NSPredicate(format: "articleId == %@ AND contentTypeId == %@",artilceId,String(contentTypeId))
        do {
            
            let results =
                try managedContext.executeFetchRequest(fetchRequest) as! [Article]
            if results.count != 0{
                let article = results[0] as Article
                article.setValue(isSaved, forKey: "isSavedForLater")
                article.setValue(isSavedSync, forKey: "isSavedForLaterSync")
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
    
    func getContentCategoryInfoFromCoreData(entityName:String) -> [ContentCategory] {
        var entityResult = [ContentCategory]()
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: entityName)
        
        //3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest) as! [ContentCategory]
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
            print("webservice results",entityResult.count)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return entityResult
    }
    
    func getMarkedArticleListForContentTypeId(contentTypeId:NSNumber,pageNo:NSNumber,entityName:String) -> [Article] {
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
            print("webservice results",entityResult.count)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return entityResult
    }
    
    
    func getSearchArticleList(pageNo:NSNumber,entityName:String) -> [Article] {
        var entityResult = [Article]()
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: entityName)
        if((pageNo.isEqualToNumber(0))) {
            fetchRequest.predicate = NSPredicate(format: "isSearch == %@",true)
        } else {
            fetchRequest.predicate = NSPredicate(format: "isSearch == %@ AND pageNo == %@",true,pageNo)
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
    
    
    func getMarkedUnSyncArticle()-> [Article]{
        var entityResult = [Article]()
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Article")
        fetchRequest.predicate = NSPredicate(format: "isMarkedImportantSync == %@",false)
        
        
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
    
    func setMarkedUnSyncToSync() {
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Article")
        fetchRequest.predicate = NSPredicate(format: "isMarkedImportantSync == %@",false)
        
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest) as! [Article]
            if results.count != 0 {
                let article = results[0] as Article
                article.setValue(true, forKey: "isMarkedImportantSync")
                try article.managedObjectContext?.save()
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func getSavedUnSyncArticle()-> [Article]{
        var entityResult = [Article]()
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Article")
        fetchRequest.predicate = NSPredicate(format: "isSavedForLaterSync == %@",false)
        
        
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
    
    func setSavedUnSyncToSync() {
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Article")
        fetchRequest.predicate = NSPredicate(format: "isSavedForLaterSync == %@",false)
        
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest) as! [Article]
            if results.count != 0 {
                let article = results[0] as Article
                article.setValue(true, forKey: "isSavedForLaterSync")
                try article.managedObjectContext?.save()
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func deleteSearchedArtilces() {
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Article")
        fetchRequest.predicate = NSPredicate(format: "isSearch == %@",true)
        
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest) as! [Article]
            for entity in results {
                managedContext.deleteObject(entity)
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    
    func deleteAndResetStack() {
       // var error: NSError?
        
        let appDelegate =
                    UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let url = appDelegate.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        
        let coordinator = managedContext.persistentStoreCoordinator
        if let store = coordinator!.persistentStoreForURL(url) {
            managedContext.reset()
            
            do {
                let removedStore = try coordinator!.removePersistentStore(store)
//                print("removed store",removedStore)
//                if (removedStore) {
//                    print("Unable to remove store: \(error)")
//                    return
//                }
                
                let fm = NSFileManager.defaultManager()
                let deleted = try fm.removeItemAtURL(url)
//                print("deleted",deleted)
            } catch {
                
            }
            
//            let fm = NSFileManager.defaultManager()
//            let deleted = fm.removeItemAtURL(url, error: &error)
//            if !deleted {
//                print("Unable to remove Core Data DB at \(url): \(error)")
//            }
            addStoreToCoordinator(coordinator!)
        }
        
    }
    
    private func addStoreToCoordinator(coordinator: NSPersistentStoreCoordinator) {
        var error: NSError?
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        //let managedContext = appDelegate.managedObjectContext
        let url = appDelegate.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        do {
            let store = try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
//            print("store",store)
//            if store == nil {
//                println("Could not open store at \(storeURL): \(error)")
//            }
        } catch {
            
        }
        
        
    }
    
    
}


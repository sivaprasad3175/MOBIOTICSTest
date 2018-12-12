//
//  CoreDataHelper.swift
//  ContactTest
//
//  Created by Raja on 12/12/18.
//  Copyright © 2018 Siva. All rights reserved.
//

import Foundation
import CoreData

class CoreDataHelper {
    
    static let shared: CoreDataHelper = CoreDataHelper()
    
    var fetchedResultsController: NSFetchedResultsController<User> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        //Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        //Edit the sort key as approprite.
        let sortDescription = NSSortDescriptor(key: "firstName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescription]
        
        //Edit the section name key path and cache name if approprite.
        //nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.context, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self as? NSFetchedResultsControllerDelegate
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController?.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    
    private var _fetchedResultsController: NSFetchedResultsController<User>? = nil
    
    // save user into db
    func saveData() {
        let context = _fetchedResultsController?.managedObjectContext
        do {
            try context?.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    // retrive user
    func retrieveData() -> [User]?{
        //We need to create a context from this container
        let managedContext = AppDelegate.persistentContainer.viewContext
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            let result = try managedContext.fetch(fetchRequest) as! [User]
            return result
        } catch {
            
            print("Failed")
        }
        return nil
    }
    
    // upadte user
    func updateData(_ user:User){
        let managedContext = AppDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "firstName = %@", user.firstName!)
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            let objectUpdate = test[0] as! NSManagedObject
            objectUpdate.setValue(user.firstName!, forKey: "firstName")
            objectUpdate.setValue(user.lastName!, forKey: "lastName")
            objectUpdate.setValue(user.emailId!, forKey: "emailId")
            objectUpdate.setValue(user.phoneNumber, forKey: "phoneNumber")
            objectUpdate.setValue(user.image!, forKey: "image")
            do{
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
        }
        catch
        {
            print(error)
        }
        
    }
    // delete user
    func deleteUser(_ user:User){
        let managedContext = AppDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "firstName = %@", user.firstName!)
        do{
            let test = try managedContext.fetch(fetchRequest)
            let objectToDelete = test[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            do{
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
        }
        catch
        {
            print(error)
        }
    }
}

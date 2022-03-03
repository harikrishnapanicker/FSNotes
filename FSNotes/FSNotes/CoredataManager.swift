//
//  CoredataManager.swift
//  FSNotes
//
//  Created by HariPanicker on 25/02/22.
//

import Foundation
import CoreData

class CoredataManager {
    
    static let shared = CoredataManager()
    
    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FSNotes")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() {
    }
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveUser() {
        guard let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User else {
            return
        }
        user.showHome = true
        do {
            try context.save()
        } catch {
            fatalError("Coredata: saveUser failed")
        }
    }
    
    func showHome() -> Bool {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.fetchLimit = 1
        do {
            let user = try context.fetch(fetchRequest)
            return user.first?.showHome ?? false
        } catch {
            return false
        }
    }
    
    func deleteUser() {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.fetchLimit = 1
        do {
            if let user = try context.fetch(fetchRequest).first {
                user.showHome = false
            }
            try context.save()
        } catch {
            fatalError("Coredata: delete user failed")
        }
    }
}

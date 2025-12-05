//
//  CoreDataManager.swift
//  ClaseCoreData
//
//  Created by Brayan Munoz Campos on 4/12/25.
//

import CoreData

class CoreDataManager {
    
    private let modelName = "ClaseCoreData"
    private let identifier = "com.ClaseCoreData"
    private let extensionName = "momd"
    
    static var shared = CoreDataManager()
    
    lazy var persistenContainer: NSPersistentContainer = {
        let bundle = Bundle(identifier: identifier)
        let modelURL = bundle!.url(forResource: modelName, withExtension: extensionName)!
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
        let container = NSPersistentContainer(name: modelName, managedObjectModel: managedObjectModel!)
        container.loadPersistentStores { storeDescription, error in
            if let error {
                debugPrint("Loading of store faild: \(error)")
            } else {
                debugPrint("Susccessfully loaded store: \(storeDescription)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistenContainer.viewContext
    }
}

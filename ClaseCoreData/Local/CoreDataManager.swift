//
//  CoreDataManager.swift
//  ClaseCoreData
//
//  Created by Brayan Munoz Campos on 4/12/25.
//

import CoreData

/// **NSPersistentContainer**
/// Contenedor que encapsula el stack completo de Core Data (modelo, coordinador y contexto).
/// Simplifica la configuración de Core Data al manejar automáticamente la creación y carga del almacén persistente.
///
/// **NSManagedObjectModel**
/// Define el esquema de la base de datos (entidades, atributos, relaciones).
/// Se crea desde el archivo .xcdatamodeld compilado (.momd).
///
/// **NSManagedObjectContext**
/// Espacio de trabajo temporal donde se crean, editan y eliminan objetos.
/// Los cambios no se guardan en disco hasta llamar a context.save().
/// Es como una "zona de staging" para las operaciones de base de datos.
/// 
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

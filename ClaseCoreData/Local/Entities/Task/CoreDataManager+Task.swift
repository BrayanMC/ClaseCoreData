//
//  CoreDataManager+Task.swift
//  ClaseCoreData
//
//  Created by Brayan Munoz Campos on 4/12/25.
//

import CoreData

/// **NSFetchRequest**
/// Es una consulta a Core Data que especifica qué datos recuperar de la base de datos.
/// Equivalente a SELECT en SQL.
///
/// **NSPredicate**
/// Es un filtro/condición para la búsqueda. Equivalente a WHERE en SQL.
///
/// **Ejemplos comunes:**
/// ```
/// // Consulta básica
/// let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
/// // SQL: SELECT * FROM Task
///
/// // Con filtro por ID
/// fetchRequest.predicate = NSPredicate(format: "id == %d", 5)
/// // SQL: WHERE id = 5
///
/// // Buscar por texto (case insensitive)
/// fetchRequest.predicate = NSPredicate(format: "title CONTAINS[c] %@", "importante")
/// // SQL: WHERE title LIKE '%importante%'
/// ```
///
/// **Formatos de NSPredicate:**
/// - `"id == %d"` - Igualdad con número
/// - `"title == %@"` - Igualdad con string
/// - `"title CONTAINS %@"` - Contiene texto
/// - `"id IN %@"` - ID en array [1, 2, 3]
/// - `"title BEGINSWITH %@"` - Empieza con
/// - `"id > %d AND status == %@"` - Múltiples condiciones
///
extension CoreDataManager {
    
    func saveTaskEntity(with model: TaskModel) throws {
        debugPrint("Starting saveTaskEntity with id: \(model.id)")
        
        let entity = TaskEntity(context: context)
        entity.id = model.id
        entity.title = model.title
        entity.taskDescription = model.description
        
        do {
            debugPrint("Entity saved successfully")
            try context.save()
        } catch {
            debugPrint("Failed to save task entity: \(error)")
            throw error
        }
    }
    
    func updateTaskEntity(id: Int32, with model: TaskModel) throws {
        debugPrint("Starting updateTaskEntity with id: \(id)")
        
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            guard let entity = results.first else {
                debugPrint("Task with id \(id) not found")
                throw NSError(domain: "CoreDataManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Task not found"])
            }
            
            entity.title = model.title
            entity.taskDescription = model.description
            
            try context.save()
            debugPrint("Task updated successfully")
        } catch {
            debugPrint("Failed to update task entity: \(error)")
            throw error
        }
    }
    
    func deleteTaskEntity(id: Int32) throws {
        debugPrint("Starting deleteTaskEntity with id: \(id)")
        
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            guard let entity = results.first else {
                debugPrint("Task with id \(id) not found")
                throw NSError(domain: "CoreDataManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Task not found"])
            }
            
            context.delete(entity)
            try context.save()
            debugPrint("Task deleted successfully")
        } catch {
            debugPrint("Failed to delete task entity: \(error)")
            throw error
        }
    }
    
    func deleteAllTasks() throws {
        debugPrint("Starting deleteAllTasks")
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TaskEntity.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            try context.save()
            debugPrint("All tasks deleted successfully")
        } catch {
            debugPrint("Failed to delete all tasks: \(error)")
            throw error
        }
    }
    
    func fetchTasks() throws -> [TaskModel] {
        debugPrint("Starting fetchTasks")
        
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        
        do {
            let taskEntities = try context.fetch(fetchRequest)
            let tasksModels: [TaskModel] = taskEntities.map {
                TaskModel(
                    id: $0.id,
                    title: $0.title,
                    description: $0.taskDescription
                )
            }
            return tasksModels
        } catch {
            debugPrint("Failed to fetch task entities: \(error)")
            throw error
        }
    }
}

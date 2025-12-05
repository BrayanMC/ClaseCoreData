//
//  CoreDataManager+Task.swift
//  ClaseCoreData
//
//  Created by Brayan Munoz Campos on 4/12/25.
//

import CoreData

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

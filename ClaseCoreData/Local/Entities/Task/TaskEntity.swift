//
//  TaskEntity.swift
//  ClaseCoreData
//
//  Created by Brayan Munoz Campos on 4/12/25.
//

import CoreData

@objc(TaskEntity)
class TaskEntity: NSManagedObject {
    @NSManaged var id: Int32
    @NSManaged var title: String
    @NSManaged var taskDescription: String
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "Task")
    }
    
    convenience init(
        context: NSManagedObjectContext,
        id: Int32,
        title: String,
        taskDescription: String
    ) {
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: context)!
        self.init(entity: entity, insertInto: context)
        self.id = id
        self.title = title
        self.taskDescription = taskDescription
    }
}

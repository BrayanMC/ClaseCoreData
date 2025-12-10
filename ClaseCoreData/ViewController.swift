//
//  ViewController.swift
//  ClaseCoreData
//
//  Created by Brayan Munoz Campos on 4/12/25.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        demonstrateCoreDataOperations()
    }
    
    // MARK: - Core Data Operations Demo
    
    private func demonstrateCoreDataOperations() {
        // 1. Crear y guardar una nueva tarea
        saveTask()
        
        // 2. Esperar 2 segundos y leer todas las tareas
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.fetchTasks()
        }
        
        // 3. Actualizar la tarea después de 4 segundos
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
            self?.updateTask(by: 1234)
        }
        
        // 4. Leer nuevamente para ver los cambios
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) { [weak self] in
            self?.fetchTasks()
        }
        
        // 5. Eliminar una tarea específica después de 8 segundos
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) { [weak self] in
            self?.deleteTask(by: 1234)
        }
        
        // 6. Verificar que se eliminó
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            self?.fetchTasks()
        }
        
        // 7. Guardar varias tareas para demostrar deleteAll
        DispatchQueue.main.asyncAfter(deadline: .now() + 12) { [weak self] in
            self?.saveMultipleTasks()
        }
        
        // 8. Ver todas las tareas guardadas
        DispatchQueue.main.asyncAfter(deadline: .now() + 14) { [weak self] in
            self?.fetchTasks()
        }
        
        // 9. Eliminar todas las tareas
        DispatchQueue.main.asyncAfter(deadline: .now() + 16) { [weak self] in
            self?.deleteAll()
        }
        
        // 10. Verificar que la base de datos está vacía
        DispatchQueue.main.asyncAfter(deadline: .now() + 18) { [weak self] in
            self?.fetchTasks()
        }
    }
    
    // MARK: - CREATE
    
    /// Guarda una nueva tarea en Core Data
    /// - Note: Crea un objeto TaskModel y lo persiste usando el contexto de Core Data
    private func saveTask() {
        debugPrint("📝 GUARDAR: Creando nueva tarea...")
        
        let taskModel = TaskModel(
            id: 1234,
            title: "Core Data",
            description: "Mi primera clase con Core Data"
        )
        
        do {
            try CoreDataManager.shared.saveTaskEntity(with: taskModel)
            debugPrint("✅ GUARDAR: Tarea guardada exitosamente")
        } catch {
            debugPrint("❌ GUARDAR: Error al guardar tarea - \(error.localizedDescription)")
        }
    }
    
    /// Guarda múltiples tareas para demostrar la eliminación masiva
    private func saveMultipleTasks() {
        debugPrint("📝 GUARDAR MÚLTIPLES: Creando varias tareas...")
        
        let tasks = [
            TaskModel(id: 100, title: "Tarea 1", description: "Primera tarea de prueba"),
            TaskModel(id: 200, title: "Tarea 2", description: "Segunda tarea de prueba"),
            TaskModel(id: 300, title: "Tarea 3", description: "Tercera tarea de prueba"),
            TaskModel(id: 400, title: "Tarea 4", description: "Cuarta tarea de prueba")
        ]
        
        do {
            for task in tasks {
                try CoreDataManager.shared.saveTaskEntity(with: task)
            }
            debugPrint("✅ GUARDAR MÚLTIPLES: \(tasks.count) tareas guardadas exitosamente")
        } catch {
            debugPrint("❌ GUARDAR MÚLTIPLES: Error al guardar tareas - \(error.localizedDescription)")
        }
    }
    
    // MARK: - READ
    
    /// Obtiene todas las tareas almacenadas en Core Data
    /// - Note: Ejecuta un NSFetchRequest sin predicado (WHERE) para obtener todos los registros
    private func fetchTasks() {
        debugPrint("📖 LEER: Obteniendo todas las tareas...")
        
        do {
            let tasks = try CoreDataManager.shared.fetchTasks()
            
            if tasks.isEmpty {
                debugPrint("✅ LEER: No hay tareas en la base de datos (está vacía)")
            } else {
                debugPrint("✅ LEER: Se encontraron \(tasks.count) tarea(s)")
                
                // Mostrar detalles de cada tarea
                tasks.forEach { task in
                    debugPrint("   - ID: \(task.id) | Título: \(task.title) | Descripción: \(task.description)")
                }
            }
        } catch {
            debugPrint("❌ LEER: Error al obtener tareas - \(error.localizedDescription)")
        }
    }
    
    // MARK: - UPDATE
    
    /// Actualiza una tarea existente por su ID
    /// - Parameter id: El identificador único de la tarea a actualizar
    /// - Note: Busca la tarea usando NSPredicate (WHERE id = X) y actualiza sus propiedades
    private func updateTask(by id: Int32) {
        debugPrint("✏️ ACTUALIZAR: Modificando tarea con ID \(id)...")
        
        let updatedModel = TaskModel(
            id: id,
            title: "Core Data Actualizado",
            description: "Descripción modificada con éxito"
        )
        
        do {
            try CoreDataManager.shared.updateTaskEntity(id: id, with: updatedModel)
            debugPrint("✅ ACTUALIZAR: Tarea actualizada correctamente")
        } catch {
            debugPrint("❌ ACTUALIZAR: Error al actualizar tarea - \(error.localizedDescription)")
        }
    }
    
    // MARK: - DELETE BY ID
    
    /// Elimina una tarea específica por su ID
    /// - Parameter id: El identificador único de la tarea a eliminar
    /// - Note: Busca la tarea usando NSPredicate y la elimina del contexto
    private func deleteTask(by id: Int32) {
        debugPrint("🗑️ ELIMINAR: Borrando tarea con ID \(id)...")
        
        do {
            try CoreDataManager.shared.deleteTaskEntity(id: id)
            debugPrint("✅ ELIMINAR: Tarea eliminada exitosamente")
        } catch {
            debugPrint("❌ ELIMINAR: Error al eliminar tarea - \(error.localizedDescription)")
        }
    }
    
    // MARK: - DELETE ALL
    
    /// Elimina todas las tareas de Core Data
    /// - Note: Usa NSBatchDeleteRequest para eliminar todos los registros de forma eficiente
    /// - Important: Esta operación es irreversible y borra toda la tabla de tareas
    private func deleteAll() {
        debugPrint("🗑️ ELIMINAR TODO: Borrando todas las tareas de la base de datos...")
        
        do {
            try CoreDataManager.shared.deleteAllTasks()
            debugPrint("✅ ELIMINAR TODO: Todas las tareas fueron eliminadas exitosamente")
            debugPrint("   ℹ️ La base de datos ahora está completamente vacía")
        } catch {
            debugPrint("❌ ELIMINAR TODO: Error al eliminar todas las tareas - \(error.localizedDescription)")
        }
    }
}

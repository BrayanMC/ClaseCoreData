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
        saveTask()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            guard let self else { return }
            self.fetchTasks()
        }
    }
    
    private func saveTask() {
        let taskModel = TaskModel(
            id: 1234,
            title: "Core data",
            description: "Mi primera clase con core data"
        )
        
        do {
            try CoreDataManager.shared.saveTaskEntity(with: taskModel)
        } catch {
            debugPrint("Error saving task: \(error)")
        }
    }
    
    private func fetchTasks() {
        do {
            let tasks = try CoreDataManager.shared.fetchTasks()
            print(tasks)
        } catch {
            debugPrint("Error fetching tasks: \(error)")
        }
    }
}


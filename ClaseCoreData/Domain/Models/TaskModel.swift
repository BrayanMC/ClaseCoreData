//
//  TaskModel.swift
//  ClaseCoreData
//
//  Created by Brayan Munoz Campos on 4/12/25.
//

struct TaskModel {
    let id: Int32
    let title: String
    let description: String
    
    init(id: Int32, title: String, description: String) {
        self.id = id
        self.title = title
        self.description = description
    }
}

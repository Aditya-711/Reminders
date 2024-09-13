//
//  TaskListVM.swift
//  RemindersFirebase
//
//  Created by Aditya Inamdar on 10/08/20.
//  Copyright © 2020 Aditya Inamdar. All rights reserved.
//
import Foundation
import Combine
import SwiftUI

class TaskListVM: ObservableObject {
    
    @ObservedObject var tasksRepository = TaskRepository()
    @Published var taskCellVMs: [TaskCellVM] = [TaskCellVM]()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        tasksRepository.$tasks.map { tasks in
            tasks.map { task in
                TaskCellVM(task: task)
            }
        }
        .assign(to: \.taskCellVMs, on: self)
        .store(in: &cancellables)
    }
    
    func addTask(task: Task) {
        //let taskVM = TaskCellVM(task: task)
        tasksRepository.addTask(task)
       // taskCellVMs.append(taskVM)
    }
    
    func delete(task: Task) {
        self.tasksRepository.deleteTask(task)
    }
    
}

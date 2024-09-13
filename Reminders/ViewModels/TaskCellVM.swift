//
//  TaskCellVM.swift
//  RemindersFirebase
//
//  Created by Aditya Inamdar on 09/08/20.
//  Copyright © 2020 Aditya Inamdar. All rights reserved.
//
import Foundation
import Combine

class TaskCellVM: Identifiable, ObservableObject {
    
    @Published var taskRepository = TaskRepository()
    @Published var task: Task
    var id: String = ""
    @Published var completionIconName: String = ""
    private var cancellables = Set<AnyCancellable>()
    
    init(task: Task) {
        self.task = task
        
        $task.map { task in
            task.completed ? "checkmark.circle.fill" : "circle"
        }
        .assign(to: \.completionIconName, on: self)
        .store(in: &cancellables)
        
        $task
            .compactMap { task in
                task.id
        }
        .assign(to: \.id, on: self)
        .store(in: &cancellables)
        
        $task
            .dropFirst()
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .sink { (task) in
                print("Sink called")
                self.taskRepository.updateTask(task)
        }
          .store(in: &cancellables)
    }
}

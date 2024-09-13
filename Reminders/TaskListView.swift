//
//  ContentView.swift
//  RemindersFirebase
//
//  Created by Aditya Inamdar on 09/08/20.
//  Copyright © 2020 Aditya Inamdar. All rights reserved.
//

import SwiftUI

enum ActiveSheet: Identifiable {
    case DocumentPicker
    case AllDocumentsView
    var id: Int { hashValue }
}

struct TaskListView: View {
    
    @ObservedObject var tasklistVM = TaskListVM()
    @State var presentAddNewTask: Bool = false
    @State var presentAlert: Bool = false
    @State var activeSheet: ActiveSheet? = nil
    
    private func deleteTask(task PassedTaskCellVM: TaskCellVM ) {
        if let index = tasklistVM.taskCellVMs.firstIndex(where: {$0.task.title == PassedTaskCellVM.task.title}) {
            let taskToBeDeleted = tasklistVM.taskCellVMs[index].task
            tasklistVM.delete(task: taskToBeDeleted)
        }
    }
    init() {
        UIScrollView.appearance().keyboardDismissMode = .interactive
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(tasklistVM.taskCellVMs) { taskCellVM in
                        TaskCell(taskCellVM: taskCellVM, presentAlert: self.$presentAlert)
                            .contextMenu {
                                Button(action: {
                                    self.deleteTask(task: taskCellVM)
                                }) {
                                    Text("Delete")
                                    Image(systemName: "trash")
                                }
                            }
                    }
                    .onDelete { (taskIndex) in
                        for taskCellVM in taskIndex {
                            let taskToBeDeleted = self.tasklistVM.taskCellVMs[taskCellVM].task
                            self.tasklistVM.delete(task: taskToBeDeleted)
                        }
                    }
                    
                    if presentAddNewTask == true {
                        TaskCell(taskCellVM: TaskCellVM(task: Task(completed: false, title: "")), presentAlert: $presentAlert) { task in
                            
                            self.presentAlert = false
                            self.tasklistVM.addTask(task: task)
                            self.presentAddNewTask.toggle()
                        }
                    }
                }
                //.listStyle(InsetGroupedListStyle())
                .alert(isPresented: $presentAlert) {
                    Alert(title: Text("Text Alert"), message: Text("Please enter some Text"), dismissButton: .default(Text("Got it!")))
                }
                
                
                Button(action: {
                    self.presentAddNewTask.toggle()
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .foregroundColor(.blue)
                            .frame(width: 20,height: 20)
                        Text("Add New Task")
                        Spacer()
                    }
                    .padding()
                }
                
                .navigationBarTitle("Reminders")
            }
            .sheet(item: $activeSheet) { item in
                switch item {
                    case .DocumentPicker: DocumentPicker()
                    case .AllDocumentsView: AllDocumentsView()
                }
            }
            .navigationBarItems(trailing:
                                    Menu {
                                        Button("Add Documents") {
                                            activeSheet = .DocumentPicker
                                        }
                                        Button("Show all Documents") {
                                            activeSheet = .AllDocumentsView
                                        }
                                    } label: {
                                        Image(systemName: "ellipsis.circle")
                                    })
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            //TaskCell(taskCellVM: TaskCellVM(task: Task(id: "", completed: false, title: "Dummy Title", createdTime: nil, userID: "711@api")), presentAlert: .constant(false))
            // TaskListView(activeSheet: Optional.none)
        }
    }
}

struct TaskCell: View {
    @ObservedObject var taskCellVM: TaskCellVM
    @Binding var presentAlert: Bool
    
    var onCommit: (Task)->(Void) = {_ in}
    var body: some View {
        HStack {
            Image(systemName: taskCellVM.task.completed ? "checkmark.circle.fill" : "circle")
                .resizable()
                .foregroundColor(taskCellVM.task.completed ? .blue : .gray)
                .frame(width: 20,height: 20)
                .onTapGesture { self.taskCellVM.task.completed.toggle() }

            if #available(iOS 15.0, *) {
            TextField("Enter task", text: $taskCellVM.task.title)
                .onSubmit {
                        if self.taskCellVM.task.title == "" {
                            self.presentAlert.toggle()
                        }
                        else {
                            self.onCommit(self.taskCellVM.task)
                            
                        }
                    }
                } else {
                    TextField("Enter task", text: $taskCellVM.task.title, onCommit: {
                        if self.taskCellVM.task.title == "" {
                            self.presentAlert.toggle()
                        }
                        else {
                            self.onCommit(self.taskCellVM.task)
                            
                        }
                    })
                    .fixedSize()
                }
        }
        
    }
}

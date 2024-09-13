//
//  TaskRepository.swift
//  RemindersFirebase
//
//  Created by Aditya Inamdar on 15/08/20.
//  Copyright © 2020 Aditya Inamdar. All rights reserved.
//
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

class TaskRepository: ObservableObject {
    let db = Firestore.firestore()
    @Published var tasks: [Task] = [Task]()
    
    init() {
        loadData()
    }
    
    func loadData() {
        let userID = Auth.auth().currentUser?.uid
        db.collection("tasks")
            .order(by: "createdTime")
            .whereField("userID", isEqualTo: userID as Any)
            .addSnapshotListener {[weak self] (querySnapshot, error) in
                guard let weakSelf = self else { return }
                if let SquerySnapshot = querySnapshot {
                    weakSelf.tasks =  SquerySnapshot.documents.compactMap { document in
                        do {
                            let tasks = try document.data(as: Task.self)
                            return tasks
                        } catch {
                            print("Found error in TaskRepository: \(error)")
                        }
                        return nil
                    }
                }
        }
    }
    
    func addTask(_ task: Task) {
        do {
            var addedTask = task
            addedTask.userID = Auth.auth().currentUser?.uid
            print("added task \(addedTask)")
            let _ = try db.collection("tasks").addDocument(from: addedTask)
        }
        catch {
            fatalError("Unable to add Data")
        }
    }
    
    func updateTask(_ task: Task) {
        if let taskID = task.id {
            do {
                try db.collection("tasks").document(taskID).setData(from: task)
            }
            catch {
                fatalError("Unable to encode task: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteTask(_ task: Task) {
        if let taskID = task.id {
            db.collection("tasks").document(taskID).delete()
        }
    }
}

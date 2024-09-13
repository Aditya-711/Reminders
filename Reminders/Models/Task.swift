//
//  Task.swift
//  RemindersFirebase
//
//  Created by Aditya Inamdar on 09/08/20.
//  Copyright © 2020 Aditya Inamdar. All rights reserved.
//
import Foundation

import FirebaseFirestoreSwift
import FirebaseFirestore

struct Task: Identifiable, Codable {
    
    @DocumentID var id: String?
    var completed: Bool
    var title: String
    @ServerTimestamp var createdTime: Timestamp?
    var userID: String?
}


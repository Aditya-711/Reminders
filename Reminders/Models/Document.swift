//
//  Document.swift
//  RemindersFirebase
//
//  Created by Aditya Inamdar on 13/10/20.
//  Copyright © 2020 Aditya Inamdar. All rights reserved.
//

import Foundation
struct Document: Identifiable {
    var id: UUID = UUID()
    var title: String
    var downloadURL: URL?
}

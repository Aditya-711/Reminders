//
//  RemindersApp.swift
//  Reminders
//
//  Created by Aditya Inamdar on 01/10/22.
//
// bundle id is changed on 11 may 2023:com.AdityaI.RemindersFirebas

import SwiftUI

@main
struct RemindersApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            TaskListView()
        }
    }
}

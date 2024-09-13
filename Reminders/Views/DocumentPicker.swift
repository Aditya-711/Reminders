//
//  DocumentPicker.swift
//  RemindersFirebase
//
//  Created by Aditya Inamdar on 10/10/20.
//  Copyright © 2020 Aditya Inamdar. All rights reserved.
//
import MobileCoreServices
import Foundation
import SwiftUI
import Firebase
import UniformTypeIdentifiers

struct DocumentPicker: UIViewControllerRepresentable {
    let supportedTypes: [UTType] = [UTType.pdf,UTType.spreadsheet,UTType.text,UTType.presentation,UTType.image,UTType.mpeg4Movie]
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)

       //UIDocumentPickerViewController(documentTypes: [String(kUTTypeItem)], in: .open)
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
        print("updateUIViewController")
    }
    
    class Coordinator: NSObject,UIDocumentPickerDelegate {
        var parent: DocumentPicker
        
        init(parent: DocumentPicker) {
            self.parent = parent
        }
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            print("DEBUG: 1")
            let bucket = Storage.storage().reference(withPath: "files/\(urls.first!.deletingPathExtension().lastPathComponent)")
            let fileURL = urls.first!
            bucket.putFile(from: fileURL, metadata: nil) { (_, error) in
                if error == nil {
                    print("DEBUG: Success")
                } else {
                    print("DEBUG: Failed with error- \(String(describing: error?.localizedDescription))")
                }
            }
        }
    }
}

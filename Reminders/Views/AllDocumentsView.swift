//
//  AllDocumentsView.swift
//  RemindersFirebase
//
//  Created by Aditya Inamdar on 13/10/20.
//  Copyright © 2020 Aditya Inamdar. All rights reserved.
//
import Firebase
import SwiftUI

class DocsStore: ObservableObject {
    @Published var documents: [Document] = []
}
struct GridView: View {
    let columns: [GridItem] = Array(repeating: GridItem(.fixed(100)), count: 5)
    var body: some View {
        Text("")
    }
}
struct AllDocumentsView: View {
    
    let storageRef = Storage.storage().reference(withPath: "files/")
    
    @ObservedObject var docsStore: DocsStore = DocsStore()
    
    func fetchURL(_ documentTitle: String,completion: @escaping(URL)->Void){
        let storageRef = Storage.storage().reference(withPath: "files/\(documentTitle)")
        storageRef.downloadURL { (url, error) in
            if error == nil {
                guard let safeURL = url else {return}
                completion(safeURL)
                print("DEBUG: This is document URL - \(safeURL)")
            }
        }
    }
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(docsStore.documents,id:\.id) { doc in
                    NavigationLink(destination: FilePreviewView(url: doc.downloadURL)) {
                        HStack {
                            Text(doc.title)
                            Spacer()
                            Image(systemName: "doc")
                                .offset(x: -10.0)
                        }
                    }
                }
            }
            .navigationTitle("Documents")
        }
        .onAppear {
            DispatchQueue.main.async {
                storageRef.listAll { (result, error) in
                    if error == nil {
                        for res in result!.items {
                            fetchURL(res.name) { (url) in
                                var newDoc = Document(title: res.name)
                                newDoc.downloadURL = url
                                
                                print("This is newDoc.downloadURL - \(String(describing: newDoc.downloadURL))")
                                docsStore.documents.append(newDoc)
                            }
                        }
                    } else {
                        print("Got error: \(String(describing: error)) ")
                        return
                    }
                }
            }
        }
    }
}


struct AllDocumentsView_Previews: PreviewProvider {
    static var previews: some View {
        AllDocumentsView()
    }
}

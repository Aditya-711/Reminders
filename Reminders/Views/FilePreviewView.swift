//
//  FilePreviewView.swift
//  RemindersFirebase
//
//  Created by Aditya Inamdar on 13/10/20.
//  Copyright © 2020 Aditya Inamdar. All rights reserved.
//
import WebKit
import SwiftUI

struct FilePreviewView: View {
    let url: URL?
    var body: some View {
        //NavigationView {
        WebView(url: url)
//            .navigationBarTitle("File Preview", displayMode: .inline)
//        }
    }
}

struct FilePreviewView_Previews: PreviewProvider {
    static var previews: some View {
        FilePreviewView(url: URL(string:"https://www.google.com"))
    }
}
struct WebView: UIViewRepresentable {
    let url: URL?
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let safeString = url {
                let request = URLRequest(url: safeString)
                uiView.load(request)
        }
    }
    
    
    
}

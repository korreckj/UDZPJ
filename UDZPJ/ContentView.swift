//
//  ContentView.swift
//  UDZPJ
//
//  Created by Jeremiah Korreck on 1/25/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var showCamera = false
    @State private var showAlert = false
    @State private var selectedImage: UIImage?
    @State var image: UIImage?    
    @State private var sortOrder = [SortDescriptor(\PhotoEntry.prediction)]
    @State private var searchText = ""
    
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationSplitView {
            VStack() {
                PhotosView(searchString: searchText, sortOrder: sortOrder)
            }
            .onChange(of: selectedImage, addItem)
            .navigationTitle("UDZ Photo Journal")
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("info", systemImage: "i.circle") {
                        showAlert.toggle()
                    }
                    .sheet(isPresented: $showAlert) {
                        InformationView()
                    }
                }
                
                ToolbarItem() {
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Name (A-Z)")
                                .tag([SortDescriptor(\PhotoEntry.prediction)])
                            
                            Text("Name (Z-A)")
                                .tag([SortDescriptor(\PhotoEntry.prediction, order: .reverse)])
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("+", systemImage: "camera") {
                        self.showCamera.toggle()
                    }.fullScreenCover(isPresented: self.$showCamera) {
                        accessCameraView(selectedImage: self.$selectedImage)
                    }
                }
            }
            .searchable(text: $searchText)
        } detail: {
            Text("Select a Photo Entry")
        }
        
    }

    
    
    private func addItem() {
        if let img = self.$selectedImage.wrappedValue {
            let myData = img.pngData()
            let newEntry = PhotoEntry(img: myData)
            modelContext.insert(newEntry)
            
        }
    }

    
}

#Preview {
    ContentView()
        .modelContainer(for: PhotoEntry.self, inMemory: true)
}

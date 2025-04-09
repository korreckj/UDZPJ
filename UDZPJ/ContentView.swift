//
//  ContentView.swift
//  UDZPJ
//
//  Created by Jeremiah Korreck on 1/25/24.
//

import SwiftUI
import SwiftData
import PhotosUI

struct ContentView: View {
    @State private var showCamera = false
    @State private var showAlert = false
    @State private var selectedImage: UIImage?
    @State private var pickerItem: PhotosPickerItem?
    @State var image: UIImage?
    @State private var sortOrder = [SortDescriptor(\PhotoEntry.prediction)]
    @State private var searchText = ""
    @State private var newEntry = PhotoEntry(img: nil)
    @State private var showEditView: Bool = false
    
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationSplitView {
            VStack() {
                // photosview provides the list for the app
                PhotosView(searchString: searchText, sortOrder: sortOrder)
                    .navigationDestination(isPresented: $showEditView, destination: {
                        EditPhotoView(photo: newEntry)
                            .onDisappear {
                                self.showEditView = false
                            }
                    })
            }
            .onChange(of: selectedImage, addItem)
            .onChange(of: pickerItem, processImport)
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
                ToolbarItem(placement: .topBarLeading) {
                    PhotosPicker("import", selection: $pickerItem, matching: .images)
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
            newEntry = PhotoEntry(img: myData)
            modelContext.insert(newEntry)
            showEditView.toggle()
            
        }
    }
    
    private func processImport() {
        Task {
            let img = try await pickerItem?.loadTransferable(type: Data.self)
            selectedImage = UIImage(data: img!)
        }
    }
    
    
}

#Preview {
    ContentView()
        .modelContainer(for: PhotoEntry.self, inMemory: true)
}

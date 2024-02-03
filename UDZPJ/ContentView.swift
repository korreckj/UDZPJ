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
    #if os(iOS)
    @State private var selectedImage: UIImage?
    @State var image: UIImage?
    #endif
    #if os(macOS)
    @State private var selectedImage: NSImage?
    @State var image: NSImage?
    #endif
    
    @Environment(\.modelContext) private var modelContext
    @Query private var photos: [PhotoEntry]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(photos) { photo in
                    NavigationLink {
                        EditPhotoView(photo: photo)
                    } label: {
                        Text(photo.prediction)
                    }
                }
                .onDelete(perform: deleteItems)
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
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
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("+", systemImage: "camera") {
                        self.showCamera.toggle()
                    }.fullScreenCover(isPresented: self.$showCamera) {
                        accessCameraView(selectedImage: self.$selectedImage)
                    }
                }
            }
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

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(photos[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: PhotoEntry.self, inMemory: true)
}

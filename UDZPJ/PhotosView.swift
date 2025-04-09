//
//  PhotosView.swift
//  UDZPJ
//
//  Created by Jeremiah Korreck on 2/6/24.
//

import SwiftUI
import SwiftData



struct PhotosView: View {
     
    @Environment(\.modelContext) private var modelContext
    @Query private var photos: [PhotoEntry]
    
    var body: some View {
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
    }
    
    init(searchString: String = "", sortOrder: [SortDescriptor<PhotoEntry>] = []) {
        _photos = Query(filter: #Predicate { photo in
            if searchString.isEmpty {
                true
            } else {
                photo.prediction.localizedStandardContains(searchString)
            }
        }, sort: sortOrder)
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(photos[index])
            }
        }
    }
    
}

//#Preview {
//    PhotosView()
//}

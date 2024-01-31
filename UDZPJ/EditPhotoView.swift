//
//  EditPhotoView.swift
//  UDZPJ
//
//  Created by Jeremiah Korreck on 1/30/24.
//

import SwiftUI

struct EditPhotoView: View {
    @Bindable var photo: PhotoEntry
    var body: some View {
        #if os(iOS)
        let p = UIImage(data: photo.image!)
        Image(uiImage: p!)
            .resizable()
            .scaledToFit()
        #endif
        #if os(macOS)
        let p = NSImage(data: photo.image!)
        Image(nsImage: p!)
            .resizable()
            .scaledToFit()
        #endif
        Text(photo.prediction)
        Button("Refresh", systemImage: "arrow.circlepath") {
            photo.runPredictions()
        }
        ScrollView() {
            Text(photo.information)
        }
    }
}

//#Preview {
//    EditPhotoView()
//}

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
            .padding(10)
            .bold()
        HStack() {
            Button("Refresh", systemImage: "arrow.circlepath") {
                photo.runPredictions()
            }
            .padding(10)
            let sharePhoto: Photo = Photo(image: Image(uiImage: p!), caption: "Share your photo!")
            
            ShareLink(
                item: sharePhoto,
                preview: SharePreview(
                    sharePhoto.caption,
                    image: sharePhoto.image))
            .padding(10)
        }
        ScrollView() {
            Text(photo.information)
                .padding(10)
        }
    }
}


struct Photo: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(exporting: \.image)
    }


    public var image: Image
    public var caption: String
}
//#Preview {
//    EditPhotoView()
//}

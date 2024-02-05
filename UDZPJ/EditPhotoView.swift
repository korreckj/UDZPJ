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
        HStack() {
            Button("Refresh", systemImage: "arrow.circlepath") {
                photo.runPredictions()
            }
            let sharePhoto: Photo = Photo(image: Image(uiImage: p!), caption: "Share your photo!")
            
            ShareLink(
                item: sharePhoto,
                preview: SharePreview(
                    sharePhoto.caption,
                    image: sharePhoto.image))
        }
        ScrollView() {
            Text(photo.information)
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

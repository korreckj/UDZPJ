//
//  EditPhotoView.swift
//  UDZPJ
//
//  Created by Jeremiah Korreck on 1/30/24.
//

import SwiftUI

struct EditPhotoView: View {
    @Bindable var photo: PhotoEntry
    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0
    @State private var showZoomablePhoto = false
    
    var body: some View {
        VStack {

            let p = UIImage(data: photo.image!)
            if showZoomablePhoto == false {
                Image(uiImage: p!)
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .border(Color.accentColor)
                    .clipped()
                    .onTapGesture {
                        showZoomablePhoto = true
                    }
                    
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
            } else {
                ScrollView([.vertical, .horizontal], showsIndicators: false) {
                    Image(uiImage: p!)
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .border(Color.accentColor)
                        .clipped()
                        .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
                        .scaleEffect(currentZoom + totalZoom)
                        .gesture(
                            MagnifyGesture()
                                .onChanged { value in
                                    currentZoom = value.magnification - 1
                                }
                                .onEnded { value in
                                    totalZoom += currentZoom
                                    currentZoom = 0
                                }
                        )
                        .accessibilityZoomAction { action in
                            if action.direction == .zoomIn {
                                totalZoom += 1
                            } else {
                                totalZoom -= 1
                            }
                        }
                        .onTapGesture {
                            showZoomablePhoto = false
                        }
                }
            }
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

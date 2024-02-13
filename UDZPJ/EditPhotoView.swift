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
    @State private var dragOffset: CGSize = .zero
    
    
    func onDragGestureStarted(value: DragGesture.Value) {
        withAnimation(.easeIn(duration: 0.1)) {
            dragOffset = value.translation
        }
    }
    
    var panGesture: some Gesture {
        DragGesture()
            .onChanged(onDragGestureStarted)
    }
    
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
                Image(uiImage: p!)
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(contentMode: .fit)
                    .border(Color.accentColor)
                    .scaleEffect(currentZoom + totalZoom)
                    .frame(maxHeight: .infinity)
                    .gesture(panGesture)
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
                        totalZoom = 0
                        currentZoom = 1
                        dragOffset = .zero
                    }
                    .offset(dragOffset)
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

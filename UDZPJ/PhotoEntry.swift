//
//  PhotoEntry.swift
//  UDZPJ
//
//  Created by Jeremiah Korreck on 1/25/24.
//

import Foundation
import SwiftData
#if os(iOS)
import UIKit
#endif
#if os(macOS)
import Cocoa
#endif
import CoreML
import Vision

@Model
final class PhotoEntry {
    @Attribute(.externalStorage) var image: Data? = nil
    var prediction: String = ""
    var correction: String = ""
    
    init(img: Data?) {
        self.image = img
        do {
            let ciImage = CIImage(data: self.image!)!
            let config = MLModelConfiguration()
            let mlModel = try DetroitZoo1(configuration: config)
            let vncModel = try VNCoreMLModel(for: mlModel.model)
            let request = VNCoreMLRequest(model: vncModel) { (request, error) in
                self.processClassifications(for: request, error: error)
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                let handler = VNImageRequestHandler(ciImage: ciImage, orientation: .up)
                do {
                    try handler.perform([request])
                } catch {
                    
                    print("Failed to perform classification.\n\(error.localizedDescription)")
                }
            }
            
        } catch {
            // stuff
            fatalError("couldn't operate mlmodel")
        }
    }
    
    
    func processClassifications(for request: VNRequest, error: Error?) {
            DispatchQueue.main.async {
                guard let results = request.results else {
                    print("Unable to classify image.\n\(error!.localizedDescription)")
                    return
                }
                
                let classifications = results as! [VNClassificationObservation]
                
                self.prediction = classifications.first?.identifier ?? ""
            }
            
        }
}

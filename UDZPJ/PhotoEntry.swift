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
    var information: String = ""
    
    init(img: Data?) {
        self.image = img
        runPredictions()
    }
    
    
    public func runPredictions() {
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
                
                switch self.prediction {
                case "Aardvark":
                    self.information = "Aardvark info"
                case "Bald Eagle":
                    self.information = "Bald Eagle info"
                case "Bison":
                    self.information = "Bison info"
                case "Camel":
                    self.information = "Camel info"
                case "Chimpanzee":
                    self.information = "Chimpanzee info"
                case "Crane":
                    self.information = "Crane info"
                case "Eland":
                    self.information = "Eland info"
                case "Flamingo":
                    self.information = "Flamingo info"
                case "Giraffe":
                    self.information = "Giraffe info"
                case "Gorilla":
                    self.information = "Gorilla info"
                case "Grizzly Bear":
                    self.information = "Grizzly Bear info"
                case "Japenese macaque":
                    self.information = "Japenese Macaque info"
                case "Lion":
                    self.information = "Lion info"
                case "Ostrich":
                    self.information = "Ostrich info"
                case "Polar Bear":
                    self.information = "Polar Bear info"
                case "Red Kangaroo":
                    self.information = "Red Kangaroo info"
                case "Red Panda":
                    self.information = "Red Panda info"
                case "Red Ruffed Lemur":
                    self.information = "Red Ruffed Lemur info"
                case "Rhinoceros":
                    self.information = "Rhinoceros info"
                case "Ring-tailed Lemur":
                    self.information = "Ring-tailed Lemur info"
                case "Sea Otter":
                    self.information = "Sea Otter info"
                case "Spoonbill":
                    self.information = "Spoonbill info"
                case "Stork":
                    self.information = "Stork info"
                case "Tiger":
                    self.information = "Tiger info"
                case "Vulture":
                    self.information = "Vulture info"
                case "Wallaby":
                    self.information = "Wallaby info"
                case "Warthog":
                    self.information = "Warthog info"
                case "Wildebeest":
                    self.information = "Wildebeest info"
                case "Wolverine":
                    self.information = "Wolverine info"
                case "Zebra":
                    self.information = "Zebra info"
                default:
                    self.information = "No information on file"
                }
            }
            
        }
}

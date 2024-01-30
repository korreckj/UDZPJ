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
                    self.information = "\tThe ostrich (Struthio camelus) is a remarkable flightless bird native to Africa, known for its unique adaptations and distinction as the world's largest and heaviest living bird. Adult male ostriches can reach a height of 9 feet (2.7 meters) and weigh between 220 to 290 pounds (100 to 130 kilograms), while females are slightly smaller. What sets the ostrich apart is its long legs and neck, as well as its distinctively large eyes – the largest of any bird species. With powerful legs, the ostrich is an adept runner and can reach speeds of up to 45 miles per hour (72 kilometers per hour). \n \tOstriches are well adapted to a variety of environments, from arid savannas to open plains and deserts. Their plumage is mostly brown, providing effective camouflage in their natural habitats. Ostriches are social birds, typically forming groups called flocks that consist of females and their chicks, while males may form smaller groups or be solitary. Despite their inability to fly, ostriches have strong legs equipped with two-toed, powerful claws, which they use for defensive purposes. When threatened, they can deliver swift and forceful kicks, making them formidable adversaries to potential predators. \n \tOstriches exhibit unique reproductive behaviors. During the breeding season, dominant males establish territories and attract females through elaborate courtship displays. A communal nest is then created, where multiple females lay their eggs. The dominant female and male take turns incubating the eggs during the day and night, respectively. Ostrich chicks, when hatched, are precocial, meaning they are born with their eyes open and are ready to move shortly after birth. Their remarkable adaptability, distinct physical features, and intriguing behaviors make ostriches a fascinating species in the avian world."
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

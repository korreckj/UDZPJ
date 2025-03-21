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
    var confidence: Float = 0.0
    
    init(img: Data?) {
        self.image = img
        runPredictions()
    }
    
    
    public func runPredictions() {
        do {
            guard let ciImage = CIImage(data: self.image!) else {
                fatalError("Could not create ciimage")
            }
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
                self.confidence = classifications.first?.confidence ?? 0.0
                if self.confidence < 5.0 {
                    self.prediction = "Unknown"
                }
                switch self.prediction {
                case "Aardvark":
                    self.information = "\tAardvarks, scientifically classified as Orycteropus afer, are captivating mammals native to Africa. With a medium-sized build, they exhibit a unique appearance characterized by a robust, pig-like body, a lengthy snout, and large, rabbit-like ears. The tough skin covering their bodies features sparse coarse hairs, adding to their distinctive look. Ranging from 1.5 to 2.2 meters in length and typically weighing between 60 to 80 kilograms, aardvarks have adapted to diverse habitats, including grasslands, savannas, and open forests. \n\tNocturnal by nature, aardvarks are most active during the night, and their solitary behavior makes them fascinating creatures. Renowned for their exceptional digging capabilities, aardvarks create extensive burrow systems that serve as both shelter and protection against predators. Their diet primarily consists of ants and termites, which they locate using their keen sense of smell. Equipped with a long, sticky tongue, aardvarks efficiently capture insects from their nests, showcasing their specialized adaptations for survival. \n\tIn terms of reproduction, aardvarks follow a pattern where pregnancies last approximately 7 months, typically resulting in the birth of a single offspring. These mothers provide maternal care by nursing their young for several months until the offspring becomes independent. As of January 2022, aardvarks were classified as \"Least Concern\" on the International Union for Conservation of Nature (IUCN) Red List, although potential threats such as habitat loss and human-wildlife conflict highlight the ongoing importance of monitoring and conservation efforts for these unique mammals."
                
                case "African Pygmy Goose":
                    self.information = "\tTBD"
                
                case "African Spoonbill":
                    self.information = "\tSpoonbills are striking wading birds known for their distinctive spoon-shaped bills and vibrant plumage. There are several species of spoonbills found around the world, including the Roseate Spoonbill (Platalea ajaja) in the Americas, the African Spoonbill (Platalea alba) in Africa, the Eurasian Spoonbill (Platalea leucorodia) in Europe and Asia, and the Black-faced Spoonbill (Platalea minor) in East Asia. The unique bill shape is adapted for their feeding behavior, allowing them to sweep through the water and mud to catch small aquatic invertebrates, fish, and crustaceans. \n\tSpoonbills are often found in wetland habitats such as marshes, swamps, and estuaries where they use their specialized bills to filter-feed in shallow waters. Their pink or white plumage, particularly prominent during the breeding season, adds to their elegance and makes them a visual spectacle in their natural habitats. During courtship displays, spoonbills engage in elaborate behaviors, including synchronized wing-flapping and bill-clattering, creating a captivating sight for observers. \n\tThese graceful birds are known for their communal nesting habits, often breeding in colonies where they build nests on the ground or in trees. Nesting sites are chosen near water sources, ensuring easy access to food for both adults and chicks. Conservation efforts are crucial for the preservation of spoonbills and their habitats, as they face threats such as habitat loss, pollution, and disturbances to their nesting areas. The protection of wetlands and the enforcement of conservation measures are essential for ensuring the continued survival of these captivating and ecologically significant birds."
                
                case "African Spurred Tortoise":
                    self.information = "\tTBD"
                
                case "African Straw-Colored Fruit Bat":
                    self.information = "\tTBD"
                
                case "Allen's Swamp Monkey":
                    self.information = "\tTBD"
                
                case "Alligator Newt":
                    self.information = "\tTBD"
                
                case "Aquatic Caecilian":
                    self.information = "\tTBD"
                
                case "Axolotl":
                    self.information = "\tTBD"
                
                case "Bactrian Camel":
                    self.information = "\tCamels, known for their distinctive humps and remarkable adaptations to arid environments, are sturdy and resilient mammals belonging to the Camelidae family. There are two main species of camels: the dromedary, or one-humped camel (Camelus dromedarius), and the Bactrian camel, with two humps (Camelus bactrianus). These domesticated animals have played crucial roles in the history and cultures of regions with harsh desert climates, providing transportation, food, and companionship. \n\tOne of the most notable features of camels is their humps, which store fat, not water as commonly believed. These humps serve as a crucial energy reserve, allowing camels to survive extended periods without water. Camels are well-adapted to conserve water in their bodies, and their unique physiology enables them to withstand extreme temperature variations in the desert. In addition to their humps, camels possess other adaptations such as tough, heat-reflective coats, split upper lips, and broad, calloused feet that help them navigate the hot and sandy terrain. \n\tCamels are highly social animals that form strong bonds within their herds. They communicate through various vocalizations and body language, and their hierarchical structure is often led by a dominant male. Camels have been domesticated for thousands of years, serving as indispensable companions for desert-dwelling communities. Their ability to carry heavy loads over long distances, their endurance in harsh climates, and their relatively low maintenance requirements make them valuable assets for transportation and trade. As enduring symbols of desert life, camels continue to be respected and appreciated for their contributions to human societies in arid regions."
                
                case "Bald Eagle":
                    self.information = "\tBald eagles (Haliaeetus leucocephalus) hold a distinguished place as one of North America's most iconic birds of prey. Recognized as the national bird and symbol of the United States, they are celebrated for their powerful and majestic presence. These raptors are easily identified by their distinctive white heads and tails, contrasting vividly with their dark brown bodies. With impressive wingspans ranging from 6 to 7 feet and weighing between 6 to 14 pounds, bald eagles are one of the continent's largest birds, embodying strength and grace in their soaring flights. \n\tThe habitat of bald eagles encompasses a range of environments, typically favoring areas near large bodies of open water such as lakes, rivers, and coastal regions. Highly adaptable, they thrive in diverse ecosystems, displaying remarkable flying skills and agility during hunting pursuits. Bald eagles are opportunistic feeders, preying on fish, waterfowl, and occasionally scavenging carrion. Their nests, constructed with sticks and lined with softer materials, are often situated high in trees near their preferred water sources, reflecting their commitment to family and ensuring the survival of their young. \n\tWhile once facing the threat of endangerment due to habitat destruction, pollution, and the pesticide DDT, bald eagles have experienced a significant recovery. Removed from the U.S. Endangered Species List in 2007, they symbolize successful conservation efforts. Beyond their ecological significance, bald eagles embody cultural importance, representing strength, freedom, and resilience in the hearts of many and playing a vital role in maintaining the ecological balance of North American ecosystems."
                    
                case "Beaver":
                    self.information = "\tTBD"
                    
                case "Bison":
                    self.information = "\tBison, often referred to as American buffalo (Bison bison), are iconic symbols of North America and hold a special place in the continent's history and ecology. These massive herbivores once roamed the plains in immense herds, representing a keystone species for the native peoples of North America and playing a crucial role in shaping the landscapes they inhabited. Bison are characterized by their distinct hump, shaggy fur, and formidable curved horns, with males (bulls) being larger than females (cows). Adult bison can weigh up to 2,000 pounds, making them one of the largest land mammals in North America. \n\tHistorically, vast herds of bison migrated across the Great Plains, playing a vital role in maintaining the health of grasslands through their grazing and fertilization activities. However, their populations dramatically declined in the 19th century due to overhunting, habitat loss, and the encroachment of settlers. Conservation efforts have since led to the recovery of bison populations, and today, they are found in protected areas and managed herds across North America. Bison are known for their resilience and adaptability, embodying a conservation success story as they continue to contribute to the restoration of native ecosystems. \n\tBison exhibit fascinating social behaviors within their herds, forming close-knit family groups. During the mating season, bulls engage in impressive displays of strength and dominance to establish breeding rights. The birth of calves usually occurs in the spring, and these young bison, known as \"red dogs\" for their reddish-brown fur, are carefully protected by their mothers within the safety of the herd. As symbols of endurance and the American frontier, bison remain a significant and cherished part of North America's natural heritage."
                    
                case "Chimpanzee":
                    self.information = "\tChimpanzees, scientifically known as Pan troglodytes, are intelligent and social primates that share approximately 98% of their DNA with humans. Native to the forests and savannas of Central and West Africa, chimpanzees are members of the great ape family and exhibit complex behaviors and problem-solving abilities. Physically, they have a robust build, covered in dark hair, with long arms and opposable thumbs, enabling them to grasp objects and use tools. \n\tChimpanzees live in tight-knit communities led by an alpha male, with a social structure marked by alliances, cooperation, and intricate communication. These primates display a wide range of emotions and are known to express joy, sadness, and even empathy. Their tool-making abilities are remarkable, with chimpanzees using sticks, rocks, and leaves for various tasks, including obtaining food and even crafting simple tools for hunting and extracting termites from their nests. The ability to use tools is a clear indicator of their advanced cognitive capacities. \n\tWhile chimpanzees are highly intelligent and share many similarities with humans, they face various threats in the wild, including habitat loss, poaching, and diseases. Conservation efforts are crucial to preserving their natural habitats and ensuring their survival. Chimpanzees also play a significant role in scientific research, providing valuable insights into human evolution, behavior, and cognition. As our closest living relatives, the study of chimpanzees continues to deepen our understanding of the complexity and diversity of primate societies and the broader natural world."
                    
                case "Chinese Alligator":
                    self.information = "\tTBD"
                    
                case "Chinstrap Penguin":
                    self.information = "\tTBD"
                    
                case "Cinereous Vulture":
                    self.information = "\tTBD"
                    
                case "Crowned Lemur":
                    self.information = "\tTBD"
                    
                case "Dwarf Caiman":
                    self.information = "\tTBD"
                    
                case "Eastern Massasauga Rattlesnake":
                    self.information = "\tTBD"
                    
                case "Eastern White-Bearded Wildebeest":
                    self.information = "\tWildebeest, also known as gnus, are large herbivores that belong to the antelope family and are primarily found in the grasslands and savannas of Africa. The two main species of wildebeest are the blue wildebeest (Connochaetes taurinus) and the black wildebeest (Connochaetes gnou). Known for their distinctive appearance with long faces, curved horns, and robust bodies, wildebeest are social animals that often gather in large herds for migration and protection against predators. The migration of wildebeest is one of the most iconic wildlife spectacles, particularly the annual migration of the Serengeti-Mara ecosystem, where vast herds travel across the plains in search of fresh grazing lands. \n\tWildebeest have a varied diet, feeding on grasses and other vegetation. Their grazing activities play a crucial role in shaping the landscape and maintaining the health of grasslands. During the calving season, females give birth to their young in synchronized periods, maximizing the chances of survival for the vulnerable calves. Despite their large numbers, wildebeest populations are vulnerable to predation, particularly during migration when predators such as lions, hyenas, and crocodiles take advantage of the opportunities presented by the mass movement of these herbivores. \n\tConservation efforts are essential to safeguard wildebeest populations, as they face threats such as habitat loss, human-wildlife conflict, and climate change. Protected areas and national parks play a crucial role in preserving the habitats critical for wildebeest survival. These remarkable animals, with their unique behaviors and migration patterns, contribute significantly to the ecological balance of the African savannas, making them an integral part of the continent's iconic wildlife."
                    
                case "Emperor Spotted Newt":
                    self.information = "\tTBD"
                    
                case "Eland":
                    self.information = "\tElands, majestic and resilient antelopes belonging to the genus Taurotragus, are the largest species of antelope native to Africa. These herbivores inhabit a range of environments, including savannas, grasslands, and woodlands, and are known for their adaptability to various habitats. The two main species of elands are the Common Eland (Taurotragus oryx) and the Giant Eland (Taurotragus derbianus), both distinguished by their large, spiral horns and distinctively marked coats. \n\tWith a distinctive appearance marked by long, spiral-shaped horns and a dewlap hanging from their necks, elands are not only impressive in size but also exhibit unique physical characteristics. Males typically have larger and more robust horns than females. Elands are known for their excellent jumping abilities, capable of clearing high obstacles despite their considerable size. Their social structure is often characterized by loose herds, and they are known to form larger groups during the breeding season. Eland communication includes a variety of vocalizations, such as clicks and grunts, and they are skilled browsers, feeding on a diverse range of vegetation. \n\tElands play a significant role in the ecosystems they inhabit, contributing to seed dispersal and vegetation control. They are also sought after by predators, including lions and hyenas, making them an integral part of the African savanna's intricate food web. While elands have historically faced threats such as habitat loss and hunting, conservation efforts are underway to protect these magnificent antelopes and ensure their continued presence in the diverse landscapes they call home."
                    
                case "Flamingo":
                    self.information = "\tFlamingos, recognized for their vibrant pink plumage and distinctive long, slender legs, are wading birds belonging to the family Phoenicopteridae. There are six recognized species of flamingos, and they inhabit a variety of aquatic environments, including salt flats, lagoons, and shallow lakes across Africa, Asia, the Americas, and Europe. Their striking pink coloration is a result of the pigments in the organisms they consume, such as algae and crustaceans, which contain carotenoids that contribute to their iconic hue. \n\tApart from their stunning appearance, flamingos are known for their unique feeding behavior. These birds use their specially adapted bills, which are bent downward, to filter food from the water. By swishing their bills from side to side, they trap tiny organisms, such as algae and small invertebrates, in comb-like structures called lamellae. Flamingos are highly social and often congregate in large flocks, engaging in synchronized movements and vocalizations. Their elaborate courtship displays involve group formations and synchronized dancing, emphasizing their strong social bonds. \n\tThe life cycle of flamingos includes nesting in large colonies, with both parents taking turns incubating the eggs. Flamingo chicks are born with gray plumage and gradually acquire the pink coloration as they consume the pigmented diet provided by their parents. Conservation efforts are crucial for flamingos, as their habitats face threats from pollution, habitat loss, and climate change. By protecting these unique and charismatic birds and their environments, conservationists aim to ensure the continued presence of flamingos in the diverse ecosystems they inhabit."
                    
                case "Gentoo Penguin":
                    self.information = "\tTBD"
                    
                case "Giraffe":
                    self.information = "\tGiraffes, known for their towering necks and distinctive spotted coats, are the world's tallest mammals, gracefully roaming the savannas and open woodlands of Africa. Scientifically classified as Giraffa camelopardalis, these gentle giants are characterized by their long legs, prehensile tongues, and ossicones – the horn-like structures on their heads. With their impressive height, giraffes have an unparalleled vantage point, allowing them to feed on leaves from tall trees that are out of reach for other herbivores. \n\tThe giraffe's iconic spotted coat, which varies in pattern among different subspecies, serves as an effective camouflage in their natural habitats. The characteristic spotted pattern extends to their legs and is a key feature that distinguishes each individual. Despite their size, giraffes are remarkably agile and can reach speeds of up to 35 miles per hour, providing them with a means to escape predators such as lions and hyenas. Their long necks, which can measure up to six feet in length, house seven vertebrae – the same number as in the human neck. \n\tGiraffes are social animals, often forming loose herds that may include both males and females. Their social structure is not rigid, with individuals freely moving between groups. These herbivores spend much of their day feeding on leaves and buds from acacia and other trees, using their long, prehensile tongues to grasp foliage. The conservation status of giraffes has raised concerns, with populations facing threats from habitat loss, poaching, and human-wildlife conflict. Conservation efforts aim to protect giraffes and their habitats, ensuring the continued existence of these iconic and captivating creatures on the African continent."
                    
                case "Gorilla":
                    self.information = "\tLowland gorillas, scientifically known as Gorilla gorilla gorilla, are one of the two subspecies of the western gorilla, the other being the Cross River gorilla (Gorilla gorilla diehli). These magnificent primates inhabit the dense forests and swamps of Central Africa, including countries like Cameroon, Gabon, Equatorial Guinea, and the Republic of Congo. Lowland gorillas exhibit a robust build with broad chests and muscular bodies, and mature males are easily distinguished by the development of a silver-colored patch on their backs, earning them the name \"silverbacks.\" \n\tLiving in cohesive groups called troops, lowland gorillas are highly social animals that engage in complex social behaviors. Troops are typically led by a dominant silverback, who takes charge of protecting the group and making decisions. These gorillas are known for their strong family bonds, and females, or adult females, are vital contributors to the group's social dynamics. Lowland gorillas communicate using a variety of vocalizations, gestures, and facial expressions, displaying a sophisticated system of communication within their tight-knit communities. \n\tLowland gorillas are primarily herbivores, with their diet consisting of fruits, leaves, stems, and occasionally insects. They are integral to the ecosystems they inhabit, contributing to seed dispersal and maintaining the balance of vegetation. Despite their crucial ecological role, lowland gorilla populations face threats from habitat loss due to deforestation, poaching, and infectious diseases. Conservation efforts aim to protect their habitats and mitigate these threats to ensure the survival of these magnificent primates in the wild."
                    
                case "Gray Wolf":
                    self.information = "\tTBD"
                    
                case "Greater Rhea":
                    self.information = "\tTBD"
                    
                case "Green Tree Python":
                    self.information = "\tTBD"
                    
                case "Grizzly Bear":
                    self.information = "\tGrizzly bears, scientifically known as Ursus arctos horribilis, are powerful and iconic mammals found in North America. Recognizable by their distinctive hump on their shoulders, grizzlies have a formidable appearance, with adult males weighing between 600 to 1,200 pounds. Their fur can range in color from light brown to almost black, and they are characterized by the distinctive silver-tipped hairs on their backs and shoulders, giving them a \"grizzled\" appearance. These bears inhabit a variety of ecosystems, including forests, tundra, and alpine meadows, with populations historically found in regions such as Alaska, Canada, and parts of the contiguous United States. \n\tGrizzly bears are omnivorous, displaying a diet that includes a variety of foods such as berries, roots, insects, fish, and occasionally larger mammals. They are known for their exceptional sense of smell, allowing them to detect food sources from miles away. During the salmon spawning season, grizzlies can be observed fishing for salmon in rivers and streams, showcasing their remarkable fishing skills. While grizzlies are often solitary animals, they are not strictly territorial and may share feeding grounds, especially in areas with abundant food resources. \n\tDespite their impressive size and strength, grizzly bears are considered a threatened species in some regions due to habitat loss, human-bear conflicts, and poaching. Conservation efforts focus on habitat preservation, management of human-bear interactions, and education to promote coexistence. Grizzly bears play a crucial role in the ecosystems they inhabit, influencing vegetation growth through their foraging activities and serving as apex predators, contributing to the overall health and balance of their habitats."
                   
                case "Japanese Giant Salamander":
                    self.information = "\tTBD"
                    
                case "Japenese Macaque":
                    self.information = "\tJapanese macaques, scientifically known as Macaca fuscata, are fascinating primates native to the islands of Japan. Also called snow monkeys, they are highly adaptable and can be found in a variety of habitats, ranging from subtropical forests to subalpine areas. Known for their characteristic reddish faces, these medium-sized monkeys are easily recognizable. Japanese macaques are skilled climbers with long limbs and prehensile tails, which help them navigate their diverse environments. \n\tOne distinctive behavior of Japanese macaques is their adaptation to cold climates, particularly evident in the populations that inhabit the snowy regions of Japan. During the winter months, these macaques have been observed engaging in unique behaviors, such as bathing in hot springs to stay warm. This behavior has become iconic and is often associated with the image of snow monkeys relaxing in steaming hot springs surrounded by snow-covered landscapes. The use of hot springs is a cultural phenomenon among certain groups of Japanese macaques and highlights their intelligence and ability to adapt to changing environmental conditions. \n\tJapanese macaques live in complex social structures, organized into matrilineal groups led by a dominant female. These groups consist of multiple generations of related individuals, and social bonds play a crucial role in their daily lives. The monkeys engage in grooming activities as a form of social bonding and communication. Conservation efforts are in place to protect Japanese macaques and their habitats, as they face threats from habitat loss, human-wildlife conflicts, and diseases. These primates hold cultural significance in Japan and are considered a natural treasure, attracting attention and admiration from both locals and visitors alike."
                    
                case "King Penguin":
                    self.information = "\tTBD"
                    
                case "Lappet-faced Vulture":
                    self.information = "\tTBD"
                    
                case "Lion":
                    self.information = "\tAfrican lions, scientifically known as Panthera leo, are majestic big cats that hold the title of the only truly social cats, living in family groups known as prides. These iconic predators are primarily found in the savannas and grasslands of sub-Saharan Africa, where their regal presence and powerful roars make them a symbol of strength and wilderness. African lions are characterized by their tawny-colored fur, with males sporting impressive manes that range from blond to black, and females typically lacking this distinctive feature. Lions are known for their teamwork in hunting and their social structure, which helps them thrive in various ecosystems. \n\tLions are carnivorous predators that primarily feed on large herbivores like wildebeests, zebras, and buffalo. Their cooperative hunting techniques involve strategic teamwork, with the pride working together to bring down prey. Females often take on the role of primary hunters, while males guard the territory and protect the pride. Lionesses give birth to their cubs within the pride, and the cubs are nurtured and protected by the entire group. The roar of a lion is a powerful and distinctive vocalization that serves to communicate with other members of the pride, establishing territory and reinforcing social bonds. \n\tWhile African lions are revered for their strength and charisma, they face numerous challenges to their survival, including habitat loss, human-wildlife conflict, and poaching. Conservation efforts are critical to ensuring the continued existence of these iconic big cats. Various organizations work to protect their natural habitats, reduce conflicts with local communities, and address issues related to trophy hunting. As apex predators, African lions play a crucial role in maintaining the balance of ecosystems and are an integral part of Africa's rich biodiversity."
                    
                case "Macaroni Penguin":
                    self.information = "\tbd"
                    
                case "Mantella":
                    self.information = "\tTBD"
                    
                case "Matamata Turtle":
                    self.information = "\tTBD"
                    
                case "McCord's Box Turtle":
                    self.information = "\tTBD"
                    
                case "Mimic Poison Frog":
                    self.information = "\tTBD"
                    
                case "Miniature Donkey":
                    self.information = "\tTBD"
                    
                case "Narrow-Striped Dwarf Siren":
                    self.information = "\tTBD"
                    
                case "North American River Otter":
                    self.information = "\tTBD"
                    
                case "Ostrich":
                    self.information = "\tThe ostrich (Struthio camelus) is a remarkable flightless bird native to Africa, known for its unique adaptations and distinction as the world's largest and heaviest living bird. Adult male ostriches can reach a height of 9 feet (2.7 meters) and weigh between 220 to 290 pounds (100 to 130 kilograms), while females are slightly smaller. What sets the ostrich apart is its long legs and neck, as well as its distinctively large eyes – the largest of any bird species. With powerful legs, the ostrich is an adept runner and can reach speeds of up to 45 miles per hour (72 kilometers per hour). \n \tOstriches are well adapted to a variety of environments, from arid savannas to open plains and deserts. Their plumage is mostly brown, providing effective camouflage in their natural habitats. Ostriches are social birds, typically forming groups called flocks that consist of females and their chicks, while males may form smaller groups or be solitary. Despite their inability to fly, ostriches have strong legs equipped with two-toed, powerful claws, which they use for defensive purposes. When threatened, they can deliver swift and forceful kicks, making them formidable adversaries to potential predators. \n \tOstriches exhibit unique reproductive behaviors. During the breeding season, dominant males establish territories and attract females through elaborate courtship displays. A communal nest is then created, where multiple females lay their eggs. The dominant female and male take turns incubating the eggs during the day and night, respectively. Ostrich chicks, when hatched, are precocial, meaning they are born with their eyes open and are ready to move shortly after birth. Their remarkable adaptability, distinct physical features, and intriguing behaviors make ostriches a fascinating species in the avian world."
                    
                case "Panamanian Golden Frog":
                    self.information = "\tTBD"
                    
                case "Poison Frog":
                    self.information = "\tTBD"
                    
                case "Polar Bear":
                    self.information = "\tPolar bears, scientifically known as Ursus maritimus, are majestic and powerful carnivores uniquely adapted to the harsh Arctic environment. With a distinctive white fur coat that provides effective camouflage in the snow and ice, polar bears are the largest land carnivores and are well-suited to their frigid habitats. Their powerful limbs and large paws enable them to swim efficiently in the icy waters, making them formidable marine hunters. Found throughout the Arctic Circle, polar bears primarily inhabit sea ice, where they rely on seals as their primary source of food. \n\tPolar bears are highly skilled hunters and swimmers, using sea ice as a platform for hunting seals. They employ a patient stalking technique, waiting by breathing holes in the ice for seals to surface. When on land, polar bears primarily live a solitary lifestyle, with males having vast home ranges that may overlap with those of multiple females. The bears' ability to cover large distances makes them adept navigators in their icy environment. Mothers with cubs, however, form family units, with the mother providing crucial care and guidance to the young bears. \n\tClimate change poses a significant threat to polar bears, as the melting of sea ice reduces their access to their main prey and disrupts their natural behaviors. The loss of their sea ice habitat has prompted concerns about their long-term survival, leading to their classification as a vulnerable species. Conservation efforts focus on mitigating climate change impacts, managing human-bear conflicts, and safeguarding critical polar bear habitats. These efforts are crucial for preserving the iconic polar bear and the delicate Arctic ecosystems they inhabit."
                    
                case "Puerto Rican Crested Toad":
                    self.information = "\tTBD"
                    
                case "Red-Billed Leiothrix":
                    self.information = "\tTBD"
                    
                case "Red Kangaroo":
                    self.information = "\tRed kangaroos (Macropus rufus) are iconic marsupials native to Australia and are the largest of all kangaroo species. These herbivorous mammals are well-adapted to the arid and semi-arid regions of the continent, where they navigate vast expanses of open landscapes. Known for their distinctive reddish-brown fur, powerful hind legs, and long tails, red kangaroos are built for speed and agility. Adult males, known as boomers, can reach lengths of up to 6 feet and weigh over 200 pounds, while females, called flyers, are generally smaller. \n\tOne of the most remarkable features of red kangaroos is their powerful hind legs, which are adapted for hopping and enable them to cover great distances efficiently. They are capable of reaching speeds up to 35 miles per hour, making them one of the fastest land animals. This unique mode of locomotion, known as \"pentapedal\" locomotion, involves using their tail as a fifth limb for balance. Red kangaroos are also known for their incredible leaping ability, covering distances of up to 25 feet in a single bound. \n\tRed kangaroos exhibit social behaviors and live in groups called mobs, typically consisting of females and their offspring, along with a dominant male. The dominant male plays a protective role in the mob, guarding the group and competing with other males for mating rights. These kangaroos are well-adapted to Australia's unpredictable climate, and they have the ability to survive on minimal water by obtaining most of their moisture from the vegetation they consume. As iconic symbols of Australia, red kangaroos continue to capture the fascination of people worldwide, both for their unique physiology and their role in the diverse ecosystems of the Australian continent."
                    
                case "Red-Necked Wallaby":
                    self.information = "\tWallabies, part of the macropod family, are marsupials native to Australia and nearby islands, closely related to kangaroos. Characterized by their powerful hind legs, strong tails, and distinctive pouches, wallabies exhibit a wide range of sizes and adaptations to various habitats. They are herbivores, primarily grazing on grasses and vegetation, and their unique digestive system allows them to efficiently extract nutrients from fibrous plant material. Wallabies are social animals, often forming groups known as mobs, and their hopping motion, facilitated by strong hind limbs, is an efficient means of locomotion. \n\tThere are numerous wallaby species, each with its own ecological niche and distinctive features. For example, the red-necked wallaby (Macropus rufogriseus) is known for its reddish-brown fur on the nape of its neck, while the agile wallaby (Macropus agilis) is named for its remarkable agility and adaptability in navigating diverse environments. Some wallaby species are known for their arboreal habits, while others thrive in open grasslands. The wallaby's pouch serves as a protective environment for their underdeveloped young, allowing them to continue developing after birth in a safe and secure manner. \n\tDespite their seemingly harmless appearance, wallabies face threats in the wild, including habitat loss due to urbanization and agriculture, as well as predation by introduced species. Conservation efforts focus on preserving their natural habitats, managing populations, and addressing human-wildlife conflicts. Wallabies remain an iconic and beloved part of Australia's wildlife, captivating people with their unique behaviors and adaptations to the diverse landscapes they inhabit."
                    
                case "Red Panda":
                    self.information = "\tRed pandas (Ailurus fulgens), often referred to as the \"fire fox,\" are enchanting and elusive mammals native to the eastern Himalayas and southwestern China. Despite their name, red pandas are not closely related to giant pandas but belong to a unique family called Ailuridae. With their distinctive rust-colored fur, cream-colored face markings, and a ringed tail, red pandas boast a captivating and adorable appearance. Their semi-retractable claws and specialized ankle bones allow for skillful climbing, making them well-suited to navigate the tree-dwelling lifestyle of their bamboo-filled habitats. \n\tRed pandas are primarily herbivores, with bamboo comprising the majority of their diet. However, they also consume fruits, berries, acorns, and the occasional insects, showcasing their adaptability in foraging. Their bamboo-rich diet necessitates an efficient digestive system, and red pandas have a specialized wrist bone that functions similarly to a thumb, aiding in grasping bamboo shoots and leaves. Red pandas are known for their solitary nature and are generally active during the early morning and evening hours, while the daytime is often spent nestled in tree branches. \n\tDespite their undeniable charm, red pandas face various threats in the wild, including habitat loss due to deforestation, poaching, and climate change affecting their bamboo habitats. Conservation efforts are underway to protect these unique creatures, involving measures such as habitat preservation, community education, and breeding programs in captivity. As charismatic ambassadors for biodiversity, red pandas continue to capture the hearts of animal enthusiasts around the world, emphasizing the importance of preserving their habitats for future generations to appreciate."
                    
                case "Red Ruffed Lemur":
                    self.information = "\tRed ruffed lemurs (Varecia rubra) are striking and charismatic primates native to the northeastern rainforests of Madagascar. Recognizable by their vibrant red-orange fur and contrasting black faces, these lemurs are among the largest of the lemur species. With their long, bushy tails and tufted ears, red ruffed lemurs display a remarkable appearance that reflects their lively and social nature. Their distinctive coloration serves as a form of communication within their species, helping to convey information about their social structure and reproductive status. \n\tThese lemurs are arboreal creatures, spending the majority of their lives in the treetops. They are highly skilled climbers and leapers, using their strong hind limbs to cover considerable distances through the forest canopy. Red ruffed lemurs are known for their playful and energetic behaviors, engaging in social interactions such as grooming and vocalizations that include distinctive \"honking\" sounds. Within their social groups, led by a dominant female, these lemurs establish strong bonds, contributing to their cooperative and communal lifestyle. \n\tRed ruffed lemurs face significant threats primarily due to habitat destruction, resulting from logging, agriculture, and human encroachment. The loss of their native rainforest habitats puts their populations at risk, leading to their classification as critically endangered by the International Union for Conservation of Nature (IUCN). Conservation efforts focus on habitat preservation, captive breeding programs, and community education to raise awareness about the importance of protecting these unique lemurs and the fragile ecosystems they inhabit in Madagascar."
                    
                
                case "Reticulated Python":
                    self.information = "\tTBD"
                    
                case "Ring-tailed Lemur":
                    self.information = "\tRing-tailed lemurs (Lemur catta) are iconic primates native to the island of Madagascar, easily recognized by their distinctive black-and-white-ringed tails and captivating facial markings. These lemurs are medium-sized, with a robust body and a tail that can be longer than their body. One of their most remarkable features is their unique social behavior. Ring-tailed lemurs are known to live in groups, or troops, with a complex social structure led by a dominant female. Within these groups, lemurs engage in various social interactions, including vocalizations, scent-marking, and \"stink fights,\" where they rub their tails on scent glands and wave them at rivals. \n\tRing-tailed lemurs are highly adaptable and inhabit a range of environments, from dry and spiny forests to gallery forests and even rocky areas. They are omnivores, feeding on a diverse diet that includes fruits, leaves, flowers, insects, and small vertebrates. The adaptation to a varied diet is a testament to their resourcefulness and ability to thrive in different ecological niches. However, like many species in Madagascar, ring-tailed lemurs face threats from habitat loss due to deforestation, logging, and agriculture, as well as challenges posed by climate change. \n\tConservation efforts are crucial to protect ring-tailed lemurs and their unique habitats. The International Union for Conservation of Nature (IUCN) classifies them as endangered due to declining population trends. Initiatives focus on preserving their natural environments, implementing sustainable forestry practices, and educating local communities about the importance of safeguarding these charismatic lemurs. Ring-tailed lemurs play a vital role in Madagascar's ecosystems and are ambassadors for the conservation of the island's extraordinary biodiversity."
                    
                case "Rockhopper Penguin":
                    self.information = "\tTBD"
                    
                case "Sandhill Crane":
                    self.information = "\tTBD"
                    
                case "Scarlet Ibis":
                    self.information = "\tTBD"
                    
                case "Schmidt's Monkey":
                    self.information = "\tTBD"
            
                case "Sloth":
                    self.information = "\tTBD"
                    
                case "Sonoran Spiny-Tailed Iguana":
                    self.information = "\tTBD"
                    
                case "Southern Cassowary":
                    self.information = "\tTBD"
                    
                case "Southern Sea Otter":
                    self.information = "\tSea otters (Enhydra lutris) are charismatic marine mammals that inhabit coastal waters of the North Pacific, from California to Japan. Known for their endearing appearance, sea otters possess dense fur that traps a layer of air, providing insulation against the cold ocean waters. Unlike other marine mammals, they lack a layer of blubber, relying on their fur for warmth. Sea otters spend much of their time floating on their backs at the ocean's surface, using their agile paws to manipulate and consume their prey. \n\tA distinctive behavior of sea otters is their use of tools, particularly when foraging for food. They are known to use rocks and other hard objects to break open the shells of prey such as clams and sea urchins. This tool use demonstrates their high level of intelligence and adaptability in exploiting marine resources. Sea otters are essential for maintaining the health of kelp forests, as they prey on sea urchins, preventing them from overgrazing kelp. The presence of sea otters in an ecosystem has cascading effects, influencing the abundance and diversity of various marine species. \n\tDespite their captivating nature, sea otters have faced significant threats, including historical fur trade that drastically reduced their populations. Conservation efforts and legal protections have contributed to the recovery of some sea otter populations, but they continue to face challenges such as oil spills, habitat degradation, and entanglement in fishing gear. Organizations work tirelessly to protect and preserve sea otters and their coastal habitats, recognizing their ecological importance and the need for ongoing conservation initiatives to ensure the survival of these captivating marine mammals."
                    
                case "Southern White Rhinoceros":
                    self.information = "\tRhinoceroses, commonly known as rhinos, are powerful herbivorous mammals belonging to the family Rhinocerotidae. Five extant species of rhinoceros exist, namely the white rhinoceros, black rhinoceros, Indian rhinoceros, Javan rhinoceros, and Sumatran rhinoceros. These large-bodied creatures are characterized by their thick, protective skin and distinct horns, which are made of keratin, the same protein found in human hair and nails. Rhinos are found in a range of habitats, from savannas and grasslands to dense forests. \n\tRhinos are well-adapted to their environments, utilizing their prehensile upper lips for grasping and browsing on vegetation. They are known for their relatively poor eyesight but possess acute senses of smell and hearing, allowing them to detect potential threats. Unfortunately, rhinoceros populations face severe threats from poaching, driven by the demand for their horns, which are falsely believed to possess medicinal properties in certain cultures. Conservation efforts, including anti-poaching initiatives, habitat protection, and community engagement, are crucial to ensure the survival of these magnificent creatures. \n\tAmong the species, the white rhinoceros (Ceratotherium simum) and the black rhinoceros (Diceros bicornis) are the most well-known. White rhinos are primarily grazers, feeding on grasses, and are characterized by their broad mouths. In contrast, black rhinos are browsers, using their hooked upper lip to select and consume a variety of vegetation. Conservation organizations and governmental initiatives work tirelessly to protect and conserve rhino populations, aiming to secure their habitats, reduce poaching, and raise awareness about the importance of preserving these iconic species for future generations."
                    
                case "Speckled Mousebird":
                    self.information = "\tTBD"
                    
                case "Spur-Winged Lapwing":
                    self.information = "\tTBD"
                    
                case "Taveta Golden Weaver":
                    self.information = "\tTBD"
                    
                case "Tiger":
                    self.information = "\tTigers, majestic big cats belonging to the Panthera tigris species, are renowned for their strength, agility, and distinctive striped coat. As the largest of the big cat species, tigers are characterized by their robust build, powerful limbs, and a pattern of dark vertical stripes that serve as effective camouflage in their natural habitats. There are several subspecies of tigers, each adapted to specific regions, including the Bengal tiger, Siberian tiger, Sumatran tiger, and others. These solitary predators are found in a range of ecosystems, from dense forests and mangrove swamps to grasslands and the snowy expanses of Siberia. \n\tTigers are apex predators, playing a crucial role in maintaining the balance of their ecosystems by controlling herbivore populations. Their hunting prowess is remarkable, with the ability to take down prey much larger than themselves. Tigers are known for their stealth and ambush tactics, relying on their keen senses and powerful muscles to execute precise and lethal attacks. Despite their fearsome reputation, tiger populations are under severe threat due to habitat loss, poaching, and conflicts with humans. Conservation efforts, including protected reserves, anti-poaching initiatives, and community engagement, are essential to secure the survival of these iconic big cats. \n\tThe global conservation status of tigers is precarious, with some subspecies, such as the Sumatran tiger, critically endangered. Initiatives like the Global Tiger Recovery Program aim to double wild tiger populations by addressing threats to their habitats and combating poaching. Conservationists work tirelessly to raise awareness about the importance of preserving tiger habitats and reducing human-wildlife conflicts. Tigers serve as symbols of wild beauty and strength, emphasizing the urgent need to protect these iconic creatures and their habitats for future generations."
                
                case "Unknown":
                    self.information = "\tI'm sorry we couldn't identify the animal from this picture.  Please zoom in, move closer, try a different angle, and try again."
                    
                case "Warthog":
                    self.information = "\tWarthogs, scientifically known as Phacochoerus africanus, are wild members of the pig family found in sub-Saharan Africa. Easily recognizable by their distinctive appearance, warthogs have a compact and robust build, with a prominent pair of tusks that curve upwards and outwards. These tusks, particularly prominent in males, serve both defensive and combative purposes. Despite their fearsome appearance, warthogs are generally herbivorous, feeding on grasses, fruits, and roots, and are well-adapted to surviving in a variety of habitats, from savannas and grasslands to woodlands. \n\tWarthogs are known for their behavior of kneeling and resting on their calloused, bony wrists while foraging or eating. This unique posture, often referred to as \"kneeling,\" provides them with better access to the ground and helps them reach low-growing vegetation. They have keen senses, including a well-developed sense of smell and hearing, which are essential for detecting predators. Warthogs are social animals, typically forming groups called sounders that consist of females and their young. Males may be solitary or form small bachelor groups. \n\tDespite their adaptability, warthogs face various threats, including habitat loss due to human activities, hunting, and predation by large carnivores. They play a crucial role in ecosystems by contributing to soil aeration and seed dispersal through their foraging habits. Conservation efforts aim to address these threats, emphasizing habitat protection, sustainable management practices, and community education to ensure the continued survival of these unique and resilient wild pigs in their natural habitats."
                    
                case "White Stork":
                    self.information = "\tStorks are large, long-legged wading birds belonging to the family Ciconiidae, known for their distinctive appearance and soaring flight. They are found on every continent except Antarctica and are often associated with open habitats, wetlands, and grasslands. Storks are characterized by their long, pointed bills, which they use to catch a variety of prey such as fish, frogs, insects, and small mammals. One of the most well-known species is the White Stork (Ciconia ciconia), recognized for its black-tipped wings and its habit of nesting on rooftops and other structures. \n\tMany stork species are known for their impressive migratory journeys, covering vast distances between breeding and wintering grounds. During migration, storks often travel in large flocks, utilizing thermal updrafts to minimize energy expenditure. Storks are also renowned for their nesting behaviors, with many species building large stick nests in trees or on man-made structures. They are often monogamous, forming strong pair bonds, and both parents participate in incubating the eggs and caring for the chicks. \n\tIn various cultures, storks are symbols of good luck, fertility, and prosperity. The association between storks and babies is a popular cultural motif, and they are often depicted delivering newborns in folklore. Despite their cultural significance, some stork populations face threats such as habitat loss, pollution, and disturbances to their breeding areas. Conservation efforts focus on protecting their nesting sites, preserving wetlands, and raising awareness about the importance of maintaining healthy ecosystems for the survival of these elegant and emblematic birds."
                    
                case "Wolverine":
                    self.information = "\tWolverines (Gulo gulo) are carnivorous mammals known for their stocky and muscular build, as well as their reputation for strength and ferocity. Native to the northern regions of North America, Europe, and Asia, wolverines inhabit remote and harsh environments such as tundra, taiga, and alpine meadows. These elusive creatures are well-adapted to cold climates, equipped with thick fur that insulates them from extreme temperatures. Wolverines have a distinct appearance with a bushy tail, powerful jaws, and sharp claws, contributing to their effectiveness as formidable predators and scavengers. \n\tWolverines are opportunistic feeders, with a diet that includes a variety of prey such as rodents, birds, and carrion. Despite their relatively small size, wolverines are known for their strength and endurance, allowing them to take down larger prey or scavenge from other predators. They are also renowned for their ability to cover vast distances in search of food, utilizing their wide home ranges. Wolverines are solitary animals, and each individual occupies a large territory, often overlapping with the territories of other wolverines. \n\tThe conservation status of wolverines varies across their range, with some populations facing threats from habitat loss, climate change, and trapping. Their elusive nature and remote habitats make it challenging to study and monitor wolverine populations accurately. Conservation efforts focus on preserving their habitats, understanding their ecological roles, and implementing measures to reduce human-wolverine conflicts. Wolverines hold cultural significance in some indigenous communities, and their presence in the wild contributes to the biodiversity and ecological health of the northern ecosystems they inhabit."
                    
                case "Wyoming Toad":
                    self.information = "\tTBD"
                    
                case "Zebra":
                    self.information = "\tZebras, striking members of the horse family Equidae, are known for their distinctive black and white striped coats, making them some of the most easily recognizable and iconic animals in the African savannas. There are three main species of zebras: the plains zebra (Equus quagga), the Grevy's zebra (Equus grevyi), and the mountain zebra (Equus zebra). Each species has its unique characteristics, but all share the striking black and white striping that serves as a form of camouflage, as well as a visual deterrent to predators. \n\tZebras are herbivores, predominantly grazing on grasses, and their social structure is typically organized in family groups led by a dominant male, known as a stallion. These family groups, called harems, are comprised of females and their offspring. Zebras are known for their agility and speed, which they use to escape from predators like lions and hyenas. Interestingly, each zebra's stripe pattern is unique, similar to human fingerprints, allowing for individual recognition within a herd. \n\tDespite their iconic status, zebras face various threats, including habitat loss, competition for resources with livestock, and poaching. Conservation efforts aim to protect their natural habitats, establish wildlife corridors, and address the complex challenges associated with human-wildlife conflicts. Zebras contribute to the biodiversity and balance of African ecosystems, and their conservation is crucial not only for their well-being but for the health of the entire savanna ecosystem they inhabit."
                    
                default:
                    self.information = "No information on file"
                }
            }
            
        }
}

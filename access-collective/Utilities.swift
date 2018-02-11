//
//  Utilities.swift
//  access-collective
//
//  Created by Alex Arnold on 11/2/18.
//

import Foundation
import Firebase

class Layer {
    let name: String
    let image: String
    let markers: [Marker]
    
    init(name: String, image: String, markers: [Marker]) {
        self.name = name
        self.image = image
        self.markers = markers
    }
}

class Marker {
    let name: String
    let description: String
    let latitude: Double
    let longitude: Double
    
    init(name: String, description: String, latitude: Double, longitude: Double) {
        self.name = name
        self.description = description
        self.latitude = latitude
        self.longitude = longitude
    }
}

class Utilities {
    
    static func getLayers(firebaseDatabasePath: String) -> [Layer] {
        print("Started getLayers()")
        let databaseRef = Database.database().reference().child(firebaseDatabasePath)
        var count = 0
        var total = 1
        var layers: [Layer] = []
        
        databaseRef.observe(.value) { snapshot in
            total = 2 * Int(snapshot.childrenCount)
            print("Total = \(total)")
            for layer in snapshot.children {
                print("Layer = \((layer as! DataSnapshot).key)")
                var markers: [Marker] = []
                var image = ""
                
                for marker in (layer as! DataSnapshot).children {
                    print("Marker = \((marker as! DataSnapshot).key)")
                    if ((marker as! DataSnapshot).key == "image") {
                        image = (marker as! DataSnapshot).value as! String
                        if (image != "") {
                            DispatchQueue.global(qos: .background).async {
                                print("Getting image '\(image)' for layer: \((layer as! DataSnapshot).key)")
                                count += Utilities.downloadImage(firebaseStoragePath: image)
                                print("Image obtained!")
                            }
                        } else {
                            count += 1
                        }
                    } else {
                        var info: DataSnapshot
                        var lat = 0.0
                        var long = 0.0
                        var desc = ""
                        
                        for data in (marker as! DataSnapshot).children {
                            info = data as! DataSnapshot
                            if (info.key == "latitude") {
                                lat = info.value as! Double
                                print("Got lat = \(lat) for marker = \((marker as! DataSnapshot).key)")
                            } else if (info.key == "longitude") {
                                long = info.value as! Double
                                print("Got long = \(long) for marker = \((marker as! DataSnapshot).key)")
                            } else if (info.key == "description") {
                                desc = info.value as! String
                                print("Got desc = \(lat) for marker = \((marker as! DataSnapshot).key)")
                            }
                        }
                        print("Creating a new Marker for marker = \((marker as! DataSnapshot).key)")
                        markers.append(Marker(name: (marker as! DataSnapshot).key, description: desc, latitude: lat, longitude: long))
                        print("Marker[\(markers.count-1)]: name = \(markers[markers.count-1].name), lat = \(markers[markers.count-1].latitude), long = \(markers[markers.count-1].longitude), desc = \(markers[markers.count-1].description)")
                    }
                }
                print("Creating a new Layer for layer = \((layer as! DataSnapshot).key)")
                layers.append(Layer(name: (layer as! DataSnapshot).key, image: image, markers: markers))
                for marker in markers {
                    print("Layer[\(layers.count - 1)]: Marker: name = \(marker.name), lat = \(marker.latitude), long = \(marker.longitude), desc = \(marker.description)")
                }
                count += 1
            }
        }
        while (count < total) {
            
        }
        print("Created all the layers for \(firebaseDatabasePath)")
        print("layers[0].markers[0] = \(layers[0].markers[0])")
        return layers
    }
    
    static func downloadImage(firebaseStoragePath: String) -> Int {
        // Get the time the image was last updated (from UserDefaults). Defaults to 0 if it does not exist
        let locallyUpdated = UserDefaults.standard.double(forKey: firebaseStoragePath)
        var completed = false
        
        // Get the metadata for the image
        Storage.storage().reference().child(firebaseStoragePath).getMetadata { metadata, error in
            if let error = error {
                print("Storage metadata error: \(error)")
                completed = true
            } else {
                // If the last time the image was updated in UserDefaults is older than Firebase, download the image
                if ((metadata?.updated?.timeIntervalSince1970)! > locallyUpdated) {
                    let path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
                    let filePath = "file://\(path)/\(firebaseStoragePath)"
                    guard let fileUrl = URL(string: filePath) else {
                        completed = true
                        print("Error getting file URL!")
                        return
                    }
                    
                    let downloadTask = Storage.storage().reference().child(firebaseStoragePath).write(toFile: fileUrl)
                    downloadTask.observe(.resume) { snapshot in
                        print("Download resumed")
                    }
                    downloadTask.observe(.pause) { snapshot in
                        print("Download paused")
                    }
                    downloadTask.observe(.success) { snapshot in
                        print("Saved \(firebaseStoragePath)")
                        UserDefaults.standard.set(metadata?.updated?.timeIntervalSince1970, forKey: firebaseStoragePath)
                        completed = true
                    }
                    downloadTask.observe(.failure) { snapshot in
                        guard let errorCode = (snapshot.error as NSError?)?.code else {
                            completed = true
                            return
                        }
                        guard let error = StorageErrorCode(rawValue: errorCode) else {
                            completed = true
                            return
                        }
                        
                        switch (error) {
                        case .objectNotFound:
                            print("File doesn't exist")
                            break
                        case .unauthorized:
                            print("User doesn't have permission to access file")
                            break
                        case .cancelled:
                            print("User cancelled the download")
                            break
                        case .unknown:
                            print("Unknown error occurred, inspect the server response")
                            break
                        default:
                            print("Another error occurred. This is a good place to retry the download.")
                            break
                        }
                        completed = true
                    }
                } else {
                    print("\(firebaseStoragePath) is already up to date!")
                    completed = true
                }
            }
        }
        while !completed {
            
        }
        return 1
    }
    
    static func loadImage(layerImage: String) -> UIImage! {
        let paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        let filePath = "file:\(paths[0])/\(layerImage)"
        guard let fileUrl = URL(string: filePath) else { return nil }
        
        do {
            let data = try Data(contentsOf: fileUrl)
            return UIImage(data: data)!
        } catch {
            print("\n\nData error: \(error)\n\n")
            return nil
        }
    }
}

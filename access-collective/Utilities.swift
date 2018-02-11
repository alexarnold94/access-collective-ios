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
        self.name = ""
        self.image = ""
        self.markers = []
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
    
    static func getLayers() -> [Layer] {
        let databaseRef = Database.database().reference().child("campusMarkers/UWA Crawley")
        var count = 0
        var total = 1
        var layers: [Layer] = []
        
        databaseRef.observe(.value) { snapshot in
            total = Int(snapshot.childrenCount)
            for layer in snapshot.children {
                var markers: [Marker] = []
                var image = ""
                
                for marker in (layer as! DataSnapshot).children {
                    if ((marker as! DataSnapshot).key == "image") {
                        image = (marker as! DataSnapshot).key
                    }
                    
                    var info: DataSnapshot
                    var lat = 0.0
                    var long = 0.0
                    var desc = ""
                    
                    for data in (marker as! DataSnapshot).children {
                        info = data as! DataSnapshot
                        if (info.key == "latitude") {
                            lat = info.value as! Double
                        } else if (info.key == "longitude") {
                            long = info.value as! Double
                        } else if (info.key == "description") {
                            desc = info.value as! String
                        }
                    }
                    markers.append(Marker(name: (marker as! DataSnapshot).key, description: desc, latitude: lat, longitude: long))
                }
                layers.append(Layer(name: (layer as! DataSnapshot).key, image: image, markers: markers))
                count += 1
            }
        }
        
        print("Total = \(total)")
        while (count < total) {
            
        }
        
        return layers
    }
}

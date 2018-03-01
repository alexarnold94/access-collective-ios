//
//  MapViewController.swift
//  access-collective
//
//  Created by Alex Arnold on 28/1/18.
//

import UIKit
import GoogleMaps
import Firebase

class MapViewController: UIViewController {
    
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    var campus: Campus!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Campus"
        self.progressIndicator.isHidden = false
        self.progressIndicator.startAnimating()
        
        DispatchQueue.global(qos: .background).async {
            self.campus = Utilities.getCampus(forCampus: "UWA Crawley")
            
            DispatchQueue.main.async {
                self.progressIndicator.isHidden = true
                
                // Do any additional setup after loading the view.
                // Create a GMSCameraPosition that tells the map to display the
                // coordinate -33.86,151.20 at zoom level 6.
                let camera = GMSCameraPosition.camera(withLatitude: -31.980905, longitude: 115.818433, zoom: 19.0)
                let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
                self.view = mapView
                
                // Displays all markers on the map (currently all with the default marker)
                for layer in self.campus.layers {
                    print("Creating markers for layer \(layer.name)")
                    for checkpoint in layer.checkpoints {
                        print("Creating checkpoint \(checkpoint.name) in layer \(layer.name)")
                        let mapMarker = GMSMarker()
                        print("Checkpoint: latitude = \(checkpoint.latitude), longitude = \(checkpoint.longitude)")
                        mapMarker.position = CLLocationCoordinate2D(latitude: checkpoint.latitude, longitude: checkpoint.longitude)
                        mapMarker.title = checkpoint.name
                        if (checkpoint.description != "") {
                            mapMarker.snippet = checkpoint.description
                        }
                        mapMarker.icon = Utilities.loadImage(layerImage: layer.image)
                        mapMarker.map = mapView
                    }
                }
                
                /* Debugging purposes - display all the Layers/Markers
                print("Layers: \(self.layers)")
                for layer in self.layers {
                    print("Layer '\(layer.name)'")
                    for marker in layer.markers {
                        print("\tMarker: (\(marker.name), \(marker.description), \(marker.latitude), \(marker.longitude))")
                    }
                } */
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

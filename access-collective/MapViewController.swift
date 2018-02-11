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
    var layers : [Layer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Campus"
        self.progressIndicator.isHidden = false
        self.progressIndicator.startAnimating()
        
        DispatchQueue.global(qos: .background).async {
            self.layers = Utilities.getLayers(firebaseDatabasePath: "campusMarkersTest/UWA Crawley")
            
            DispatchQueue.main.async {
                self.progressIndicator.isHidden = true
                
                // Do any additional setup after loading the view.
                // Create a GMSCameraPosition that tells the map to display the
                // coordinate -33.86,151.20 at zoom level 6.
                print("Creating map")
                let camera = GMSCameraPosition.camera(withLatitude: -31.980905, longitude: 115.818433, zoom: 19.0)
                let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
                self.view = mapView
                
                // Creates a marker in the center of the map.
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: -31.979908, longitude: 115.818039)
                marker.title = "Sydney"
                marker.snippet = "Australia"
                marker.map = mapView
                
                print("Layers: \(self.layers)")
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

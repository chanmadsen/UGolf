//
//  MapViewController.swift
//  UGolf
//
//  Created by Bryan Gomez on 9/20/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    private let locationService = LocationService()
    
    
    //MARK: - Alert for LocationServicesDelegate.
    private lazy var locationAlert: UIAlertController = {
        let alertController = UIAlertController(title: "Location Authorization", message: "UGolf can provide the nearby gold courts based on your current location. To change the location permission please update Privay Settings.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let settingsAction = UIAlertAction(title: "Update settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        return alertController
    }()
    
    //MARK: - Private funcs
    func centerViewOnUserLocation(){
        if let location = locationService.locationManager.location?.coordinate {
                let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
                mapView.setRegion(region, animated: true)
            }
        }
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationService.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        centerViewOnUserLocation()
    }
}

//MARK: - Location Service Delegate
extension MapViewController: LocationServicesDelegate {
    func authorizationDenied() {
        // Happens on main threath
        DispatchQueue.main.async { [weak self] in  // prevent memnory leak
            guard let strongSelf = self else { return }
            
            strongSelf.present(strongSelf.locationAlert, animated: true, completion: nil)
        }
    }
    
    func setMapRegion(center: CLLocation) {
        // Capture map region that will be displayed.
        let mapRegion = MKCoordinateRegion(center: center.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        // Zoom in on mapView with the mapRegion created.
        DispatchQueue.main.async { [weak self] in
            self?.mapView.setRegion(mapRegion, animated: true)
        }
    }
}

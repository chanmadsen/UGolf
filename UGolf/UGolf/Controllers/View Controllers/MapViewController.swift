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
    @IBOutlet weak var controllView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchViewTopConstrain: NSLayoutConstraint!
    
    //MARK: - Properties
    private let locationManager = CLLocationManager()
    
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        //View
        costumeViewLayouts()
        
    }
    //MARK: - Actions
    @IBAction func didTapUserLocation(_ sender: UIButton) {
        // center the annotation to the map view region.
        centerToUserLocation()
    }
    
    @IBAction func didTapSearchButton(_ sender: UIButton) {
        searchView(shown: true)
    }
    @IBAction func didTapCloseSlideView(_ sender: UIButton) {
        searchView(shown: false)
    }
    
    
    //MARK: - Private funcs
    
    private func searchView(shown: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let strongSelf = self else { return }
            let viewHeight = strongSelf.searchView.frame.size.height
            
            strongSelf.searchViewTopConstrain.constant = shown ? -1 * viewHeight : 0
            strongSelf.view.layoutIfNeeded()
        }
    }
    
    private func costumeViewLayouts() {
        controllView.layer.cornerRadius = 10.0
        searchView.layer.cornerRadius = 20.0
    }
    
    private func centerToUserLocation() {
        let mapRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        self.mapView.setRegion(mapRegion, animated: true)
    }
    
//    private func centerViewOnUserLocation(){
//        if let location = locationManager.location?.coordinate {
//            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
//            mapView.setRegion(region, animated: true)
//        }
//    }

    private func deniedAlert() {
        let alertController = UIAlertController(title: "Location Authorization", message: "UGolf can provide the nearby gold courts based on your current location. To change the location permission please update Privay Settings.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let settingsAction = UIAlertAction(title: "Update settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        present(alertController, animated: true)
    }
}
//MARK: - CLLocation Delegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        
        case .notDetermined:
            // For use when the app is open
            manager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            deniedAlert()
        case .authorizedAlways:
            manager.startUpdatingLocation()
        // For use when the app is open
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        @unknown default:
            break
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .restricted:
            print("\nUsers location is restricted")
            
        case .denied:
            print("\nUser denied access to use their location\n")
            
        case .authorizedWhenInUse:
            print("\nuser granted authorizedWhenInUse\n")
            
        case .authorizedAlways:
            print("\nuser selected authorizedAlways\n")
            
        default: break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        
        // Get current location
        if let location = locations.last {
                let mapRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.mapView.setRegion(mapRegion, animated: true)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

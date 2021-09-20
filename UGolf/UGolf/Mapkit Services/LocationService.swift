//
//  LocationService.swift
//  UGolf
//
//  Created by Bryan Gomez on 9/20/21.
//

import Foundation
import CoreLocation

protocol LocationServicesDelegate: AnyObject {
    func authorizationDenied()
    func setMapRegion(center: CLLocation)
}
class LocationService: NSObject {
    
    var locationManager = CLLocationManager()
    weak var delegate: LocationServicesDelegate?
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestLocation()
    }
}

//MARK: - CLLocationManager Delegate
extension LocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        
            case .notDetermined:
                // For use when the app is open
                manager.requestWhenInUseAuthorization()
            case .restricted:
                break
            case .denied:
                delegate?.authorizationDenied()
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
            delegate?.setMapRegion(center: location) // center is equal to the last location of user.
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

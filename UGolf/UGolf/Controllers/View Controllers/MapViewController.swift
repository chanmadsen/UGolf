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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    //MARK: - Properties
    private let locationManager = CLLocationManager()
    private var poiType: POIType?
    private var pois = [POI]()
    private var mapCenterLocation: CLLocation?
    
    // Search Completion properties
    private var searchCompleter = MKLocalSearchCompleter()
    private var completerResults = [MKLocalSearchCompletion]()
    private var completerSearch = false
    
    
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchCompleter.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        // currentLocation when app is first open.
        mapCenterLocation = CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
        
        //View
        costumeViewLayouts()
        
        
        
    }
    //MARK: - Actions
    @IBAction func didTapUserLocation(_ sender: UIButton) {
        // center the annotation to the map view region.
        centerToUserLocation()
    }
    
    @IBAction func didTapSearchButton(_ sender: UIButton) {
        self.poiType = nil
        searchView(shown: true)
    }
    @IBAction func didTapCloseSlideView(_ sender: UIButton) {
        closeSlideView()
    }
    @IBAction func didTapPoiButton(_ sender: UIButton) {
        completerSearch = false
        clearSearchTextField()
        // when the user types on the "golf courses" button
        switch sender.tag {
        case 0:
            poiType = .golfcourse
        case 1:
            poiType = .golfstores
        case 2:
            poiType = .restaurants
        default:
            break
        }
        searchPOI()
    }
    
    @IBAction func textFieldEditingChange(_ sender: UITextField) {
        // capture text and pass it into search completer.
        poiType = .pin
        
        if let text = sender.text {
            searchCompleter.queryFragment = text
        }
    }
    
    //MARK: - Private funcs
    
    private func setMapRegion(center: CLLocation) {
        let mapRegion = MKCoordinateRegion(center: center.coordinate, latitudinalMeters: 1000, longitudinalMeters:  1000)
            self.mapView.setRegion(mapRegion, animated: true)
    }
    
    private func centerMap(to poi: POI) {
        setMapRegion(center: CLLocation(latitude: poi.coordinate.latitude, longitude: poi.coordinate.longitude))
        closeSlideView()
    }
    
    private func closeSlideView() {
        clearSearchTextField()
        searchView(shown: false)
    }
    
    private func clearSearchTextField() {
        searchTextField.text = nil
        searchTextField.resignFirstResponder()
    }
    
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
    //MARK: - Search Funcs
    
    private func search(for searchText: String, around center: CLLocationCoordinate2D? = nil, completion:  @escaping ([MKMapItem]) -> Void) {
        // search within this region

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        
        if let center = center {
            let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
            request.region = region
        }
        
        
        MKLocalSearch(request: request).start { response, error in
            if error != nil {
                return
            }
            
            guard let response = response else { return }
            completion(response.mapItems)
        }
    }
    
    // searching for POI
    private func searchPOI() {
        guard let poiType = poiType else { return }
        search(for: poiType.rawValue , around: mapView.centerCoordinate) { [weak self] mapItems in
            self?.updateSearchResult(with: mapItems)
        }
    }
    
    private func updateSearchResult(with mapItems: [MKMapItem]) {
        pois.removeAll()
        
        for mapItem in mapItems {
            if let name = mapItem.name, let address = mapItem.placemark.formattedAddress, let poiType = poiType {
                let poi = POI(title: name, address: address, coordinate: mapItem.placemark.coordinate, poiType: poiType)
                pois.append(poi)
            }
        }
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(pois)
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

//MARK: - Tableview delegate & data source
extension MapViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completerSearch ? completerResults.count : pois.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        
        if completerSearch {
            let result = completerResults[indexPath.row]
            cell.textLabel?.attributedText = highlight(text: result.title, rangeValues: result.titleHighlightRanges)
            cell.detailTextLabel?.attributedText = highlight(text: result.subtitle, rangeValues: result.subtitleHighlightRanges)
        } else {
            let poi = pois[indexPath.row]
            cell.textLabel?.text = poi.title
            cell.detailTextLabel?.text = poi.subtitle
            cell.detailTextLabel?.numberOfLines = 0
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if completerSearch {
            let searchResult = completerResults[indexPath.row]
            search(for: searchResult.title) { [weak self] mapItems in
                guard let weakSelf = self else { return }
                
                weakSelf.updateSearchResult(with: mapItems)
                let poi = weakSelf.pois[0]
                weakSelf.centerMap(to: poi)
                
            }
        } else {
            let poi = pois[indexPath.row]
            mapView.addAnnotation(poi)
            centerMap(to: poi)
        }
        completerResults.removeAll()
        pois.removeAll()
    }
    
    private func highlight(text: String, rangeValues: [NSValue]) -> NSAttributedString {
        let attributes = [NSAttributedString.Key.backgroundColor: UIColor.yellow]
        let highlightedString = NSMutableAttributedString(string: text)
        
        let ranges = rangeValues.map({ $0.rangeValue })
        
        ranges.forEach { range in
            highlightedString.addAttributes(attributes, range: range)
        }
        return highlightedString
    }
}

//MARK: - MKLocalSearchCompleter Delegate
extension MapViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completerSearch = true
        completerResults = completer.results
        tableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
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

//MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if let poiType = poiType, poiType != .pin { // will only update if its a POI not a pin(Search)
            let newCenterLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
            
            if let previousMapCenterLocation = mapCenterLocation {
                // Refresh the POI search if center moves 500 m from previous center.
                if newCenterLocation.distance(from: previousMapCenterLocation) > 500 {
                    // Update points of search result
                    mapCenterLocation = newCenterLocation
                    searchPOI()
                }
            }
        }
    }
}

//MARK: - TextField Delegate
extension MapViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
//MARK: - ScrollView Delegate
extension MapViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchTextField.resignFirstResponder()
    }
}


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
    @IBOutlet weak var directionView: UIView!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tripTimeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var directionViewTopConstraint: NSLayoutConstraint!
    
    //MARK: - Properties
    private let locationManager = CLLocationManager()
    private var poiType: POIType?
    private var pois = [POI]()
    private var mapCenterLocation: CLLocation?
    private var previousPinLocation: CLLocation?
    private var routes = [MKRoute]()
    private var routeIndex = 0
    private var selectedAnnotation: MKAnnotationView?
    private var mapHasRoute = false
    
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
        registerAnnotationView()
        
        //View
        costumeViewLayouts()
        
        
        
    }
    //MARK: - UI
    private func costumeViewLayouts() {
        controllView.layer.cornerRadius = 10.0
        searchView.layer.cornerRadius = 20.0
        directionView.layer.cornerRadius = 20.0
        goButton.layer.cornerRadius = 8.0
    }
    //MARK: - Actions
    @IBAction func didTapUserLocation(_ sender: UIButton) {
        // center the annotation to the map view region.
        centerToUserLocation()
    }
    
    @IBAction func didTapSearchButton(_ sender: UIButton) {
        self.poiType = nil
        searchView(shown: true)
        directionView(shown: false)
    }
    @IBAction func didTapCloseSlideView(_ sender: UIButton) {
        closeSlideView()
        
        if sender.tag == 1 {
            clearMapView()
        }
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
    
    // Use Reverce GEOcode to get address from a pin.
    @IBAction func didLongPressedGesture(_ sender: UILongPressGestureRecognizer) {
        // First, get location of tap point
        let point = sender.location(in: mapView)
        
        // Second, turn it into a coordinate.
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        // Third, prevent multiple pins for tapped location.
        if previousPinLocation == nil || previousPinLocation!.distance(from: location) > 10 {
            previousPinLocation = location
            
            // Reverse GEOCODE to get address of locationb
            CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemark, error in
                if error != nil {
                    return
                }
                
                if let clPlacemark = placemark?.first {
                    // create mkplacemark
                    let placemark = MKPlacemark(placemark: clPlacemark)
                    
                    // get address now.
                    if let address = placemark.formattedAddress {
                        let poi = POI(title: "Pinned Location", address: address, coordinate: coordinate, poiType: .pin)
                        
                        // drop pin into map view
                        self?.mapView.addAnnotation(poi)
                        
                    }
                }
            }
        }
    }
    @IBAction func didTapGesture(_ sender: UITapGestureRecognizer) {
        closeSlideView()
        
        let touchPoint = sender.location(in: mapView)
        let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let mapPoint = MKMapPoint(touchCoordinate)
        
        // store the route object
        var myRoutes = [MKRoute]()
        var routeIndex = 0
        
        // mapoverLay
        for overlay in mapView.overlays {
            if overlay is MKPolyline, let polylineRenderer = mapView.renderer(for: overlay) as? MKPolylineRenderer {
                // get point of touch
                let polylinePoint = polylineRenderer.point(for: mapPoint)
                
                // check if the point is within route,
                if polylineRenderer.path.contains(polylinePoint) {
                    if let title = overlay.title, let indexString = title, let index = Int(indexString) {
                        routeIndex = index
                        myRoutes.append(routes[routeIndex])
                        break // only capture new primary route.
                    }
                }
            }
        }
        
        // remaining routes
        if !myRoutes.isEmpty {
            for (index, route) in routes.enumerated() {
                if index != routeIndex { // not equal to primary route index
                    myRoutes.append(route)
                }
            }
            routes = myRoutes
            renderRoutes()
        }
    }
    
    @IBAction func didTapGo(_ sender: UIButton) {
        // Navigate to Apple maps
        guard let poi = selectedAnnotation?.annotation as? POI else { return }
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        let placemark = MKPlacemark(coordinate: poi.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.openInMaps(launchOptions: launchOptions)
        
    
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
        directionView(shown: false)
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
    
    private func directionView(shown: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.directionViewTopConstraint.constant = shown ? -150 : 100
            strongSelf.view.layoutIfNeeded()
        }
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
    
    
//    private func addAnnotation(for poi: POI) {
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = poi.coordinate
//        annotation.title = poi.title
//        annotation.subtitle = poi.subtitle
//
//        mapView.addAnnotation(annotation)
//    }
    
    // registering the class.
    private func registerAnnotationView() {
        //mapView.register(POIAnnotaionView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        // for costume annotation.
        mapView.register(POIMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        // for costume cluster.
        mapView.register(POIClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    private func showDirection(to poi: POI) {
        clearMapView()
        routes.removeAll()
        
        selectedAnnotation?.annotation = poi
        
        // populate lable as well as direction request.
        if let destinationTitle = poi.title {
            destinationLabel.text = "To \(destinationTitle)"
            addressLabel.text = poi.subtitle
        }
        
        // creating request for directions.
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: mapView.userLocation.coordinate)) // start of route.
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: poi.coordinate))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        // set directions.
        let directions = MKDirections(request: request)
        directions.calculate { [weak self] response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let response = response else { return }
            self?.routes = response.routes // get routes.
            // call renderRoutes
            self?.renderRoutes()
        }
    }
    
    // render routes we have
    private func renderRoutes() {
        var primaryRoute = MKRoute()
    
        for route in routes {
            if routeIndex == 0 {
                primaryRoute = route
            } else {
                mapView.addOverlay(route.polyline, level: .aboveRoads)
            }
            routeIndex += 1
        }
        mapHasRoute = true
        routeIndex = 0
        mapView.addOverlay(primaryRoute.polyline, level: .aboveRoads)
        mapView.setVisibleMapRect(primaryRoute.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 80, left: 80, bottom: 200, right: 80), animated: true)
        
        tripTimeLabel.text = "\(Int(primaryRoute.expectedTravelTime/60)) min"
        distanceLabel.text = distanceStringByLocale(distance: primaryRoute.distance)
        
        if let poi = selectedAnnotation?.annotation {
            mapView.addAnnotation(poi)
        }
        
        directionView(shown: true)
    }
    
    private func distanceStringByLocale(distance: Double) -> String {
        if let locale = Locale.current.regionCode, locale.caseInsensitiveCompare("US") == .orderedSame {
            return String(format: "%.1f mi", distance/1609.344)
        }
        // if not in the usa
        if distance / 1000 < 1 {
            return "\(distance) m"
        }
        
        return "\(Int(distance/1000)) km"
    }
    
    private func clearMapView() {
        mapHasRoute = false
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        mapView.deselectAnnotation(selectedAnnotation?.annotation, animated: true)
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
        
        mapView.removeAnnotations(mapView.annotations)
        
        for mapItem in mapItems {
            if let name = mapItem.name, let address = mapItem.placemark.formattedAddress, let poiType = poiType {
                let poi = POI(title: name, address: address, coordinate: mapItem.placemark.coordinate, poiType: poiType)
                
                // add annotation
                //addAnnotation(for: poi)
                pois.append(poi)
            }
        }
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
        
        if let poiType = poiType, poiType != .pin && !mapHasRoute { // will only update if its a POI not a pin(Search)
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let poi = view.annotation as? POI else { return }
        
        // request direction of this POI
        showDirection(to: poi)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        var renderer = MKPolylineRenderer()
        
        if let polyline = overlay as? MKPolyline {
            polyline.title = "\(routeIndex)"
            let routeColor = routeIndex == 0 ? UIColor(red: 66/255, green: 167/255, blue: 244/255, alpha: 1.0) : UIColor(red: 163/255, green: 212/255, blue: 247/255, alpha: 0.7)
            
            renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = routeColor
        }
        return renderer
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        selectedAnnotation = view
    }
    
    // call when annottion is added to the map view.
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        guard let annotation = annotation as? MKPointAnnotation, let poiType = poiType else { return nil }
//
//        let identifier = "pinView-\(poiType.rawValue)"
//        let annotationView: MKMarkerAnnotationView
//
//        if let view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
//            view.annotation = annotation
//            annotationView = view
//        } else {
//            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            annotationView.canShowCallout = true
//
//            let addressLabel = UILabel()
//            addressLabel.numberOfLines = 0
//            addressLabel.text = annotation.subtitle
//            addressLabel.font = UIFont.systemFont(ofSize: 12)
//
//            annotationView.detailCalloutAccessoryView = addressLabel
//        }
//        return annotationView
//    }
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


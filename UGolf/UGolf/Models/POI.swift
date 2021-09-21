//
//  POI.swift
//  UGolf
//
//  Created by Bryan Gomez on 9/21/21.
//

import MapKit

enum POIType: String {
    case golfcourse
    case golfstores
    case restaurants
    
    // default pin that will be used for searchBar
    case pin
}

class POI: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    let poiType: POIType
    
    init(title: String, address: String, coordinate: CLLocationCoordinate2D, poiType: POIType) {
        self.title = title
        self.subtitle = address
        self.coordinate = coordinate
        self.poiType = poiType
    }
}

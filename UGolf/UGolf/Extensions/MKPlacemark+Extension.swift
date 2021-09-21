//
//  MKPlacemark+Extension.swift
//  UGolf
//
//  Created by Bryan Gomez on 9/21/21.
//

import MapKit

extension MKPlacemark {
    var formattedAddress: String? {
        guard let streetNumber = subThoroughfare, let streetName = thoroughfare, let city = locality, let state = administrativeArea, let zip = postalCode else {
            if let title = title {
        return "\(title)"
    } else {
        return nil
        }
    }
        
        let address = "\(streetNumber) \(streetName), \(city), \(state) \(zip)"
        return address
    }
}

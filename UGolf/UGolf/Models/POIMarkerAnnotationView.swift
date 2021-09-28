//
//  POIMarkerAnnotationView.swift
//  UGolf
//
//  Created by Bryan Gomez on 9/24/21.
//

import Foundation
import MapKit

/// Here we will
class POIMarkerAnnotationView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let poi = newValue as? POI else { return }
            
            let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30)))
            
            //if let poiImage = UIImage(named: "poi-\(poi.poiType.rawValue)"), let pinImage = UIImage(named: "\(poi.poiType.rawValue)") {
            if let buttonImage = UIImage(systemName: "arrowshape.turn.up.right.fill"), let pinImage = UIImage(named: "\(poi.poiType.rawValue)") {
                button.setBackgroundImage(buttonImage, for: .normal)
                    // overriding the marker ballon to the picture of our choice.
                glyphImage = pinImage
            }
            clusteringIdentifier = "poiCluster" // Will make it so that nearby poi cluster into 1. 
            canShowCallout = true
            markerTintColor = poi.tintColor
            leftCalloutAccessoryView = button
            
            let addressLabel = UILabel()
            addressLabel.numberOfLines = 0
            addressLabel.text = poi.subtitle
            addressLabel.font = UIFont.systemFont(ofSize: 12)
            
            detailCalloutAccessoryView = addressLabel
        }
    }
}

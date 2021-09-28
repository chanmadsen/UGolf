//
//  POIAnnotationView.swift
//  UGolf
//
//  Created by Bryan Gomez on 9/22/21.
//

import Foundation
import MapKit

class POIAnnotaionView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            // annotation costume view that will display in map.
            // will prepare annotation image.
            guard let poi = newValue as? POI else { return }
            
            // button
            let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 30, height: 30)))
            
            
            // display the correct POI image for the one selected.
            
            if let poiImage = UIImage(named: "poi-\(poi.poiType.rawValue)") {
                button.setBackgroundImage(poiImage, for: .normal)
                
                // image display scale
                if let scaledImage = resize(image: poiImage, newSize: CGSize(width: 30, height: 30)) {
                    image = scaledImage
                }
            }
            canShowCallout = true
            leftCalloutAccessoryView = button // button will be displayed on left side of file.
        }
    }
    // Resize Image
    func resize(image: UIImage, newSize: CGSize) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

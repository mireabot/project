//
//  LocationMan.swift
//  HRSpot.Me
//
//  Created by Mikhail Kolkov  on 01.07.2020.
//  Copyright © 2020 MKM.LLC. All rights reserved.
//

import Foundation
import MapKit

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    private let locationmanager = CLLocationManager()
    @Published var location: CLLocation? = nil
    
    override init() {
        super.init()
        self.locationmanager.delegate = self
        self.locationmanager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationmanager.distanceFilter = kCLDistanceFilterNone
        self.locationmanager.requestWhenInUseAuthorization()
        self.locationmanager.startUpdatingHeading()
    }
}
extension LocationManager {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        self.location = location
    }
}

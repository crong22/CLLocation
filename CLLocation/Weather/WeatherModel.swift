//
//  WeatherModel.swift
//  CLLocation
//
//  Created by 여누 on 6/23/24.
//

import UIKit

class UserLocationInformation {
    var country: String
    var administrativeArea: String
    var subAdministrativeArea: String?
    var locality: String
    var thoroughFare: String
    var subThoroughFare: String
    
    init(country: String, administrativeArea: String, locality: String, thoroughFare: String, subThoroughFare: String) {
        self.country = country
        self.administrativeArea = administrativeArea
        self.locality = country
        self.thoroughFare = thoroughFare
        self.subThoroughFare = subThoroughFare
    }
}

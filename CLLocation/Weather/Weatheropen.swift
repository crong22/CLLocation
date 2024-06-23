//
//  Weatheropen.swift
//  CLLocation
//
//  Created by 여누 on 6/23/24.
//

import UIKit
import CoreLocation

struct Weather : Decodable {
    let main : weather
    let weather : [weatherdetail]
    let wind : wind
}


struct weather : Decodable {
    let feels_like : Double
    let humidity : Int
}

struct weatherdetail : Decodable {
    let icon : String
}

struct wind : Decodable {
    let speed : Double
}

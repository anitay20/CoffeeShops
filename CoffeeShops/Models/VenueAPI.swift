//
//  VenueAPI.swift
//  CoffeeShops
//
//  Created by anita on 12/11/18.
//  Copyright © 2018 anita. All rights reserved.
//

import Foundation

struct Venue: Decodable {
    let id: String
    let name: String
    let location: Location
    
    struct Location: Decodable {
        let lat: Double
        let lng: Double
        let formattedAddress: [String]
    }
}

struct VenueAPIResponse: Decodable {
    let response: Response
}

struct Response: Decodable {
    let groups: [Place]
}

struct Place: Decodable {
    let items: [Item]
}

struct Item: Decodable {
    let venue: Venue
}

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
    
    let url: String?
    let price: Price?
    let rating: Double?
    let bestPhoto: BestPhoto?

    struct Location: Decodable {
        let lat: Double
        let lng: Double
        let formattedAddress: [String]
    }
    
    struct Price: Decodable {
        let currency: String
    }
    
    struct BestPhoto: Decodable {
        let suffix: String
    }
}

struct VenueAPIResponse: Decodable {
    let response: Response
}

struct Response: Decodable {
    let groups: [Place]?
    let venue: Venue?
}

struct Place: Decodable {
    let items: [Item]
}

struct Item: Decodable {
    let venue: Venue
}

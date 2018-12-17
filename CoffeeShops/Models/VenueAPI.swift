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
    
    let categories: [Category]
    let url: String?
    let price: Price?
    let rating: Double?
    let listed: Listed?
    let bestPhoto: BestPhoto?

    struct Location: Decodable {
        let distance: Int
        let lat: Double
        let lng: Double
        let formattedAddress: [String]
    }
    
    struct Category: Decodable {
        let name: String
    }
    
    struct Price: Decodable {
        let currency: String
    }
    
    struct Listed: Decodable {
        let groups: [ListedGroup]
        
        struct ListedGroup: Decodable {
            let items: [Detail]
            
            struct Detail: Decodable {
                let description: String
            }
        }
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

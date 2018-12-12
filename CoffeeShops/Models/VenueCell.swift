//
//  VenueCell.swift
//  CoffeeShops
//
//  Created by anita on 12/11/18.
//  Copyright © 2018 anita. All rights reserved.
//

import UIKit

class VenueCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    func configureTheCell(_ venue: Venue) {
        self.nameLabel.text = venue.name
        let address = venue.location.formattedAddress.joined(separator: " ")
        self.addressLabel.text = address
    }
}

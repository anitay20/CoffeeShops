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
        self.imgView.image = UIImage(named: "ImagePlaceholder")
//        do {
//            let baseUrl = "https://fastly.4sqi.net/img/general/200x200"
//            guard let bestPhoto = venue.bestPhoto else { return }
//            let url = baseUrl + bestPhoto.suffix
//            print("URL is: \(url)")
//            if let imageURL = URL(string: url) {
//                let imageData = try Data(contentsOf: imageURL)
//                self.imgView.image = UIImage(data: imageData)
//            }
//        } catch {
//                print("Error fetching image: \(error)")
//        }
        
        let baseUrl = "https://fastly.4sqi.net/img/general/200x200"
        guard let bestPhoto = venue.bestPhoto else { return }
        let url = baseUrl + bestPhoto.suffix
        print("URL: \(url)")
        self.imgView.downloadImageFrom(link: url, contentMode: .scaleAspectFit)

        self.nameLabel.text = venue.name
        self.addressLabel.text = venue.location.formattedAddress[0]
        self.ratingLabel.text = venue.rating?.description
        self.priceLabel.text = venue.price?.currency
    }
}

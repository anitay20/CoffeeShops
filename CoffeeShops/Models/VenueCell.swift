//
//  VenueCell.swift
//  CoffeeShops
//
//  Created by anita on 12/11/18.
//  Copyright © 2018 anita. All rights reserved.
//

import UIKit
import Kingfisher

class VenueCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
//    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    func configureTheCell(_ venue: Venue) {
        
        // image
        let baseUrl = "https://fastly.4sqi.net/img/general/200x200"
        guard let bestPhoto = venue.bestPhoto else { return }
        let url = URL(string: baseUrl + bestPhoto.suffix)
        let placeholder = UIImage(named: "ImagePlaceholder")
        let processor = DownsamplingImageProcessor(size: CGSize(width: 100, height: 100)) >> RoundCornerImageProcessor(cornerRadius: 20)
        
        self.imgView.kf.setImage(with: url, placeholder: placeholder, options: [.processor(processor), .cacheOriginalImage]) {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
        
        self.nameLabel.text = venue.name
        self.addressLabel.text = venue.location.formattedAddress[0]
        
        let descriptions = venue.listed?.groups[0].items.map { $0.description }
        self.descriptionLabel.text = getDescription(descriptions!)

        self.ratingLabel.text = venue.rating?.description
        self.priceLabel.text = venue.price?.currency
    }
    
    func getDescription(_ descriptions: [String]) -> String {
        let newDescription = descriptions.filter { $0 != "" }
        return newDescription.count == 0 ? "" : newDescription[0]
    }
}

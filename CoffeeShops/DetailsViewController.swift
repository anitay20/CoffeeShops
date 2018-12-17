//
//  DetailsViewController.swift
//  CoffeeShops
//
//  Created by anita on 12/14/18.
//  Copyright © 2018 anita. All rights reserved.
//

import UIKit
import Kingfisher
import MapKit

class DetailsViewController: UIViewController, MKMapViewDelegate {

    var venue: Venue!
    var location = CLLocationCoordinate2D()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearances()
        setupData()
        
        location = CLLocationCoordinate2D(latitude: venue.location.lat, longitude: venue.location.lng)
        mapView.delegate = self
        setupMapView()
        addVenuePin()
        viewDidLayoutSubviews()
    }
    
    func setupData() {
        // image
        let baseUrl = "https://fastly.4sqi.net/img/general/200x200"
        guard let bestPhoto = venue.bestPhoto else { return }
        let url = URL(string: baseUrl + bestPhoto.suffix)
        let placeholder = UIImage(named: "ImagePlaceholder")
        let processor = DownsamplingImageProcessor(size: CGSize(width: 200, height: 200)) >> RoundCornerImageProcessor(cornerRadius: 20)
        
        imageView.kf.setImage(with: url, placeholder: placeholder, options: [.processor(processor), .cacheOriginalImage]) {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
        
        nameLabel.text = venue.name
        
        let categories = venue.categories.map { $0.name }
        categoryLabel.text = categories.joined(separator: ", ")
        
        addressLabel.text = venue.location.formattedAddress.joined(separator: "\n")
        ratingLabel.text = venue.rating?.description
        priceLabel.text = venue.price?.currency
        let descriptions = venue.listed?.groups[0].items.map { $0.description }
        descriptionLabel.text = getDescription(descriptions!)
    }
    
    func setupAppearances() {
        nameLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        nameLabel.textColor = UIColor.blue
        categoryLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        categoryLabel.textColor = UIColor.darkGray
        addressLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        ratingLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        priceLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        descriptionLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
    }
    
    func getDescription(_ descriptions: [String]) -> String {
        let newDescription = descriptions.filter { $0 != "" }
        if newDescription.count == 0 {
            return ""
        } else {
            let randomIndex = Int.random(in: 0 ..< newDescription.count)
            return newDescription[randomIndex]
        }
    }
    
    // MARK: Map
    
    func setupMapView() {
        let location = CLLocationCoordinate2D(latitude: venue.location.lat, longitude: venue.location.lng)
        
        let latDelta: CLLocationDegrees = 0.001
        let lngDelta: CLLocationDegrees = 0.001
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lngDelta)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func addVenuePin() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = venue.name
        annotation.subtitle = "Distance: \(venue.location.distance)"
        mapView.addAnnotation(annotation)
    }
}

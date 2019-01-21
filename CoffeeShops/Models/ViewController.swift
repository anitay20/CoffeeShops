//
//  ViewController.swift
//  CoffeeShops
//
//  Created by anita on 12/10/18.
//  Copyright © 2018 anita. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var coffeeShopDetails = [Venue]()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var venuesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Welcome! Here are some coffee shops around the Envoy office."
        venuesTableView.rowHeight = 120.0
    }

    override func viewDidAppear(_ animated: Bool) {
        if coffeeShopDetails.isEmpty {
            fetchVenues()
        }
    }
    
    func constructURL(endpoint: String) -> URL {
        let clientID = ""
        let clientSecret = ""
        
        let baseUrl = "https://api.foursquare.com/v2"
        let version = "20180323"
        let limit = "15"
        let query = "coffeeshop"
        
        // Envoy's office
        let latLong = "37.7751,-122.3977"


        let url = "\(baseUrl)/\(endpoint)?client_id=\(clientID)&client_secret=\(clientSecret)&v=\(version)&limit=\(limit)&ll=\(latLong)&query=\(query)"
        guard let responseUrl = URL(string: url) else { return URL(string: baseUrl)! }
        return responseUrl
    }
    
    func fetchVenues() {
        let exploreEndpoint = "venues/explore"
        let exploreUrlString = constructURL(endpoint: exploreEndpoint)
        
        URLSession.shared.dataTask(with: exploreUrlString) { (data, urlResponse, error) in
            guard let data = data, error == nil, urlResponse != nil else {
                print("Something went wrong")
                return
            }
            
            do {
                let venues = try JSONDecoder().decode(VenueAPIResponse.self, from: data)
                guard let groups = venues.response.groups else { return }
                let coffeeShops = groups[0].items.map { $0.venue }
                let coffeeShopIDs = coffeeShops.map { $0.id }
                
                self.fetchVenueDetails(coffeeShopIDs)
                
                DispatchQueue.main.async {
                    self.venuesTableView.reloadData()
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }
 
    func fetchVenueDetails(_ ids: [String]) {
        let dispatchGroup = DispatchGroup()
        for id in ids {
            dispatchGroup.enter()
            
            let venuesEndpoint = "venues/\(id)"
            let venuesUrl = self.constructURL(endpoint: venuesEndpoint)
            URLSession.shared.dataTask(with: venuesUrl) { (data, urlResponse, error) in
                guard let data = data, error == nil, urlResponse != nil else {
                    print("getting ids didn't work")
                    return
                }
                do {
                    let venue = try JSONDecoder().decode(VenueAPIResponse.self, from: data)
                    guard let eachVenue = venue.response.venue else { return }
                    self.coffeeShopDetails.append(eachVenue)
                    
                    DispatchQueue.main.async {
                        self.venuesTableView.reloadData()
                    }
                } catch let error {
                    print(error)
                }
                dispatchGroup.leave()
                }.resume()
        }
        dispatchGroup.notify(queue: .main) {
            print("Finished All Requests")
        }
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coffeeShopDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VenueCell") as? VenueCell  else { return UITableViewCell() }
        cell.configureTheCell(coffeeShopDetails[indexPath.row])
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "details" {
            let viewController = segue.destination as! DetailsViewController
            let selectedCell = venuesTableView.indexPathForSelectedRow!
            viewController.venue = coffeeShopDetails[selectedCell.item]
            
            venuesTableView.deselectRow(at: selectedCell, animated: false)
        }
    }
    
}

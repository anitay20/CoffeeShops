//
//  ViewController.swift
//  CoffeeShops
//
//  Created by anita on 12/10/18.
//  Copyright © 2018 anita. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var coffeeShops = [Venue]()
    var coffeeShopIDs = [String]()
    var coffeeShopDetails = [Venue]()
    
    @IBOutlet weak var venuesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        venuesTableView.rowHeight = 120.0
    }

    override func viewDidAppear(_ animated: Bool) {
        downloadJSON()
    }
    
    func constructURL(endpoint: String) -> URL {
        let baseUrl = "https://api.foursquare.com/v2"
        let clientID = "UCZJZUK0ANMM54UPMX5HCMOJUNLW5DAPBXJ0LUCGLXYJP5QY"
        let clientSecret = "3OFWDQERPUCVSFJSZHBCPROGE3JSGU0WC2WLOWXY4M0JMHXX"
        //        let clientID = "P402HAXJU35OKOS2ZZLDC3QZ0JQPOZM3IWWQVF2ZR5FMW5MW"
        //        let clientSecret = "0RD2XLKTPVI11ZTXFH1RKWXOPJQC51IJ0IVCH1YJL4RUDXKF"
        let version = "20180323"
        let limit = "1"
        let latLong = "37.7751,-122.3977"
        let query = "coffeeshop"

        let url = "\(baseUrl)/\(endpoint)?client_id=\(clientID)&client_secret=\(clientSecret)&v=\(version)&limit=\(limit)&ll=\(latLong)&query=\(query)"
        guard let responseUrl = URL(string: url) else { return URL(string: baseUrl)! }
        return responseUrl
    }
    
    func downloadJSON() {
        
//        let exploreUrlString = "\(baseUrl)/\(exploreEndpoint)?client_id=\(clientID)&client_secret=\(clientSecret)&v=\(version)&limit=\(limit)&ll=\(latLong)&query=\(query)"
//        let url = URL(string: exploreUrlString)
        let exploreEndpoint = "venues/explore"
        let venuesEndpoint = "venues"
        
        let exploreUrlString = constructURL(endpoint: exploreEndpoint)
        
//        guard let downloadURL = exploreUrlString else { return }
        
        URLSession.shared.dataTask(with: exploreUrlString) { (data, urlResponse, error) in
            guard let data = data, error == nil, urlResponse != nil else {
                print("Something went wrong")
                return
            }
            
            do {
                let venues = try JSONDecoder().decode(VenueAPIResponse.self, from: data)
                guard let groups = venues.response.groups else { return }
                self.coffeeShops = groups[0].items.map { $0.venue }
                self.coffeeShopIDs = self.coffeeShops.map { $0.id }
                
                let dispatchGroup = DispatchGroup()
                for id in self.coffeeShopIDs {
                    dispatchGroup.enter()
                    let venuesUrl = self.constructURL(endpoint: venuesEndpoint)
//                    let venuesUrlString = "\(baseUrl)/\(venuesEndpoint)/\(id)?client_id=\(clientID)&client_secret=\(clientSecret)&v=\(version)&limit=\(limit)&ll=\(latLong)&query=\(query)"
//                    let url = URL(string: venuesUrlString)
                    
//                    guard let venuesUrl = url else { return }
                    URLSession.shared.dataTask(with: venuesUrl) { (data, urlResponse, error) in
                        guard let data = data, error == nil, urlResponse != nil else {
                            print("Something went wrong")
                            return
                        }
                        print("Finished \(id)")
                        do {
                            let venue = try JSONDecoder().decode(VenueAPIResponse.self, from: data)
                            print(venue)
                            guard let eachVenue = venue.response.venue else { return }
                            self.coffeeShopDetails.append(eachVenue)
                        } catch let error {
                            print(error)
                        }
                        dispatchGroup.leave()
                    }.resume()
                }
                dispatchGroup.notify(queue: .main) {
                    print("Finished All Requests")
                }
                
                DispatchQueue.main.async {
                    self.venuesTableView.reloadData()
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coffeeShops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VenueCell") as? VenueCell  else { return UITableViewCell() }
        cell.configureTheCell(coffeeShops[indexPath.row])
        return cell
    }
}

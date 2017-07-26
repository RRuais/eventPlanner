//
//  detailViewController.swift
//  eventPlanner
//
//  Created by Rich Ruais on 7/26/17.
//  Copyright © 2017 Rich Ruais. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Index    \(index)")
        getEvent()
    }
    
    func getEvent() {
        nameLabel.text = eventsList[index].name
        addressLabel.text = eventsList[index].address
        priceLabel.text = eventsList[index].price
        dateTimeLabel.text = eventsList[index].dateTime
        let eventImageUrl = eventsList[index].imageUrl
        let url = URL(string: eventImageUrl!)
        let request = URLRequest(url: url!)
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error)
            }
            DispatchQueue.main.async(execute: {
                self.eventImage.image = UIImage(data: data!)
            })
        }).resume()

    }

    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

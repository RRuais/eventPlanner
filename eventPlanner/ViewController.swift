//
//  ViewController.swift
//  eventPlanner
//
//  Created by Rich Ruais on 7/25/17.
//  Copyright © 2017 Rich Ruais. All rights reserved.

import UIKit

struct Event {
    var name: String!
    var image: UIImage?
    var price: String!
    var address: String!
    var dateTime: String!
    var imageUrl: String?
    var title: String?
}

var eventsList = [Event]()

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let userDefaults = Foundation.UserDefaults.standard
    let ed = EventDatabase()
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(ViewController.refresh(sender:)),
                                 for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView?.addSubview(refreshControl)
        loadEvents()
    }
    
    func refresh(sender:AnyObject) {
        self.loadEvents()
        refreshControl.endRefreshing()
    }
    
    func loadEvents() {
        eventsList.removeAll()
        ed.retrieveEvents()
        if let value = userDefaults.array(forKey: "events") {
            if let events = value as? [[String : String]] {
                for event in events {
                    let newEvent = Event.init(name: event["name"], image: nil, price: event["price"], address: event["address"], dateTime: event["dateTime"], imageUrl: event["imageUrl"], title: event["title"])
                    print("New Event       \(newEvent)")
                    eventsList.append(newEvent)
                    tableView.reloadData()
                }
            }
        }
    }

    @IBAction func addEventAction(_ sender: Any) {
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "event", for: indexPath)
        let cellImage = cell.viewWithTag(1) as! UIImageView
        let nameLabel = cell.viewWithTag(2) as! UILabel
        nameLabel.text = eventsList[indexPath.row].name
        let dateTimeLabel = cell.viewWithTag(3) as! UILabel
        dateTimeLabel.text = eventsList[indexPath.row].dateTime
        let priceLabel = cell.viewWithTag(4) as! UILabel
        priceLabel.text = eventsList[indexPath.row].price
        
        let eventImageUrl = eventsList[indexPath.row].imageUrl
            let url = URL(string: eventImageUrl!)
            let request = URLRequest(url: url!)
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error)
                }
                DispatchQueue.main.async(execute: {
                   cellImage.image = UIImage(data: data!)
                })
        }).resume()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detail", sender: indexPath);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detail") {
            print("Perpare for segue 2")
            let controller = segue.destination as! DetailViewController
            let row = (sender as! NSIndexPath).row;
            controller.index = row
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ed.deleteEvent(title: eventsList[indexPath.row].title!)
            eventsList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    
}


//
//  ViewController.swift
//  appStudy
//
//  Created by Clement  Wekesa on 04/11/2020.
//

import UIKit
import Foundation

@available(iOS 10.0, *)
class HomeViewController: UIViewController {

    @IBOutlet weak var cityTable: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var places: [Places]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        fetchPlaces()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchPlaces()
    }
    
    func fetchPlaces() {
        do {
            places = try context.fetch(Places.fetchRequest())
            DispatchQueue.main.async {
                self.cityTable.reloadData()
            }
        } catch {
            places = []
        }
    }
}

@available(iOS 10.0, *)
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var place: Places
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell")!
        if let places = places {
            place = places[indexPath.row]

            cell.textLabel?.text = place.name
        }
        return cell
    }
    
    // Enable deletion of cell
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, actionPerformed: (Bool) -> ()) in
            if let deletePlace = self.places?[indexPath.row] {
                self.context.delete(deletePlace)
                do {
                    try self.context.save()
                } catch {
                    // Notify the user it failed
                }
                self.fetchPlaces()
            }
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let place = places?[indexPath.row] else { return }
    
        let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: "CityViewController") as! CityViewController
        destinationVC.place = place
        self.navigationController?.pushViewController(destinationVC, animated: true)

    }
}

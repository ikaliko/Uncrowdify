//
//  StoresViewController.swift
//  Uncrowdify
//
//  Created by Ilia Kaliko on 3/29/20.
//  Copyright © 2020 Obsessive Coders, Inc. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseUI
import CodableFirebase
import CoreLocation

let currentLocation = CLLocation(latitude: 37.4841875, longitude: -122.1497602)

class StoresViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    
    let db = Firestore.firestore()
    var stores = [Store]()

    override func viewDidLoad() {
        super.viewDidLoad()

        db.collection("stores").order(by: "name").addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error fetching: \(err)")
            } else {
                var newStores = [Store]()
                for document in querySnapshot!.documents {
                    do {
                        let store = try FirestoreDecoder().decode(Store.self, from: document.data())
                        newStores.append(store)
                    }
                    catch {
                        print(error)
                    }
                }
                self.stores = newStores
                self.tableView.reloadData()
            }
            

        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension StoresViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let store = stores[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCell", for: indexPath) as! StoreCell
        let storeLocation = CLLocation(latitude: store.location.latitude, longitude: store.location.longitude)
        let miles = storeLocation.distance(from: currentLocation) / 1609.344
        cell.storeImageView.image = UIImage(named: store.name.lowercased()) ?? UIImage(systemName: "cart")
        cell.nameLabel.text = String(format: "%@, %@ - %3.1f miles", store.name, store.city, miles)
        cell.capacityLabel.text = String(format: "Capacity %d, Area %3.1fK SqFt", Int(store.capacity), store.area/1000.0)
        return cell
    }
    
}

extension StoresViewController: UITableViewDelegate {
    
}

class StoreCell: UITableViewCell {
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var capacityLabel: UILabel!
}

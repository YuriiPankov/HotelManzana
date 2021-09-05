//
//  RegistrationTableViewController.swift
//  HotelManzana
//
//  Created by Yurii Pankov on 06.08.2021.
//

import UIKit

class RegistrationTableViewController: UITableViewController {
    
    var registrations: [Registration] = []
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        return dateFormatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return registrations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegistrationCell", for: indexPath)
        let registrationData = registrations[indexPath.row]
        
        cell.textLabel?.text = "\(registrationData.firstName) \(registrationData.lastName)"
        cell.detailTextLabel?.text = "\(dateFormatter.string(from: registrationData.checkInDate)) - \(dateFormatter.string(from: registrationData.checkOutDate)): \(registrationData.roomType.name)"

        return cell
    }
    
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        guard let source = segue.source as? AddRegistrationTableViewController,
              let registration = source.registration
        else {return}
        
        registrations.append(registration)
        tableView.reloadData()
    }
    
    @IBSegueAction func viewRegistrCell(_ coder: NSCoder, sender: Any?) -> AddRegistrationTableViewController? {
        guard let cell = sender as? UITableViewCell,
              let indexPath = tableView.indexPath(for: cell)
        else {return nil}
        
        let registration = registrations[indexPath.row]
       
        return AddRegistrationTableViewController(coder: coder, registrationData: registration)
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    

}

//
//  AirportTableViewController.swift
//  Airports
//
//  Created by Joep on 28-09-17.
//  Copyright © 2017 Joep. All rights reserved.
//

import UIKit

class AirportTableViewController: UITableViewController, UISearchBarDelegate {

    var airportDatabaseHelper : AirportDatabaseHelper!
    var airports = [Airport]()
    var airportsFiltered = [Airport]()
    @IBOutlet weak var searchBar: UISearchBar!
    var searchBarActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        airportDatabaseHelper = AirportDatabaseHelper()
        airports = airportDatabaseHelper.getAllAirports()
        airportsFiltered = airports
        
        searchBar.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return airportsFiltered.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "AirportTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AirportTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PersonTableViewCell.")
        }

       // let airport = airportGroups[indexPath.section][indexPath.row]
        let airport = airportsFiltered[indexPath.row]

        cell.airportIcao.text = airport.icao
        cell.airportName.text = airport.name
        cell.airportLocation.text = airport.municipality
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueAirportView",
            let nextScene = segue.destination as? AirportDetailViewController ,
            let indexPath = self.tableView.indexPathForSelectedRow {
            let selectedAirport = airportsFiltered[indexPath.row]
            nextScene.airport = selectedAirport
        }
    }

    // MARK: - Search bar controls
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        
        //Hide the keyboard
        searchBar.resignFirstResponder()
        
        //Return to initial view and show all airports
        airportsFiltered = airports
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
     searchBarActive = false
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("bookmark clicked")
        searchBarActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Show airports
        airportsFiltered = airports.filter{(($0.name?.contains(searchText))! || ($0.icao?.contains(searchText.uppercased()))!)}
        tableView.reloadData()
    }
}

//
//  AllHeroesTableViewController.swift
//  FIT5140-Week03-Lab
//
//  Created by Mayank Kamra on 21/8/20.
//  Copyright © 2020 Mayank Kamra. All rights reserved.
//

import UIKit

class AllHeroesTableViewController: UITableViewController, AddSuperHeroDelegate, UISearchResultsUpdating {
    
    let SECTION_HEROES = 0
    let SECTION_INFO = 1
    let CELL_HERO = "heroCell"
    let CELL_INFO = "totalHeroesCell"
    
    var allHeroes: [SuperHero] = []
    var filteredHeroes: [SuperHero] = []
    
    weak var superHeroDelegate: AddSuperHeroDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        createDefaultHeroes()
        
        filteredHeroes = allHeroes
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Heroes"
        navigationItem.searchController = searchController
        
        //this view controller decides how the search controller is presented
        definesPresentationContext = true
    }
    
    // MARK: Search Controller Delegate
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {
            return
        }
        
        if searchText.count > 0 {
            filteredHeroes = allHeroes.filter({ (hero: SuperHero) -> Bool in return hero.name.lowercased().contains(searchText) })
        } else {
            filteredHeroes = allHeroes
        }
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == SECTION_HEROES {
            return filteredHeroes.count
        }
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == SECTION_HEROES {
            let heroCell = tableView.dequeueReusableCell(withIdentifier: CELL_HERO, for: indexPath) as! SuperHeroTableViewCell
            let hero = filteredHeroes[indexPath.row]
            
            heroCell.nameLabel.text = hero.name
            heroCell.abilitiesLabel.text = hero.abilities
            
            return heroCell
        }
        
        
        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_INFO, for: indexPath)
        cell.textLabel?.text = "\(filteredHeroes.count) heroes in the database"
        cell.textLabel?.textColor = .secondaryLabel
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SECTION_INFO {
            tableView.deselectRow(at: indexPath, animated: false)
            return
        }
        
        if superHeroDelegate?.addSuperHero(newHero: filteredHeroes[indexPath.row]) ?? false {
            navigationController?.popViewController(animated: false)
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        displayMessage(title: "Party Full", message: "Unable to add more members to party")
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "createHeroSegue" {
            let destination = segue.destination as! CreateSuperHeroViewController
            destination.superHeroDelegate = self
        }
    }
    
    // MARK AddSuperHero Delegate
    
    func addSuperHero(newHero: SuperHero) -> Bool {
        if allHeroes.contains(where: {$0.name == newHero.name}) { //Validate if the player already exists
            displayMessage(title: "Duplicate Name", message: "Player with this name already exists")
            return false
        }
        allHeroes.append(newHero)
        filteredHeroes.append(newHero)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: filteredHeroes.count - 1, section: 0)], with: .automatic)
        tableView.endUpdates()
        tableView.reloadSections([SECTION_INFO], with: .automatic)
        
        if allHeroes.contains(where: {$0.name == newHero.name}) { //Validate if the player has been added
            displayMessage(title: "Congratulations", message: "Player \(newHero.name) is a part of the gang now!")
        }
        
        return true
    }
    
    // MARK Create Defaults
    
    func createDefaultHeroes() {
        allHeroes.append(SuperHero(newName: "Bruce Wayne", newAbilities: "Money"))
        allHeroes.append(SuperHero(newName: "Superman", newAbilities: "Super Powered Alien"))
        allHeroes.append(SuperHero(newName: "Wonder Woman", newAbilities: "Goodness"))
        allHeroes.append(SuperHero(newName: "The Flash", newAbilities: "Speed"))
        allHeroes.append(SuperHero(newName: "Green Lantern", newAbilities: "Power Ring"))
        allHeroes.append(SuperHero(newName: "Cyborg", newAbilities: "Robot Beep Beep"))
        allHeroes.append(SuperHero(newName: "Aquaman", newAbilities: "Atlantian"))
    }
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

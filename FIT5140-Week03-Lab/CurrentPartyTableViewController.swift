//
//  CurrentPartyTableViewController.swift
//  FIT5140-Week03-Lab
//
//  Created by Mayank Kamra on 21/8/20.
//  Copyright © 2020 Mayank Kamra. All rights reserved.
//

import UIKit

class CurrentPartyTableViewController: UITableViewController, AddSuperHeroDelegate {
    
    let SECTION_PARTY = 0
    let SECTION_INFO = 1
    let CELL_HERO = "heroCell"
    let CELL_INFO = "partySizeCell"
    
    var currentParty:[SuperHero] = []

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch section {
        case SECTION_PARTY:
            return currentParty.count
        case SECTION_INFO:
            return 1
        default:
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        if indexPath.section == SECTION_PARTY {
            let partyCell = tableView.dequeueReusableCell(withIdentifier: CELL_HERO, for: indexPath) as! SuperHeroTableViewCell
            let hero = currentParty[indexPath.row]
            
            partyCell.nameLabel.text = hero.name
            partyCell.abilitiesLabel.text = hero.abilities
            
            return partyCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_INFO, for: indexPath)
        
        cell.textLabel?.textColor = .secondaryLabel
        cell.selectionStyle = .none
        if currentParty.count > 0 {
            cell.textLabel?.text = "\(currentParty.count)/6 heroes in Party"
        } else {
            cell.textLabel?.text = "No Heroes in party. Click + to add some"
        }

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == SECTION_PARTY {
            return true
        }
        return false
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete && indexPath.section == SECTION_PARTY {
            tableView.performBatchUpdates({
                //Delete the row from data source
                self.currentParty.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadSections([SECTION_INFO], with: .automatic)
            }, completion: nil)
        }    
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "allHeroesSegue" {
            let destination = segue.destination as! AllHeroesTableViewController
            destination.superHeroDelegate = self
        }
    }
    
    // MARK: add super hero delegate
    
    func addSuperHero(newHero: SuperHero) -> Bool {
        if currentParty.count >= 6 {
            return false
        }
        
        tableView.performBatchUpdates({
            currentParty.append(newHero)
            tableView.insertRows(at: [IndexPath(row: currentParty.count - 1, section: SECTION_PARTY)], with: .automatic)
        }, completion: nil)
        return true
    }
}

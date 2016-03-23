//
//  MeusLugaresViewController.swift
//  LocaisFavoritos
//
//  Created by Fernando Augusto de Marins on 16/02/16.
//  Copyright © 2016 Fernando Augusto de Marins. All rights reserved.
//

import UIKit


class MeusLugaresViewController: UITableViewController {
    
    let cellIdentifier = "cellIdentifier"
    let newPlaceSegue = "newPlace"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array.sharedInstance.places.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        cell.textLabel?.text = Array.sharedInstance.places[indexPath.row]["name"]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        Array.sharedInstance.activePlace = indexPath.row
        
        return indexPath
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == newPlaceSegue {
            Array.sharedInstance.activePlace = -1
        }
    }


}

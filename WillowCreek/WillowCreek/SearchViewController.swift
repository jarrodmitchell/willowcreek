//
//  SearchViewController.swift
//  WillowCreek
//
//  Created by Jarrod Mitchell on 8/30/19.
//  Copyright © 2019 Jarrod Mitchell. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var tenants: [Tenant]!
    var filteredArray = [Tenant]()
    var messageDelegate: MessageViewControllerDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredArray.count > 0 {
        }else{
            filteredArray = tenants
        }
        return filteredArray.count
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        messageDelegate.getTenant(tenant: filteredArray[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        
        if filteredArray.count > 0 {
            cell.textLabel?.text = filteredArray[indexPath.row].name
            cell.detailTextLabel?.text = filteredArray[indexPath.row].address
        }
        
        return cell
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredArray = tenants.filter { (tenant) -> Bool in
            if let search = searchBar.text {
                if tenant.address.contains(search) {
                    return true
                }
            }
            return false
        }
        
        tableView.reloadData()
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

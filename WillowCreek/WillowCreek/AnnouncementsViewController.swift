//
//  AnnouncementsViewController.swift
//  WillowCreek
//
//  Created by Jarrod Mitchell on 8/30/19.
//  Copyright © 2019 Jarrod Mitchell. All rights reserved.
//

import UIKit

class AnnouncementsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var announcements: [Announcement]!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        title = "Announcements"
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return announcements.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell") {
            cell.textLabel?.text = announcements[indexPath.row].date ?? ""
            cell.detailTextLabel?.text = announcements[indexPath.row].message ?? ""
            return cell
        }
        
        return UITableViewCell.init()
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

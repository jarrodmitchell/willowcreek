//
//  MessagesViewController.swift
//  WillowCreek
//
//  Created by Jarrod Mitchell on 8/29/19.
//  Copyright © 2019 Jarrod Mitchell. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var messages: [Message]?
    var uType: String!
    var uId: String?
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 130
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let messages = messages {
            return messages.count
        }else{
            return 0
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessagesTableViewCell
        
        if let m = messages?[indexPath.row] {
            cell.dateLabel.text = m.date
            cell.messageLabel.text = m.message
            cell.titleLabel.text = m.title
            cell.replyButton.tag = indexPath.row
        }
        
        return cell
    }
    

    @IBAction func replyButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "replySegue", sender: (sender as! UIButton).tag)
    }
    
    
    
    //go to message view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! MessageViewController
        
        //if user is management pass that information to the message view controller
        if uType == "management" {
            destination.index = 2
            destination.recipient = "management"
            //or pass tenant info
        }else{
            destination.index = 0
            destination.recipient = self.messages![sender as! Int].sender
            
        }
        destination.replying = true
        destination.replyTitle = "RE: " + self.messages![sender as! Int].title
        destination.uId = self.uId
        destination.uType = self.uType
        destination.sender = self.messages![sender as! Int].recipient
        print("all added")
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

//
//  WorkOrderViewController.swift
//  WillowCreek
//
//  Created by Jarrod Mitchell on 8/25/19.
//  Copyright © 2019 Jarrod Mitchell. All rights reserved.
//

import UIKit

class WorkOrderViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var workersLabel: UILabel!
    @IBOutlet weak var updateTableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    
    var workOrder: WorkOrder!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = workOrder.title
        messageTextView.text = workOrder.message
        backgroundView.layer.cornerRadius = 4
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

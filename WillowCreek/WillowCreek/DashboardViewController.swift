//
//  DashboardViewController.swift
//  WillowCreek
//
//  Created by Jarrod Mitchell on 8/18/19.
//  Copyright © 2019 Jarrod Mitchell. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    var uId: String!
    var uName: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = uName
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MessageViewController {
            destination.uId = self.uId
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

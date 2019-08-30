//
//  ViewController.swift
//  WillowCreek
//
//  Created by Jarrod Mitchell on 8/17/19.
//  Copyright © 2019 Jarrod Mitchell. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var maintenance: Maintenance!
    var email: String!
    var password: String!
    var uid: String?
    var name: String?
    var uType: String?
    var address: String?
    var requestCount: Int?
    var workOrderCount: Int?
    var announcementCount: Int?
    var messageCount: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loginButton.layer.cornerRadius = 4
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard emailTextField.text?.isEmpty == false, passwordTextField.text?.isEmpty == false else
        {//verify that the user has filled in an email and password
            let alert = UIAlertController(title: "Empty Fields", message: "You must fill in all fields", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            return
        }
        
        email = emailTextField.text
        password = passwordTextField.text
        
        authUser()
    }
    
    
    
    func authUser() {
        let db = Firestore.firestore()
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Error logging in: " + error.localizedDescription)
            }
            else{
                print("Successfully logged in")
                guard let uid = result?.user.uid else{return}
                
                print("UId: " + uid)
                
                //get the type of tenant that the user is
                db.collection("users").document(uid).getDocument(completion: { (snapshot, error) in
                    if let error = error {
                        print("Error retrieving account type" + error.localizedDescription)
                    }else{
                        print("Successfully retrieved account type")
                        guard let data = snapshot?.data(), let type = data["type"] as? String else{return}
                        
                        //get user data
                        db.collection(type).document(uid).getDocument(completion: { (snapshot, error) in
                            if let error = error {
                                print("Error retrieving data" + error.localizedDescription)
                            }else{
                                print("Successfully retrieved data")
                                guard let data = snapshot?.data(), let first = data["first"] as? String, let last = data["last"] as? String else{return}
                                print("type: " + type)
                                self.uType = type
                                self.uid = uid
                                self.name = "\(first) \(last)"
                                
                                //retrieve data from Firebase for Tenants
                                if type == "tenants" {
                                    
                                    let maintenance = Maintenance(_id: "", first: "", last: "")
                                    maintenance.getMaintenance()
                                    
                                    db.collection("tenants").document(uid).addSnapshotListener({ (tenantSnapshot, error) in
                                        if let error = error {
                                            print("Error retrieving tenant address: " + error.localizedDescription)
                                        }else{
                                            print("Success getting tenant address")
                                            let address = tenantSnapshot?.data()!["address"] as! String
                                            self.address = address
                                            
                                            db.collection("workOrders").whereField("active", isEqualTo: true).whereField("address", isEqualTo: address).addSnapshotListener { (WorkOrderSnapshot, error) in
                                                if let error = error {
                                                    print("Error getting work order count: " + error.localizedDescription)
                                                }else{
                                                    print("Successfully retrieved work order count: " + String(WorkOrderSnapshot?.count ?? 0))
                                                    self.maintenance = maintenance
                                                    self.workOrderCount = WorkOrderSnapshot?.count ?? 0
                                                    
                                                    db.collection("messages").whereField("recipient", isEqualTo: uid).whereField("viewed", isEqualTo: false).addSnapshotListener({ (messageSnapshot, error) in
                                                        if let error = error {
                                                            print("Error getting message count: " + error.localizedDescription)
                                                        }else{
                                                            print("Successfully retrieved message count: " + String(messageSnapshot?.count ?? 0))
                                                            self.messageCount = messageSnapshot?.count ?? 0
                                                            
                                                            db.collection("announcements").addSnapshotListener({ (announcementSnapshot, error) in
                                                                if let error = error {
                                                                    print("Error retrieving announcement count: " + error.localizedDescription)
                                                                }else{
                                                                    print("Successfully retrieved announcement count: " + String(announcementSnapshot?.count ?? 0))
                                                                    self.announcementCount = announcementSnapshot?.count ?? 0
                                                                    self.performSegue(withIdentifier: "dashboardSegue", sender: nil)
                                                                }
                                                            })
                                                        }
                                                    })
                                                    
                                                }
                                            }
                                        }
                                    })
                                    
                                }else if type == "management" {
                                    //retrieve data from Firebase for Manangement
                                    let maintenance = Maintenance(_id: "", first: "", last: "")
                                    maintenance.getMaintenance()
                                    
                                    db.collection("workOrders").whereField("active", isEqualTo: true).whereField("reviewed", isEqualTo: false).addSnapshotListener({ (pendingWorkOrderSnapshot, error) in
                                        if let error = error {
                                            print("Error getting pending work orders: " + error.localizedDescription)
                                        }else{
                                            print("Successfuly retrieved pending work orders: " + String(pendingWorkOrderSnapshot?.count ?? 0))
                                            self.requestCount = pendingWorkOrderSnapshot?.count ?? 0
                                            
                                            db.collection("workOrders").whereField("active", isEqualTo: true).whereField("reviewed", isEqualTo: true).addSnapshotListener({ (activeWorkOrderSnapshot, error) in
                                                if let error = error {
                                                    print("Error getting active work orders: " + error.localizedDescription)
                                                }else{
                                                    print("Successfuly retrieved active work orders: " + String(activeWorkOrderSnapshot?.count ?? 0))
                                                    self.maintenance = maintenance
                                                    self.workOrderCount = activeWorkOrderSnapshot?.count ?? 0
                                                    
                                                    db.collection("messages").whereField("recipient", isEqualTo: "management").whereField("viewed", isEqualTo: false).addSnapshotListener({ (messageSnapshot, error) in
                                                        if let error = error {
                                                            print("Error getting message count: " + error.localizedDescription)
                                                        }else{
                                                            print("Successfully retrieved message count: " + String(messageSnapshot?.count ?? 0))
                                                            self.messageCount = messageSnapshot?.count ?? 0
                                                            self.performSegue(withIdentifier: "dashboardSegue", sender: nil)
                                                        }
                                                    })
                                                }
                                            })
                                        }
                                    })
                                    
                                }else{
                                    //retrieve data from Firebase for Maintenance
                                    let maintenance = Maintenance(_id: uid, first: first, last: last)
                                    maintenance.getMaintenance()
                                    
                                    db.collection("workOrders").whereField("active", isEqualTo: true).whereField("reviewed", isEqualTo: true).whereField("maintenance", arrayContains: uid).addSnapshotListener({ (workOrderSnapshot, error) in
                                        if let error = error {
                                            print("Error getting active work orders: " + error.localizedDescription)
                                        }else{
                                            print("Successfuly retrieved active work orders: " + String(workOrderSnapshot?.count ?? 0))
                                            self.workOrderCount = workOrderSnapshot?.count ?? 0
                                            self.maintenance = maintenance
                                            self.performSegue(withIdentifier: "dashboardSegue", sender: nil)
                                        }
                                    })
                                }
                            }
                        })
                    }
                })
                
            }
        }
    }
    
    
    
    //Assign values to dashboard variables
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigation = segue.destination as? UINavigationController, let destination = navigation.visibleViewController as? DashboardViewController else {return}
        print("prepare")
        
        destination.maintenance = maintenance
        destination.uName = name
        destination.uType = uType
        destination.uId = uid
        destination.workOrderCount = self.workOrderCount
        
        switch uType {
        case "tenants":
            destination.address = address
            destination.announcementCount = announcementCount
            destination.messageCount = messageCount
        case "management":
            destination.requestCount = self.requestCount
            destination.messageCount = self.messageCount
        default:
            break
        }
        
    }


}

